Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58554 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933364AbeFUQg4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 12:36:56 -0400
Subject: Re: [PATCH] Fix coverity scan reports
References: <20180621123525.5365-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <67d228b0-6094-b34e-488b-8f4b698e6213@sandeen.net>
Date: Thu, 21 Jun 2018 11:36:55 -0500
MIME-Version: 1.0
In-Reply-To: <20180621123525.5365-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 6/21/18 7:35 AM, Carlos Maiolino wrote:
> Initialize a few variables before pass them by reference in other
> functions.
> 
> This quiets the following Coverity reports:
> 
> CID 100898
> CID 1437081
> CID 1437129
> CID 1437191
> CID 1437201
> CID 1437212
> CID 1437341
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

thanks for looking into those, always good to reduce the count so stuff
doesn't get lost in the noise.

> ---
> 
> There is another coverity issue (CID 1437358), which actually looks more
> important, which really looks to pass an uninitialized value to
> xfs_getfsmap_rtdev_rtbitmap_helper(), where such looks to expect the variable to
> be already initialized. I'm familiar with RT code, so looking into it yet, but
> I think this one deservers a separated patch if that can really trigger a bug.
> 
>  fs/xfs/libxfs/xfs_alloc.c | 14 +++++++-------
>  fs/xfs/scrub/agheader.c   |  4 ++--
>  fs/xfs/scrub/alloc.c      |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index eef466260d43..ffdd50f5af32 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -421,8 +421,8 @@ xfs_alloc_fixup_trees(
>  {
>  	int		error;		/* error code */
>  	int		i;		/* operation results */
> -	xfs_agblock_t	nfbno1;		/* first new free startblock */
> -	xfs_agblock_t	nfbno2;		/* second new free startblock */
> +	xfs_agblock_t	nfbno1=0;	/* first new free startblock */
> +	xfs_agblock_t	nfbno2=0;	/* second new free startblock */

So, these really do look like false positives.

The function called does:

        error = xfs_btree_get_rec(cur, &rec, stat);
        if (!error && *stat == 1) { 
                *bno = be32_to_cpu(rec->alloc.ar_startblock);
                *len = be32_to_cpu(rec->alloc.ar_blockcount);
        }
        return error;

so *bno is unset if error || *stat == 2, but the caller returns early
on error, and does not test nfbno1 on *stat == 2:

                if ((error = xfs_alloc_get_rec(cnt_cur, &nfbno1, &nflen1, &i)))
                        return error;
                XFS_WANT_CORRUPTED_RETURN(mp,
                        i == 1 && nfbno1 == fbno && nflen1 == flen);

so it really is just confusion on coverity's part I think.

As a general note, it's also OK to simply mark issues as false positives
in coverity, if you're sure that they are, and leave the code alone.

But sometimes if coverity can get confused the reader can too, and a patch
like this can make it more understandable.  OTOH sometimes unnecessary
initializations can make things more confusing ;)

In this case, meh, I think the initialization is ok.

>  	xfs_extlen_t	nflen1=0;	/* first new free length */
>  	xfs_extlen_t	nflen2=0;	/* second new free length */
>  	struct xfs_mount *mp;
> @@ -783,8 +783,8 @@ xfs_alloc_ag_vextent_exact(
>  	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
>  	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
>  	int		error;
> -	xfs_agblock_t	fbno;	/* start block of found extent */
> -	xfs_extlen_t	flen;	/* length of found extent */
> +	xfs_agblock_t	fbno=0;	/* start block of found extent */
> +	xfs_extlen_t	flen=0;	/* length of found extent */

same thing here.

        error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
        if (error)
                goto error0;
        XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);

so if it returns an error or if i != 1, fbno & flen are untested.

>  	xfs_agblock_t	tbno;	/* start block of busy extent */
>  	xfs_extlen_t	tlen;	/* length of busy extent */
>  	xfs_agblock_t	tend;	/* end block of busy extent */
> @@ -1597,7 +1597,7 @@ xfs_alloc_ag_vextent_small(
>  	int		error;
>  	xfs_agblock_t	fbno;
>  	xfs_extlen_t	flen;
> -	int		i;
> +	int		i = 0;
>  
>  	if ((error = xfs_btree_decrement(ccur, 0, &i)))
>  		goto error0;

        if (i) {
                if ((error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i)))
                        goto error0;
                XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
        }


Same thing here, I think, i will be unset, but won't be tested if error is true.

> @@ -1704,8 +1704,8 @@ xfs_free_ag_extent(
>  	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
>  	xfs_btree_cur_t	*cnt_cur;	/* cursor for by-size btree */
>  	int		error;		/* error return value */
> -	xfs_agblock_t	gtbno;		/* start of right neighbor block */
> -	xfs_extlen_t	gtlen;		/* length of right neighbor block */
> +	xfs_agblock_t	gtbno=0;	/* start of right neighbor block */
> +	xfs_extlen_t	gtlen=0;	/* length of right neighbor block */
>  	int		haveleft;	/* have a left neighbor block */
>  	int		haveright;	/* have a right neighbor block */
>  	int		i;		/* temp, result code */

ok same pattern here I think

> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 9bb0745f1ad2..78a7381d6ca0 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -388,8 +388,8 @@ xfs_scrub_agf_xref_cntbt(
>  	struct xfs_scrub_context	*sc)
>  {
>  	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> -	xfs_agblock_t			agbno;
> -	xfs_extlen_t			blocks;
> +	xfs_agblock_t			agbno = 0;
> +	xfs_extlen_t			blocks = 0;
>  	int				have;
>  	int				error;

this one seems a little more confusing but same basic idea.
agbno is completely unused, blocks won't be tested if "have"
(the *stat return) is zero indicating a failure so again seems
like a false positive.

> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 50e4f7fa06f0..c82347da400f 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -47,7 +47,7 @@ xfs_scrub_allocbt_xref_other(
>  	xfs_extlen_t			len)
>  {
>  	struct xfs_btree_cur		**pcur;
> -	xfs_agblock_t			fbno;
> +	xfs_agblock_t			fbno = 0;
>  	xfs_extlen_t			flen;
>  	int				has_otherrec;
>  	int				error;
> 

ok same.  None of this looks incorrect, but I'm always on the fence
about code changes to fix false positives in checkers.  Let's see
what Darrick thinks.  :)

-Eric
