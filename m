Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdAXPFD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 10:05:03 -0500
Date: Tue, 24 Jan 2017 09:04:57 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: do not call xfs_buf_hash_destroy on a NULL pag
Message-ID: <20170124150457.GA17008@redhat.com>
References: <20170120142642.21698-1-colin.king@canonical.com>
 <113b0890-ef1f-0a27-34c1-95785a4d1d17@sandeen.net>
 <20170120204703.GF12985@birch.djwong.org>
 <58fd1fec-1439-71fc-c482-06c4ba0a4695@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fd1fec-1439-71fc-c482-06c4ba0a4695@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin Ian King <colin.king@canonical.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 20, 2017 at 11:04:42PM +0000, Colin Ian King wrote:
> On 20/01/17 20:47, Darrick J. Wong wrote:
> > On Fri, Jan 20, 2017 at 01:26:12PM -0600, Eric Sandeen wrote:
> >> On 1/20/17 8:26 AM, Colin King wrote:
> >>> From: Colin Ian King <colin.king@canonical.com>
> >>>
> >>> If pag cannot be allocated, the current error exit path will trip
> >>> a null pointer deference error when calling xfs_buf_hash_destroy
> >>> with a null pag.  Fix this by adding a new error exit lable and
> >>> jumping to this, avoiding the hash destroy and unnecessary kmem_free
> >>> on pag.
> >>>
> >>> Fixes CoverityScan CID#1397628 ("Dereference after null check")
> >>>
> >>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >>
> >> Hm, I think this leaves the code with issues.
> >>
> >>> ---
> >>>  fs/xfs/xfs_mount.c | 3 ++-
> >>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> >>> index 9b9540d..4e66cd19 100644
> >>> --- a/fs/xfs/xfs_mount.c
> >>> +++ b/fs/xfs/xfs_mount.c
> >>> @@ -207,7 +207,7 @@ xfs_initialize_perag(
> >>>  
> >>>  		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
> >>>  		if (!pag)
> >>> -			goto out_unwind;
> >>> +			goto out_unwind_pags;
> >>
> >> So let's say we got to index == 3 at the top of the loop, and
> >> this fails.
> >>
> >> We succeeded in initializing 0, 1, and 2, but 3 failed.
> >>
> >> So we go to out_unwind_pags with index == 3...
> >>
> >>>  		pag->pag_agno = index;
> >>>  		pag->pag_mount = mp;
> >>>  		spin_lock_init(&pag->pag_ici_lock);
> >>> @@ -242,6 +242,7 @@ xfs_initialize_perag(
> >>>  out_unwind:
> >>>  	xfs_buf_hash_destroy(pag);
> >>>  	kmem_free(pag);
> >>> +out_unwind_pags:
> >>
> >> ... where index == 3, and:
> >>
> >>>  	for (; index > first_initialised; index--) {
> >>>  		pag = radix_tree_delete(&mp->m_perag_tree, index);
> >>
> >> this should fail, because it never got inserted, and...
> >>
> >>>  		xfs_buf_hash_destroy(pag);
> >>
> >> this still tries to destroy a NULL pag, no?
> >>
> >> There also seems to be an existing issue w/the code where ag 0 is
> >> never torn down in the error case, because first_initialized doesn't
> >> stay set to 0:
> >>
> >>                 if (!first_initialised)
> >>                         first_initialised = index;
> >>
> >> And we don't even tear down ag 1, because:
> >>
> >>>  	for (; index > first_initialised; index--) {
> >>>  		pag = radix_tree_delete(&mp->m_perag_tree, index);
> >>
> >> when the loop reaches the first initialized AG, it stops.
> >>
> >> So we seem to always leak at least 2 if we managed to get far enough
> >> to initialize them.
> > 
> > Ugh, yeah, the the whole error exit from that function is fubar...
> > Anyone want to clean this up?
> 
> I may step back on this if somebody else wants to fix this up properly.

I'll take it.
-Bill


> 
> > 
> > --D
> > 
> >>
> >> -Eric
> >>
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
