Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 20:15:13 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J3F9A9011281
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 20:15:09 -0700
Message-ID: <48D31B9A.1080803@sgi.com>
Date: Fri, 19 Sep 2008 13:25:14 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>    <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com>    <48D2C97A.1070703@thebarn.com> <63352.131.252.241.230.1221776406.squirrel@sandeen.net> <48D2F795.3080104@sgi.com>
In-Reply-To: <48D2F795.3080104@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Here's a patch to remove xfs_iext_irec_compact_full() like Russell
did in his original patch - are you guys happy with this?

I'm putting it through it's paces now and so far it looks good.

--- a/fs/xfs/xfs_inode.c	2008-09-19 13:08:08.000000000 +1000
+++ b/fs/xfs/xfs_inode.c	2008-09-19 13:16:34.000000000 +1000
@@ -4157,7 +4166,7 @@ xfs_iext_indirect_to_direct(
 	ASSERT(nextents <= XFS_LINEAR_EXTS);
 	size = nextents * sizeof(xfs_bmbt_rec_t);
 
-	xfs_iext_irec_compact_full(ifp);
+	xfs_iext_irec_compact_pages(ifp);
 	ASSERT(ifp->if_real_bytes == XFS_IEXT_BUFSZ);
 
 	ep = ifp->if_u1.if_ext_irec->er_extbuf;
@@ -4510,8 +4519,6 @@ xfs_iext_irec_compact(
 		xfs_iext_direct_to_inline(ifp, nextents);
 	} else if (nextents <= XFS_LINEAR_EXTS) {
 		xfs_iext_indirect_to_direct(ifp);
-	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 3) {
-		xfs_iext_irec_compact_full(ifp);
 	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 1) {
 		xfs_iext_irec_compact_pages(ifp);
 	}
@@ -4555,91 +4562,6 @@ xfs_iext_irec_compact_pages(
 }
 
 /*
- * Fully compact the extent records managed by the indirection array.
- */
-void
-xfs_iext_irec_compact_full(
-	xfs_ifork_t	*ifp)			/* inode fork pointer */
-{
-	xfs_bmbt_rec_host_t *ep, *ep_next;	/* extent record pointers */
-	xfs_ext_irec_t	*erp, *erp_next;	/* extent irec pointers */
-	int		erp_idx = 0;		/* extent irec index */
-	int		ext_avail;		/* empty entries in ex list */
-	int		ext_diff;		/* number of exts to add */
-	int		nlists;			/* number of irec's (ex lists) */
-
-	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
-
-	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-	erp = ifp->if_u1.if_ext_irec;
-	ep = &erp->er_extbuf[erp->er_extcount];
-	erp_next = erp + 1;
-	ep_next = erp_next->er_extbuf;
-
-	while (erp_idx < nlists - 1) {
-		/*
-		 * Check how many extent records are available in this irec.
-		 * If there is none skip the whole exercise.
-		 */
-		ext_avail = XFS_LINEAR_EXTS - erp->er_extcount;
-		if (ext_avail) {
-
-			/*
-			 * Copy over as many as possible extent records into
-			 * the previous page.
-			 */
-			ext_diff = MIN(ext_avail, erp_next->er_extcount);
-			memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
-			erp->er_extcount += ext_diff;
-			erp_next->er_extcount -= ext_diff;
-
-			/*
-			 * If the next irec is empty now we can simply
-			 * remove it.
-			 */
-			if (erp_next->er_extcount == 0) {
-				/*
-				 * Free page before removing extent record
-				 * so er_extoffs don't get modified in
-				 * xfs_iext_irec_remove.
-				 */
-				kmem_free(erp_next->er_extbuf);
-				erp_next->er_extbuf = NULL;
-				xfs_iext_irec_remove(ifp, erp_idx + 1);
-				erp = &ifp->if_u1.if_ext_irec[erp_idx];
-				nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-
-			/*
-			 * If the next irec is not empty move up the content
-			 * that has not been copied to the previous page to
-			 * the beggining of this one.
-			 */
-			} else {
-				memmove(erp_next->er_extbuf, &ep_next[ext_diff],
-					erp_next->er_extcount *
-					sizeof(xfs_bmbt_rec_t));
-				ep_next = erp_next->er_extbuf;
-				memset(&ep_next[erp_next->er_extcount], 0,
-					(XFS_LINEAR_EXTS -
-						erp_next->er_extcount) *
-					sizeof(xfs_bmbt_rec_t));
-			}
-		}
-
-		if (erp->er_extcount == XFS_LINEAR_EXTS) {
-			erp_idx++;
-			if (erp_idx < nlists)
-				erp = &ifp->if_u1.if_ext_irec[erp_idx];
-			else
-				break;
-		}
-		ep = &erp->er_extbuf[erp->er_extcount];
-		erp_next = erp + 1;
-		ep_next = erp_next->er_extbuf;
-	}
-}
-
-/*
  * This is called to update the er_extoff field in the indirection
  * array when extents have been added or removed from one of the
  * extent lists. erp_idx contains the irec index to begin updating


Lachlan McIlroy wrote:
> Eric Sandeen wrote:
>> Russell Cattelan wrote:
>>> Lachlan McIlroy wrote:
>>>> Russell, this fixes xfs_iext_irec_compact_full().  If we don't move
>>>> all the records from the next page into the current page then we need
>>>> to update the er_extoff of the modified page as we move the remaining
>>>> extents up.  Would you mind giving it a go?
>>>>
>>>> --- a/fs/xfs/xfs_inode.c    2008-09-18 18:48:46.000000000 +1000
>>>> +++ b/fs/xfs/xfs_inode.c    2008-09-18 18:57:18.000000000 +1000
>>>> @@ -4623,6 +4623,7 @@ xfs_iext_irec_compact_full(
>>>>                     (XFS_LINEAR_EXTS -
>>>>                         erp_next->er_extcount) *
>>>>                     sizeof(xfs_bmbt_rec_t));
>>>> +                erp_next->er_extoff += ext_diff;
>>>>             }
>>>>         }
>>>>
>>> Cool I'll give it some run through when I done traveling.
>>>
>>> I still think compact_full should simply be eliminated since
>>> it really doesn't help, and it's obviously confusing code.
>>> Or we should make sure it works and get rid of compact_pages
>>> since compact_full behaves just like compact_pages when not
>>> doing partial moves.
>>
>> I'd agree with that, at least as far as reevaluating this packing stuff -
>> given the seriousness of the bug when you do hit it, and how rarely it's
>> ever hit, apparently this chunk of code is almost never run ....
>>
> 
> I agree too.  If any code is difficult to reach it's also difficult to 
> test.
> We've had numerous reports of extent corruption that could be explained by
> this bug but we have not been able to reproduce the symptoms let alone 
> devise
> a reliable test case.
> 
> What real benefit does compact_full have over compact_pages?
> Are there corner cases where compact_pages is not good enough?
> 
> 
> 
> 
