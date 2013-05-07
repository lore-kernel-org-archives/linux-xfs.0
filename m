Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E90729E12
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 18:55:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B2DF8F8059
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 16:55:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dY52eboOghG0QMEf for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 16:55:01 -0700 (PDT)
Date: Wed, 8 May 2013 09:54:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130507235458.GG24635@dastard>
References: <20130507190731.GA15528@redhat.com> <518954DE.4070803@sgi.com>
	<20130507193146.GA7539@redhat.com> <51895CD7.7040806@sgi.com>
	<20130507195954.GA8384@redhat.com> <51895E51.2050508@sgi.com>
	<20130507202217.GA9883@redhat.com> <518962FC.2060509@sgi.com>
	<20130507222256.GD24635@dastard> <51898400.8000900@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51898400.8000900@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Dave Jones <davej@redhat.com>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Tue, May 07, 2013 at 05:45:20PM -0500, Mark Tinguely wrote:
> On 05/07/13 17:22, Dave Chinner wrote:
> >On Tue, May 07, 2013 at 03:24:28PM -0500, Mark Tinguely wrote:
> >>On 05/07/13 15:22, Dave Jones wrote:
> >>>On Tue, May 07, 2013 at 03:04:33PM -0500, Mark Tinguely wrote:
> >>>  >   On 05/07/13 14:59, Dave Jones wrote:
> >>>  >   >   On Tue, May 07, 2013 at 02:58:15PM -0500, Mark Tinguely wrote:
> >>>  >   >
> >>>  >   >     >    >    I can hit this almost instantly with fsx. I'll do a bisect, though
> >>>  >   >     >    >    it sounds like you already have a suspect.
> >>>  >   >     >    >
> >>>  >   >     >
> >>>  >   >     >    If you want to try kmem debug of Linux 3.8 that would help.
> >>>  >   >
> >>>  >   >   I'm not sure what that is.
> >>>  >
> >>>  >   Sorry, if you would test Linux 3.8 with "CONFIG_DEBUG_SLAB=y".
> >>>
> >>>Ah, done that. (I pretty much always run with it).
> >>>
> >>>This is something new. Even 3.9 was fine. It's only since
> >>>the recent xfs merge.
> >>>
> >>>	Dave
> >>>
> >>
> >>git revert 666d644cd72a9ec58b353209ff191d7430f3b357
> >
> >That won't prevent the use after free. That commit fixed a problem
> >that could lead to a use after free, but what we are seeing here is
> >that it has ultimately exposed a previously unknown issue that
> >causes the use after free.
> >
> >Basically what is happening is that there are two commits for the
> >EFD being processed, when there should only be one. I'm not sure how
> >this is happening yet, but these three traces came out from my debug
> >sequentially when running generic/006:
> 
> Sorry for the misleading statement. Yes, I agree that patch is a
> good thing. I meant that Dave and only Dave revert it and only to
> test if that patch was the change that caused the new symptom -
> which we know now that it is.

Sure, I realise that, and it turns out I'm wrong - it is a bug in
commit 666d644cd. Poisoning turns a "will probably never occur"
problem into an instant reproducer, because it sets a bit in the efi
structure that is normally zero when the EFI is freed and hence
triggers a second free of the EFI when reading it after the first
free....

Dave, the patch below should fix the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Don't reference the EFI after it is freed

From: Dave Chinner <dchinner@redhat.com>

Checking the EFI for whether it is being released from recovery
after we've already released the known active reference is a mistake
worthy of a brown paper bag. Fix the (now) obvious use after free
that it can cause.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index c0f3750..98c437d 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -305,10 +305,22 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
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
