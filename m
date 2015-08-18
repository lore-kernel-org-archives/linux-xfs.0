Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4E3A7F56
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 14:26:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA23D304062
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 12:26:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4y4M9NTW2jzA3WVm for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 12:26:37 -0700 (PDT)
Message-ID: <55D386ED.604@sandeen.net>
Date: Tue, 18 Aug 2015 14:26:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 08/10] xfs_db: enable blocktrash for checksummed
	filesystems
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
	<20150815014429.1839.69933.stgit@birch.djwong.org>
In-Reply-To: <20150815014429.1839.69933.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 8/14/15 8:44 PM, Darrick J. Wong wrote:
> Disable the write verifiers when we're trashing a block.  With this
> in place, create a xfs fuzzer script that formats, populates, corrupts,
> tries to use, repairs, and tries again to use a crash test xfs image.
> Hopefully this will shake out some v5 filesystem bugs.

Maybe "we can create an xfs fuzzer script ..." (since it's not in this
patch)

> v2: Drop xfsfuzz, don't assume every block is an AGF when blocktrashing.
> Don't trash log blocks by default, because that skews the blocktrash
> heavily towards damaging only log blocks.

and skip DBM_SB by default as well, right?

And you added log blocks & symlinks to the allowed mask.

So I think something like:

Allow trashing of symlink & log blocks.
By default, do not trash superblocks (why?) or log blocks (because ...)

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/check.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index afeea32..965d0f5 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -944,6 +944,7 @@ blocktrash_b(
>  	int		mask;
>  	int		newbit;
>  	int		offset;
> +	const struct xfs_buf_ops *stashed_ops;
>  	static char	*modestr[] = {
>  		N_("zeroed"), N_("set"), N_("flipped"), N_("randomized")
>  	};
> @@ -952,8 +953,10 @@ blocktrash_b(
>  	offset = (int)(random() % (int)(mp->m_sb.sb_blocksize * NBBY));
>  	newbit = 0;
>  	push_cur();
> -	set_cur(&typtab[DBM_UNKNOWN],
> +	set_cur(NULL,
>  		XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb, DB_RING_IGN, NULL);

Ok, you talked about this back on 5/28/15.  Weird.

But calling it with NULL is odd, too; nothing else does that.  What about TYP_NONE,

        { TYP_NONE, NULL }

its ops are NULL, as well... does that work?
Huh, ok, no callers w/ TYP_NONE, either.  I guess NULL works.

> +	stashed_ops = iocur_top->bp->b_ops;
> +	iocur_top->bp->b_ops = NULL;
>  	if ((buf = iocur_top->data) == NULL) {
>  		dbprintf(_("can't read block %u/%u for trashing\n"), agno, agbno);
>  		pop_cur();
> @@ -984,6 +987,7 @@ blocktrash_b(
>  			buf[byte] &= ~mask;
>  	}
>  	write_cur();
> +	iocur_top->bp->b_ops = stashed_ops;

*nod*

>  	pop_cur();
>  	printf(_("blocktrash: %u/%u %s block %d bit%s starting %d:%d %s\n"),
>  		agno, agbno, typename[type], len, len == 1 ? "" : "s",
> @@ -1040,9 +1044,11 @@ blocktrash_f(
>  		   (1 << DBM_BTINO) |
>  		   (1 << DBM_DIR) |
>  		   (1 << DBM_INODE) |
> +		   (1 << DBM_LOG) |

Ok, so you allow log blocks to be specified,

>  		   (1 << DBM_QUOTA) |
>  		   (1 << DBM_RTBITMAP) |
>  		   (1 << DBM_RTSUM) |
> +		   (1 << DBM_SYMLINK) |

and symlink blocks too, but...

>  		   (1 << DBM_SB);
>  	while ((c = getopt(argc, argv, "0123n:s:t:x:y:")) != EOF) {
>  		switch (c) {
> @@ -1106,7 +1112,7 @@ blocktrash_f(
>  		return 0;
>  	}
>  	if (tmask == 0)
> -		tmask = goodmask;
> +		tmask = goodmask & ~((1 << DBM_LOG) | (1 << DBM_SB));

you disable log & superblocks by default if no mask is specified.

I'm not 100% sure why you want to change this, what did you run into,
in practice, if they were allowed?

If the change stays, then the xfs_db manpage needs an update:

"If no -t options are given then all metadata types can be trashed."

Thanks,
-Eric


>  	lentab = xmalloc(sizeof(ltab_t));
>  	lentab->min = lentab->max = min;
>  	lentablen = 1;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
