Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C3947F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 17:35:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EDB9E8F8052
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 15:35:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6Hg3iUp8Q9TZGq0c for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 15:35:18 -0700 (PDT)
Date: Mon, 13 Oct 2014 09:35:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix agno increment in xfs_inumbers() loop
Message-ID: <20141012223516.GB5267@dastard>
References: <543AC7C9.5040503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <543AC7C9.5040503@sandeen.net>
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
Cc: Jie Liu <jeff.liu@oracle.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Oct 12, 2014 at 01:26:17PM -0500, Eric Sandeen wrote:
> commit c7cb51d xfs: fix error handling at xfs_inumbers
> caused a regression in xfs_inumbers, which in turn broke
> xfsdump, causing incomplete dumps.
> 
> The loop in xfs_inumbers() needs to fill the user-supplied
> buffers, and iterates via xfs_btree_increment, reading new
> ags as needed.
> 
> But the first time through the loop, if xfs_btree_increment()
> succeeds, we continue, which triggers the ++agno at the bottom
> of the loop, and we skip to soon to the next ag - without
> the proper setup under next_ag to read the next ag.
> 
> Fix this by removing the agno increment from the loop conditional,
> and only increment agno if we have actually hit the code under
> the next_ag: target.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. it's alarming that apparently no test in the dump group
> detects this problem!  I'll look into it.

The dump tests must not create more than an inode chunks worth
of files in each AG. Yup, see common/dump::_mk_fillconfig1() - maybe
35 files?

> So I can say that I've tested this with xfstests, but I guess
> that doesn't matter much, yet.
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index f71be9c..f1deb96 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -639,7 +639,8 @@ next_ag:
>  		xfs_buf_relse(agbp);
>  		agbp = NULL;
>  		agino = 0;
> -	} while (++agno < mp->m_sb.sb_agcount);
> +		agno++;
> +	} while (agno < mp->m_sb.sb_agcount);

Yeah, it fixes the bug, but I don't like the structure of the code
that leads to it. What we actually have it two loops in one:

	do {
		while (inobt records exist) {
			/* format record */
		}

	} while (++agno < mp->m_sb.sb_agcount)

But the inner loop is not implemented as a loop, it's implemented
split across two iterations on the outer loop (i.e.  increment in
one iteration, formatting in the next). Hence the bug.

The code should really be further factored to:

	do {

		/* read agi */
		error = xfs_ialloc_read_agi(agno, &agbp)
		if (error)
			break;

		error = xfs_inumbers_ag(...);
		if (error)
			break;

		xfs_buf_relse(agbp);
		agino = 0;
		agno++;
	} while (agno < mp->m_sb.sb_agcount)

So that the AG is traversed and records processed within it's own
cursor-based traversal loop inside xfs_inumbers_ag(), not split
across the outer ag scope loop.

I'll take the first patch right away, but can you follow up with
the above refactoring, Eric?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
