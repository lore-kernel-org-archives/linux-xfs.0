Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 271C17F52
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 11:52:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11DF0304048
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 09:52:20 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id fS8WSIXJxBMQQLs0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 09:52:18 -0700 (PDT)
Date: Mon, 7 Oct 2013 18:52:17 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [bisected] xfs_repair refuses to run on cleanly mountable partition
Message-ID: <20131007165217.GF280@x4>
References: <20131007151637.GA280@x4> <5252D194.1010609@sandeen.net>
	<20131007152910.GB280@x4> <5252D51B.7010503@sandeen.net>
	<20131007154044.GC280@x4> <5252D919.50901@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5252D919.50901@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2013.10.07 at 10:54 -0500, Eric Sandeen wrote:
> On 10/7/13 10:40 AM, Markus Trippelsdorf wrote:
> > On 2013.10.07 at 10:36 -0500, Eric Sandeen wrote:
> >> On 10/7/13 10:29 AM, Markus Trippelsdorf wrote:
> >>> On 2013.10.07 at 10:21 -0500, Eric Sandeen wrote:
> >>>> On 10/7/13 10:16 AM, Markus Trippelsdorf wrote:
> >>>>> x4 ~ # xfs_repair -V
> >>>>> xfs_repair version 3.2.0-alpha1
> >>>>>
> >>>>> x4 ~ # mount -o logbsize=256k /dev/sdc1 /mnt
> >>>>> ...
> >>>>> [ 6419.592649] XFS (sdc1): Mounting Filesystem
> >>>>> [ 6419.642480] XFS (sdc1): Ending clean mount
> >>>>>
> >>>>> x4 ~ # xfs_info /dev/sdc1
> >>>>> meta-data=/dev/sdc1              isize=256    agcount=4, agsize=61047552 blks
> >>>>>          =                       sectsz=4096  attr=2, projid32bit=0
> >>>>>          =                       crc=0
> >>>>> data     =                       bsize=4096   blocks=244190208, imaxpct=25
> >>>>>          =                       sunit=0      swidth=0 blks
> >>>>> naming   =version 2              bsize=4096   ascii-ci=0
> >>>>> log      =internal               bsize=4096   blocks=119233, version=2
> >>>>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> >>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>>>>
> >>>>> x4 ~ # umount /mnt
> >>>>>
> >>>>> x4 ~ # xfs_repair /dev/sdc1
> >>>>> Phase 1 - find and verify superblock...
> >>>>> Phase 2 - using internal log
> >>>>>         - zero log...
> >>>>> ERROR: The filesystem has valuable metadata changes in a log which needs to
> >>>>> be replayed.  Mount the filesystem to replay the log, and unmount it before
> >>>>> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> >>>>> the -L option to destroy the log and attempt a repair.
> >>>>> Note that destroying the log may cause corruption -- please attempt a mount
> >>>>> of the filesystem before doing this.
> >>>>
> >>>> What kernel are you running?  Does older xfs_repair behave differently?
> >>>> (use xfs_repair -n if you test an old xfsprogs, to preserve this state
> >>>> for debugging...)
> >>>
> >>> I'm running the latest git kernel 3.12.0-rc4. 
> >>> "xfs_repair -n" runs fine even with xfsprogs 3.2.0-alpha1...
> >>>
> >>>> Perhaps copying out or dumping the log w/ xfs_logprint would also help, 
> >>>> maybe start with:
> >>>>
> >>>> # xfs_logprint -t /dev/sdc1
> >>> xfs_logprint:
> >>>     data device: 0x821
> >>>     log device: 0x821 daddr: 976760888 length: 953864
> >>>
> >>>     log tail: 53376 head: 53376 state: <CLEAN>
> >>
> >> Funky.
> >>
> >> How about an xfs_repair -v (for verbose).
> > ...
> >         - zero log..
> > zero_log: head block 53048 tail block 49064
> > ERROR: The filesystem has valuable metadata changes in a log which needs to
> > ...
> > 
> 
> Very strange.  Both xfs_logprint & xfs_repair should be using the same
> function in libxfs for finding the head & tail.
> 
> I asked off-list if you wanted to provide a metadump image I could look
> at directly...

I've bisected this issue to the following commit from Dave:

 commit e0607266f23f82226f8aee502552d6ce25c4e6a5
 Author: Dave Chinner <dchinner@redhat.com>
 Date:   Fri Jun 7 10:25:47 2013 +1000

    xfsprogs: add crc format support to repair


-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
