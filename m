Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 592E47F52
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 12:25:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAD90AC005
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 10:25:38 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id 48XvI7pPKxHaEHhn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 10:25:37 -0700 (PDT)
Date: Mon, 7 Oct 2013 19:25:35 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [bisected] xfs_repair refuses to run on cleanly mountable
	partition
Message-ID: <20131007172535.GG280@x4>
References: <20131007151637.GA280@x4> <5252D194.1010609@sandeen.net>
	<20131007152910.GB280@x4> <5252D51B.7010503@sandeen.net>
	<20131007154044.GC280@x4> <5252D919.50901@sandeen.net>
	<20131007165217.GF280@x4> <5252EB6F.5050502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5252EB6F.5050502@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <dchinner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2013.10.07 at 12:12 -0500, Eric Sandeen wrote:
> On 10/7/13 11:52 AM, Markus Trippelsdorf wrote:
> > On 2013.10.07 at 10:54 -0500, Eric Sandeen wrote:
> >> On 10/7/13 10:40 AM, Markus Trippelsdorf wrote:
> >>> On 2013.10.07 at 10:36 -0500, Eric Sandeen wrote:
> >>>> On 10/7/13 10:29 AM, Markus Trippelsdorf wrote:
> >>>>> On 2013.10.07 at 10:21 -0500, Eric Sandeen wrote:
> >>>>>> On 10/7/13 10:16 AM, Markus Trippelsdorf wrote:
> >>>>>>> x4 ~ # xfs_repair -V
> >>>>>>> xfs_repair version 3.2.0-alpha1
> >>>>>>>
> >>>>>>> x4 ~ # mount -o logbsize=256k /dev/sdc1 /mnt
> >>>>>>> ...
> >>>>>>> [ 6419.592649] XFS (sdc1): Mounting Filesystem
> >>>>>>> [ 6419.642480] XFS (sdc1): Ending clean mount
> >>>>>>>
> >>>>>>> x4 ~ # xfs_info /dev/sdc1
> >>>>>>> meta-data=/dev/sdc1              isize=256    agcount=4, agsize=61047552 blks
> >>>>>>>          =                       sectsz=4096  attr=2, projid32bit=0
> >>>>>>>          =                       crc=0
> >>>>>>> data     =                       bsize=4096   blocks=244190208, imaxpct=25
> >>>>>>>          =                       sunit=0      swidth=0 blks
> >>>>>>> naming   =version 2              bsize=4096   ascii-ci=0
> >>>>>>> log      =internal               bsize=4096   blocks=119233, version=2
> >>>>>>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> >>>>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>>>>>>
> >>>>>>> x4 ~ # umount /mnt
> >>>>>>>
> >>>>>>> x4 ~ # xfs_repair /dev/sdc1
> >>>>>>> Phase 1 - find and verify superblock...
> >>>>>>> Phase 2 - using internal log
> >>>>>>>         - zero log...
> >>>>>>> ERROR: The filesystem has valuable metadata changes in a log which needs to
> >>>>>>> be replayed.  Mount the filesystem to replay the log, and unmount it before
> >>>>>>> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> >>>>>>> the -L option to destroy the log and attempt a repair.
> >>>>>>> Note that destroying the log may cause corruption -- please attempt a mount
> >>>>>>> of the filesystem before doing this.
> >>>>>>
> >>>>>> What kernel are you running?  Does older xfs_repair behave differently?
> >>>>>> (use xfs_repair -n if you test an old xfsprogs, to preserve this state
> >>>>>> for debugging...)
> >>>>>
> >>>>> I'm running the latest git kernel 3.12.0-rc4. 
> >>>>> "xfs_repair -n" runs fine even with xfsprogs 3.2.0-alpha1...
> >>>>>
> >>>>>> Perhaps copying out or dumping the log w/ xfs_logprint would also help, 
> >>>>>> maybe start with:
> >>>>>>
> >>>>>> # xfs_logprint -t /dev/sdc1
> >>>>> xfs_logprint:
> >>>>>     data device: 0x821
> >>>>>     log device: 0x821 daddr: 976760888 length: 953864
> >>>>>
> >>>>>     log tail: 53376 head: 53376 state: <CLEAN>
> >>>>
> >>>> Funky.
> >>>>
> >>>> How about an xfs_repair -v (for verbose).
> >>> ...
> >>>         - zero log..
> >>> zero_log: head block 53048 tail block 49064
> >>> ERROR: The filesystem has valuable metadata changes in a log which needs to
> >>> ...
> >>>
> >>
> >> Very strange.  Both xfs_logprint & xfs_repair should be using the same
> >> function in libxfs for finding the head & tail.
> >>
> >> I asked off-list if you wanted to provide a metadump image I could look
> >> at directly...
> > 
> > I've bisected this issue to the following commit from Dave:
> > 
> >  commit e0607266f23f82226f8aee502552d6ce25c4e6a5
> >  Author: Dave Chinner <dchinner@redhat.com>
> >  Date:   Fri Jun 7 10:25:47 2013 +1000
> > 
> >     xfsprogs: add crc format support to repair
> > 
> > 
> 
> Cool, thanks.
> 
> That commit added:
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 2817fed..a62854e 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -64,6 +64,7 @@ zero_log(xfs_mount_t *mp)
>                 ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
>         }
>         log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
> +       log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;
>  
>         if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
>                 do_warn(_("zero_log: cannot find log head/tail "
> 
> right before the call to xlog_find_tail, which is what found the dirty log.
> 
> those various things are:
> 
>         __uint8_t       sb_logsectlog;  /* log2 of the log sector size */
>         uint            l_sectbb_log;   /* log2 of sector size in bbs */
>         int             l_sectBBsize;   /* size of log sector in 512 byte chunks */
> 
> The hunk above sticks out as odd, because it was already set a different way about
> 12 lines prior:
> 
>         log.l_sectBBsize  = BTOBB(x.lbsize);
> 
> And "indeed" as Dave might say, ;) - l_sectBBsize is supposed to be in
> 512-byte units (i.e. 1 for 512, 8 for 4k), but it's coming out as 4096
> because it's taking sb_logsectlog - describing byte units - and using it to get
> something in sector units.
> 
> It still accidentally works for 512-byte sectors, because in in that case we set
> sb_logsectlog to 0 (not 9, because - sure, why not!):
> 
>         if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
>                 sbp->sb_logsectlog = (__uint8_t)lsectorlog;
>                 sbp->sb_logsectsize = (__uint16_t)lsectorsize;
>         } else {
>                 sbp->sb_logsectlog = 0;
>                 sbp->sb_logsectsize = 0;
>         }
> 
> 
> 
> Anyway:
> 
> I bet if you remove "log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;" from
> around line 67 it'll fix it.
> 
> Want to try it?  Sorry for abusing your bandwidth in the meantime.  :)
> If it works I'll send the patch.

Yes, commenting out that line fixes the issue.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
