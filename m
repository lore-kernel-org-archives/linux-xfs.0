Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0C7C7F55
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 11:19:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C08AC8F808F
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 09:19:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ztHdcuj0MXFJGiVt for
	<xfs@oss.sgi.com>; Wed, 22 May 2013 09:19:53 -0700 (PDT)
Date: Wed, 22 May 2013 12:19:46 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522161946.GA25906@redhat.com>
References: <20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
	<20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
	<20130522055147.GI29466@dastard> <20130522142252.GB1407@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522142252.GB1407@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, May 22, 2013 at 10:22:52AM -0400, Dave Jones wrote:
 > On Wed, May 22, 2013 at 03:51:47PM +1000, Dave Chinner wrote:
 > 
 >  > > Tomorrow I'll also try running some older kernels with the same
 >  > > options to see if it's something new, or an older bug. This is a
 >  > > new machine, so it may be something that's been around for a
 >  > > while, and for whatever reason, my other machines don't hit
 >  > > this.
 >  > 
 >  > Another thing that just occurred to me - what compiler are you
 >  > using?  We had a report last week on #xfs that xfsdump was failing
 >  > with bad checksums because of link time optimisation (LTO) in
 >  > gcc-4.8.0. When they turned that off, everything worked fine. So if
 >  > you are using 4.8.0, perhaps trying a different compiler might be a
 >  > good idea, too.
 > 
 > Yeah, this is 4.8.0. This box is running F19-beta. 
 > I managed to shoehorn the gcc-4.7 from f18 on there though.
 > Bug reproduced instantly, so I think we can rule out compiler.
 > 
 > I ran 3.9 with the same debug options. Seems stable.
 > I'll do a bisect.

good news.  It wasn't until I started bisecting I realised I was still
carrying this patch from you to fix slab corruption I was seeing.

It seems to be the culprit (or is masking another problem -- I had to apply
it at each step of the bisect to get past the slab corruption bug).

	Dave

--- /home/davej/src/kernel/git-trees/linux/fs/xfs/xfs_extfree_item.c	2013-05-03 10:03:05.331370231 -0400
+++ linux-dj/fs/xfs/xfs_extfree_item.c	2013-05-07 20:46:42.389262296 -0400
@@ -305,10 +305,22 @@ xfs_efi_release(xfs_efi_log_item_t	*efip
 {
 	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
 	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
+		int recovered;
+
+		/*
+		 * __xfs_efi_release() can release the last reference to the EFI
+		 * and free it, so it is unsafe to reference it after we've
+		 * released the reference. The only case this is safe to do is
+		 * if we are in recovery and the XFS_EFI_RECOVERED bit is set,
+		 * meaning that we have two references to release. Check the
+		 * recovered bit before the initial release, as we cannot
+		 * reliably check it afterwards.
+		 */
+		recovered = test_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 		__xfs_efi_release(efip);
 
 		/* recovery needs us to drop the EFI reference, too */
-		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
+		if (recovered)
 			__xfs_efi_release(efip);
 	}
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
