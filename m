Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E30217CA0
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 14:34:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CFB4AC002
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 12:34:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fANCNWMcAoXevMRu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Apr 2016 12:34:40 -0700 (PDT)
Date: Tue, 19 Apr 2016 15:34:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [XFS] Any process to a particular XFS device hung in D state
	forever.
Message-ID: <20160419193435.GA2667@laptop.bfoster>
References: <CAJBkf_egQ1WdYHm5iRXCt4=CgraN4A=HfLvvsZxJEi7g4sUf5A@mail.gmail.com>
	<20160419113038.GA2649@laptop.bfoster>
	<CAJBkf_dEDTE-2qCObaHPZgmu50nW3HP-DPFNAPyaMfuLJX+7NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJBkf_dEDTE-2qCObaHPZgmu50nW3HP-DPFNAPyaMfuLJX+7NQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Hugo Kuo <hugo@swiftstack.com>
Cc: Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

On Tue, Apr 19, 2016 at 09:24:55PM +0800, Hugo Kuo wrote:
> Hi Brain,
> 
> Here's the a gist include sysrq-trigger and strace of one of the hanging
> $ls result. This is from another problematic disk (d817) on the same server.
> 
> https://gist.github.com/HugoKuo/8eb8208bbb7a7f562a6c9a3eafa8f37f
> 
> It looks like the hanging $ls is stuck on getting extend attribute of a
> file on this disk. The full output can be found in the link above.
> 
> lstat("/srv/node/d864/tmp/tmpIRYFaW", {st_mode=S_IFREG|0600, st_size=0,
> ...}) = 0
> capget(0x20080522, 0, NULL) = -1 EFAULT (Bad address)
> getxattr("/srv/node/d864/tmp/tmpIRYFaW", "security.capability"
> 

So there's definitely some traces waiting on AGF locks and whatnot, but
also many traces that appear to be waiting on I/O. For example:

kernel: swift-object- D 0000000000000008     0  2096   1605 0x00000000
kernel: ffff8877cc2378b8 0000000000000082 ffff8877cc237818 ffff887ff016eb68
kernel: ffff883fd4ab6b28 0000000000000046 ffff883fd4bd9400 00000001e7ea49d0
kernel: ffff8877cc237848 ffffffff812735d1 ffff885fa2e4a5f8 ffff8877cc237fd8
kernel: Call Trace:
kernel: [<ffffffff812735d1>] ? __blk_run_queue+0x31/0x40
kernel: [<ffffffff81539455>] schedule_timeout+0x215/0x2e0
kernel: [<ffffffff812757c9>] ? blk_peek_request+0x189/0x210
kernel: [<ffffffff8126d9b3>] ? elv_queue_empty+0x33/0x40
kernel: [<ffffffffa00040a0>] ? dm_request_fn+0x240/0x340 [dm_mod]
kernel: [<ffffffff815390d3>] wait_for_common+0x123/0x180
kernel: [<ffffffff810672b0>] ? default_wake_function+0x0/0x20
kernel: [<ffffffffa0001036>] ? dm_unplug_all+0x36/0x50 [dm_mod]
kernel: [<ffffffffa0415b56>] ? _xfs_buf_read+0x46/0x60 [xfs]
kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
kernel: [<ffffffff815391ed>] wait_for_completion+0x1d/0x20
kernel: [<ffffffffa041503b>] xfs_buf_iowait+0x9b/0x100 [xfs]
kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
kernel: [<ffffffffa0415b56>] _xfs_buf_read+0x46/0x60 [xfs]
kernel: [<ffffffffa0415c1b>] xfs_buf_read+0xab/0x100 [xfs]
...

Are all of these swift processes running against independent storage, or
one big array? Also, can you tell (e.g., with iotop) whether progress is
being made here, albiet very slowly, or if the storage is indeed locked
up..?

In any event, given the I/O hangs, the fact that you're on an old distro
kernel and you have things like multipath enabled, it might be
worthwhile to see if you can rule out any multipath issues.

> 
> As for the xfs_repair output in link
> https://gist.github.com/HugoKuo/76f65bdc0b860ca6ed5e786f8c43da0e . Your
> question is if the node been force rebooted. The answer is NO.   I* didn't
> reboot* this server yet. I force unmounted it via *$umount -l <dev>* . Then
> run the xfs_repair.
>  

'umount -l' doesn't necessarily force anything. It just lazily unmounts
the fs from the namespace and cleans up the mount once all references
are dropped. I suspect the fs is still mounted internally.

Brian

> $ls /srv/node/d864/tmp > test.d864
> $ls /srv/node/d864/tmp
> 
> 
> Here's the contents of test.d864
> https://gist.github.com/HugoKuo/25f93cd6daf5b0666a2ab85defd63a56
> 
> Thanks // Hugo
> 
> On Tue, Apr 19, 2016 at 7:30 PM, Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Tue, Apr 19, 2016 at 05:56:19PM +0800, Hugo Kuo wrote:
> > > Hi XFS team,
> > >
> > > We encountered a problem frequently in past three weeks. Our daemons
> > store
> > > data to XFS partition associate with xattr.
> > >
> > > Disk seems not responding since all processes to this disk in D state and
> > > can't be killed at all.
> > >
> > >    - It happens on several disks. I feel it's randomly.
> > >    - Reboot seems solve the problem temporarily.
> > >    - All disks are multipath devices.
> > >
> > >
> > > I suspected that's an issue from disk corrupted at beginning. But
> > smartctl
> > > doesn't show any clue about disk bad. And reboot makes the problem gone
> > > away.
> > >
> > >
> > >    - Any process to this disk is blocked. Even a simple $ls . Kernel log
> > >    <https://gist.github.com/HugoKuo/f87748786b26ea04fd9e1d86d9538293>
> >
> > Looks like it's waiting on an AGF buffer. The buffer could be held by
> > something else, but we don't have enough information from that one
> > trace. Could you get all of the blocked tasks when in this state (e.g.,
> > "echo w > /proc/sysrq-trigger")?
> >
> 
> 
> 
> 
> >
> > >    - I tested the disk by read bytes on block via $dd . It works fine
> > >    without any error in dmesg.
> > >    - The `xfs_repair -n` output of a problematic mount point [xfs_repair
> > -n]
> > >    <https://gist.github.com/HugoKuo/76f65bdc0b860ca6ed5e786f8c43da0e> .
> > It
> > >    is still processing.
> >
> > I presume this was run after a forced reboot..? If so, was the
> > filesystem remounted first to replay the log (xfs_repair -n doesn't
> > detect/warn about a dirty log, iirc). If the log was dirty, then repair
> > is a bit less interesting simply because some corruption is to be
> > expected in that scenario.
> >
> > >    - Kernel : Linux node9 2.6.32-573.8.1.el6.x86_64 #1 SMP Tue Nov 10
> > >    18:01:38 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> > >    - OS : CentOS release 6.5 (Final)
> > >    - XFS : xfsprogs.x86_64         3.1.1-14.el6
> > >
> > >
> > > There's an interesting behaviour of $ls command.
> > >
> > > * This is completed in 1sec. Very quick and give me the result in the
> > > test.d864 file $ls /srv/node/d864/tmp > test.d864
> > > * This is hanging $ls /srv/node/d864/tmp
> > >
> >
> > I'm not following you here. Are you missing an attachment (test.d864)?
> >
> > Brian
> >
> > > [image: Inline image 1]
> > >
> > > I suspect there's something wrong with imap. Is there a known bug ?
> > >
> > > Thanks // Hugo
> >
> >
> >
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> >
> >

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
