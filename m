Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 828FF7F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 06:53:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E6F08F8040
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 04:53:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	muGdIR7yIjjEH83P for <xfs@oss.sgi.com>;
	Fri, 04 Oct 2013 04:52:58 -0700 (PDT)
Date: Fri, 4 Oct 2013 21:52:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corruption errors with growfs
Message-ID: <20131004115253.GI4446@dastard>
References: <alpine.DEB.2.10.1310040905380.3223@shack.dolda2000.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1310040905380.3223@shack.dolda2000.com>
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
To: Fredrik Tolf <fredrik@dolda2000.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 04, 2013 at 09:19:06AM +0200, Fredrik Tolf wrote:
> Dear list,
> 
> I recently consolidated two filesystems that have previously been
> separate; I'll refer to them below as /home and /home/pub (since
> that's what they're actually called).
> 
> When I first did so, I needed to grow /home quite a bit to
> accomodate the files in /home/pub. This is on LVM, so I extended the
> LV quite a bit (from about 550 GB to about 3.5 TB), and tried to
> grow the filesystem. At this point I encountered an error about
> corruption, prompting me to unmount the filesystem and run
> xfs_repair on it. I did so, it completed successfully and retained
> the filesystem at the size it was supposed to be grown to, so I
> ascribed the errors to some latent corruption by some older kernel
> version or something and went on with my life.
> 
> However, today I tried to grow the filesystem by another 500 GB,
> encountering again a very similar error. Clearly, this couldn't just
> be left-over corruption from some earlier kernel bug since I'm still
> using the exact same kernel. What's worse, however, is that
> xfs_repair restored the filesystem to its size prior to running
> growfs, so it seems I can't grow the filesystem and am stuck at its
> current size.
> 
> Does someone know what is happening, and what I can do to fix it?

Old kernel versions didn't zero the empty part of the secondary
superblocks when growing the filesystem. This commit in 3.8 fixed
the kernel growfs code not to put garbage in the new secondary
superblocks.

commit 1375cb65e87b327a8dd4f920c3e3d837fb40e9c2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 9 14:50:52 2012 +1100

    xfs: growfs: don't read garbage for new secondary superblocks

    When updating new secondary superblocks in a growfs operation, the
    superblock buffer is read from the newly grown region of the
    underlying device. This is not guaranteed to be zero, so violates
    the underlying assumption that the unused parts of superblocks are
    zero filled. Get a new buffer for these secondary superblocks to
    ensure that the unused regions are zero filled correctly.

    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>


The only time the kernel reads secondary superblocks is during a
growfs operation, so that's the only time the kernel will detect
such an error. More extensive validity tests were added during 3.9
and 3.10, and these now throw corruption errors over secondary
superblocks that have not been correctly zeroed.

To fix this, you need to grab xfsprogs from the git repo
(3.2.0-alpha will do) as this commit to xfs_repair detects and fixes
the corrupted superblocks:

commit cbd7508db4c9597889ad98d5f027542002e0e57c
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Aug 15 02:26:40 2013 +0000

    xfs_repair: zero out unused parts of superblocks
    
    Prior to:
    1375cb65 xfs: growfs: don't read garbage for new secondary superblocks
    
    we ran the risk of allowing garbage in secondary superblocks
    beyond the in-use sb fields.  With kernels 3.10 and beyond, the
    verifiers will kick these out as invalid, but xfs_repair does
    not detect or repair this condition.
    
    There is superblock stale-data zeroing code, but it is under a
    narrow conditional - the bug addressed in the above commit did not
    meet that conditional.  So change this to check unconditionally.
    
    Further, the checking code was looking at the in-memory
    superblock buffer, which was zeroed prior to population, and
    would therefore never possibly show any stale data beyond the
    last up-rev superblock field.
    
    So instead, check the disk buffer for this garbage condition.
    
    If we detect garbage, we must zero out both the in-memory sb
    and the disk buffer; the former may contain unused data
    in up-rev sb fields which will be written back out; the latter
    may contain garbage beyond all fields, which won't be updated
    when we translate the in-memory sb back to disk.
    
    The V4 superblock case was zeroing out the sb_bad_features2
    field; we also fix that to leave that field alone.
    
    Lastly, use offsetof() instead of the tortured (__psint_t)
    casts & pointer math.
    
    Reported-by: Michael Maier <m1278468@allmail.net>
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Rich Johnston <rjohnston@sgi.com>
    Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
