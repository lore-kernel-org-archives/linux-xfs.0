Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1J85NeA090289 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 02:05:24 -0600
Received: from web30205.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 93C50132DC1
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 00:04:51 -0800 (PST)
Received: from web30205.mail.mud.yahoo.com (web30205.mail.mud.yahoo.com
	[209.191.69.52]) by cuda.sgi.com with SMTP id i2YmtKoiA46Wv0CM
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 00:04:51 -0800 (PST)
Message-ID: <994244.58509.qm@web30205.mail.mud.yahoo.com>
Date: Thu, 19 Feb 2009 00:04:49 -0800 (PST)
From: <raksac@yahoo.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
In-Reply-To: <4994FD8C.5020303@sandeen.net>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


I think I am getting closer now. Can you suggest what
to look for from this oops -


Stack traceback for pid 192
0xad12f030      192       11  1    0   R  0xad12f1d0
*xfsdatad/0
esp        eip        Function (args)
0xaff37eec 0x7815007b map_vm_area+0xc3
0xaff37ef0 0x7814007b find_get_pages_contig+0x3d
0xaff37ef8 0x78156c04 free_block+0x41
0xaff37f20 0x78156d9b cache_flusharray+0x63
0xaff37f3c 0x78156b4e kmem_cache_free+0x52
0xaff37f4c 0x7814296f mempool_free_slab+0xb
0xaff37f50 0x78142954 mempool_free+0x60
0xaff37f60 0x781f429f xfs_destroy_ioend+0x4e
0xaff37f6c 0x781f43d0 xfs_end_bio_read+0x5
0xaff37f70 0x78128498 run_workqueue+0x71
0xaff37f74 0x781f43cb xfs_end_bio_read
0xaff37f8c 0x78128634 worker_thread+0xd9
0xaff37fac 0x781164c0 default_wake_function
0xaff37fc8 0x7812855b worker_thread
0xaff37fcc 0x7812ad7a kthread+0xc1
0xaff37fd8 0x7812acb9 kthread
0xaff37fe4 0x781036df kernel_thread_helper+0x7

Thanks,
Rakesh

--- Eric Sandeen <sandeen@sandeen.net> wrote:

> raksac@yahoo.com wrote:
> > Guys,
> > 
> > Thank you for taking the time to write. Having
> said
> > where I stand and we are kind of on the same page.
> Is
> > there something I can expect which would put me on
> a
> > track of nailing down the problem. It maybe a wild
> > goose chase but something that I can start with
> would
> > be much appreciated.
> 
> Just random debugging thoughts...
> 
> Try stock 2.6.28.4, to see if you have the same
> problem.  If so, and
> esp. if you also see it on 2.6.29, then you'll get a
> lot more attention
> here.  :)
> 
> If not, then it's something with your backport most
> likely.  Figure out
> what you had to backport and see if it's possibly
> causing the error(s).
> 
> If it's locked up, try sysrq-w (echo w >
> /proc/sysrq-trigger) and look
> at dmesg to see if other threads are locked against
> it.  Figure out why.
> 
> On the oops try memory debugging etc, see if you're
> referencing freed
> memory, using corrupt lists, etc.
> 
> Look for other errors in the logs prior to this.
> 
> See if your filesystem is corrupted.
> 
> Bug Red Hat for XFS support, assuming you're
> actually buying RHEL5
> support from them.  :)
> 
> > Unfortunately there is no distro which gets closer
> to
> > where mainline lives today. Reading the changelog
> > there are several problems that I have already
> come
> > across and has convincingly driven me to take on
> this
> > task.
> 
> well certainly there are distros with kernels newer
> than 2.6.18, but it
> depends on your needs & goals I guess.
> 
> Good luck,
> -Eric
> 
> -Eric
> 



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
