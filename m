Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0A3F29DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 19:50:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB4D38F804B
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 17:50:13 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	axBMnD61Glv3yEmj for <xfs@oss.sgi.com>;
	Sun, 12 Jan 2014 17:50:11 -0800 (PST)
Date: Mon, 13 Jan 2014 12:50:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Message-ID: <20140113015007.GC3469@dastard>
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
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
To: Zachary Kotlarek <zach@kotlarek.com>
Cc: xfs@oss.sgi.com

On Sun, Jan 12, 2014 at 11:53:59AM -0800, Zachary Kotlarek wrote:
> 
> On Jan 12, 2014, at 10:47 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> > 
> > If this is due to a bug it may have already been fixed.  Note the first
> > two things asked for.
> 
> 
> Thanks for the pointer.
> 
> My kernels a bit old, but xfsprogs is shiny and new:
> Linux vera 2.6.39.2 #1 SMP Fri Sep 30 23:55:41 PDT 2011 x86_64 x86_64 x86_64 GNU/Linux
> xfs_repair version 3.1.11
> 
> 2x4 core CPUs
> 8 GB RAM, mostly free (more than 6 GB cached)
> 
> Related mount:
> /dev/lvmsas/tv /mnt/media/TV xfs rw,nosuid,nodev,noexec,relatime,attr2,delaylog,inode64,sunit=1024,swidth=4096,noquota 0 0
> 
> Underlying partition:
>  254       31 16252928000 dm-31
> 
> Which is a no-frills LVM2 volume allocation over mdadm raid-6.
> 
> meta-data=/dev/lvmsas/tv         isize=256    agcount=33, agsize=126975872 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=4063232000, imaxpct=5
>          =                       sunit=128    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=1
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Attempts to access the now-busted files/directories with accents in their paths result in a kernel log like:
> Jan 11 02:05:39 vera XFS (dm-31): I/O error occurred: meta-data dev dm-31 block 0x3c8ff73e0       ("xfs_trans_read_buf") error 11 buf count 4096

error 11 = EAGAIN/EWOULDBLOCK

That tends to imply that there's some interesting error occurring in
the layers below XFS here. XFS on a kernel that old is not expecting
an EAGAIN error from storage, so it is likely not being captured
properly. There have been bugs in the raid/dm code in the past that
would cause issues like this, and bugs in the XFS error handling
that allowed them to slip throw and shut down the filesystem.

For example, this fix made in March 2013:

$ gl -n1 -p c163f9a
commit c163f9a1760229a95d04e37b332de7d5c1c225cd
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Mar 12 23:30:34 2013 +1100

    xfs: ensure we capture IO errors correctly
    
    Failed buffer readahead can leave the buffer in the cache marked
    with an error. Most callers that then issue a subsequent read on the
    buffer do not zero the b_error field out, and so we may incorectly
    detect an error during IO completion due to the stale error value
    left on the buffer.
    
    Avoid this problem by zeroing the error before IO submission. This
    ensures that the only IO errors that are detected those captured
    from are those captured from bio submission or completion.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

Is probably relevant, but there are many more changes up and down
the stack that may be the cause of your problem. Indeed, the above
fix may simply turn EAGAIN into EIO because there really is
something wrong with that block on disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
