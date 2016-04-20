Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54B487CA0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 06:24:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F16968F8039
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 04:24:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fau9Jjkar65TPAVb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2016 04:24:48 -0700 (PDT)
Date: Wed, 20 Apr 2016 07:24:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [XFS] Any process to a particular XFS device hung in D state
	forever.
Message-ID: <20160420112445.GA2773@laptop.bfoster>
References: <CAJBkf_egQ1WdYHm5iRXCt4=CgraN4A=HfLvvsZxJEi7g4sUf5A@mail.gmail.com>
	<20160419113038.GA2649@laptop.bfoster>
	<CAJBkf_dEDTE-2qCObaHPZgmu50nW3HP-DPFNAPyaMfuLJX+7NQ@mail.gmail.com>
	<20160419193435.GA2667@laptop.bfoster>
	<CAJBkf_cNm3Xoun+PnzgdKEGz0zQx2JGNhS4KoTuDYjPm=78w+g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJBkf_cNm3Xoun+PnzgdKEGz0zQx2JGNhS4KoTuDYjPm=78w+g@mail.gmail.com>
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

On Wed, Apr 20, 2016 at 01:49:49PM +0800, Hugo Kuo wrote:
> Hi XFS team,
> 
> 
> Here's the lsof output of the grouped result of any openfile happens on
> problematic disks. The full log of xfs_repair -n is included in this gist
> as well. The xfs_repair recommend to contact xfs mailing list in the end of
> the command.
> 
> https://gist.github.com/HugoKuo/95613d7864aa0a1343615642b3309451
> 
> Perhaps I should go ahead to reboot the machine and run the xfs_repair
> again.  Please find my answers inlines.
> 

Yes, repair is crashing in this case. Best to try xfs_repair after
you've rebooted and mounted/umounted the fs to replay the log. If it's
still crashing at that point, we'll probably want a metadata image of
the fs, if possible (though there's a good chance a newer xfsprogs has
the problem fixed).

> 
> On Wed, Apr 20, 2016 at 3:34 AM, Brian Foster <bfoster@redhat.com> wrote:
> 
> >
> > So there's definitely some traces waiting on AGF locks and whatnot, but
> > also many traces that appear to be waiting on I/O. For example:
> >
> 
> Yes, those I/O waiting is the original problem of this thread. It looks
> like the disk was locked. All these I/O waiting for same disk (a multipath
> entry).
> 
> 
> >
> > kernel: swift-object- D 0000000000000008     0  2096   1605 0x00000000
> > kernel: ffff8877cc2378b8 0000000000000082 ffff8877cc237818 ffff887ff016eb68
> > kernel: ffff883fd4ab6b28 0000000000000046 ffff883fd4bd9400 00000001e7ea49d0
> > kernel: ffff8877cc237848 ffffffff812735d1 ffff885fa2e4a5f8 ffff8877cc237fd8
> > kernel: Call Trace:
> > kernel: [<ffffffff812735d1>] ? __blk_run_queue+0x31/0x40
> > kernel: [<ffffffff81539455>] schedule_timeout+0x215/0x2e0
> > kernel: [<ffffffff812757c9>] ? blk_peek_request+0x189/0x210
> > kernel: [<ffffffff8126d9b3>] ? elv_queue_empty+0x33/0x40
> > kernel: [<ffffffffa00040a0>] ? dm_request_fn+0x240/0x340 [dm_mod]
> > kernel: [<ffffffff815390d3>] wait_for_common+0x123/0x180
> > kernel: [<ffffffff810672b0>] ? default_wake_function+0x0/0x20
> > kernel: [<ffffffffa0001036>] ? dm_unplug_all+0x36/0x50 [dm_mod]
> > kernel: [<ffffffffa0415b56>] ? _xfs_buf_read+0x46/0x60 [xfs]
> > kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
> > kernel: [<ffffffff815391ed>] wait_for_completion+0x1d/0x20
> > kernel: [<ffffffffa041503b>] xfs_buf_iowait+0x9b/0x100 [xfs]
> > kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
> > kernel: [<ffffffffa0415b56>] _xfs_buf_read+0x46/0x60 [xfs]
> > kernel: [<ffffffffa0415c1b>] xfs_buf_read+0xab/0x100 [xfs]
> >
> >
> > Are all of these swift processes running against independent storage, or
> > one big array? Also, can you tell (e.g., with iotop) whether progress is
> > being made here, albiet very slowly, or if the storage is indeed locked
> > up..?
> >
> > There're 240+ swift processes in running.
> All stuck swift processes were attempting to access same disk.  I can
> confirm it's indeed locked rather than slowly. By monitoring io via iotop.
> There's 0 activity one the problematic mount point.
> 
> 
> > In any event, given the I/O hangs, the fact that you're on an old distro
> > kernel and you have things like multipath enabled, it might be
> > worthwhile to see if you can rule out any multipath issues.
> >
> >
> To upgrade the kernel for CentOS6.5 may not the option for the time being
> but it definitely worth to give it try by picking up one of nodes for
> testing later. As for the multipath, yes I did suspect some mystery problem
> with multipath + XFS under a certain loading. But it's more like a XFS and
> inode related hence I start to investigate from XFS. If there's no chance
> to move forward in XFS, I might break the multipath and observe the result
> for awhile.
> 

It's hard to pinpoint something to the fs when there's a bunch of hung
I/Os. You probably want to track down the source of those problems
first.

Brian

> 
> >
> > 'umount -l' doesn't necessarily force anything. It just lazily unmounts
> > the fs from the namespace and cleans up the mount once all references
> > are dropped. I suspect the fs is still mounted internally.
> >
> > Brian
> >
> >
> Thanks // Hugo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
