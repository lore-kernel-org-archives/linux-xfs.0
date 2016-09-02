Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81E3A7CA4
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 08:25:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3B72AC002
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 06:25:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YDsgoMleXVnqImT8 for <xfs@oss.sgi.com>;
	Fri, 02 Sep 2016 06:25:12 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A339A4A1
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 08:25:12 -0500 (CDT)
Subject: Re: [PATCH 2/6] xfs: shadow agfl indexes in the per-ag structures
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
	<1472783257-15941-3-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d32c1b10-107c-a1fc-3864-76223661ab71@sandeen.net>
Date: Fri, 2 Sep 2016 08:25:12 -0500
MIME-Version: 1.0
In-Reply-To: <1472783257-15941-3-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On 9/1/16 9:27 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To verify that the AGFL contents is sane, we need to have access to
> the indexes that tell us what part of the AGFL is active. We cannot
> access the AGF buffer from the AGFL verifier, so we need to shadow
> these values in the struct xfs_perag so we check them when required.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 4 ++++
>  fs/xfs/xfs_mount.h        | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 23559b9..1aef556 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2255,6 +2255,7 @@ xfs_alloc_get_freelist(
>  	be32_add_cpu(&agf->agf_flcount, -1);
>  	xfs_trans_agflist_delta(tp, -1);
>  	pag->pagf_flcount--;
> +	pag->pagf_flfirst = be32_to_cpu(agf->agf_flfirst);
>  	xfs_perag_put(pag);
>  
>  	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;

Still reviewing, but this kind of jumped out at me, seems like the get/put
functions are a bit jumbled up:

        /*
         * Get the block number and update the data structures.
         */
        agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
        bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
        be32_add_cpu(&agf->agf_flfirst, 1);
        xfs_trans_brelse(tp, agflbp);
        if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
                agf->agf_flfirst = 0;

        pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
        be32_add_cpu(&agf->agf_flcount, -1);
        xfs_trans_agflist_delta(tp, -1);
        pag->pagf_flcount--;
        xfs_perag_put(pag);


why is there a trans_brelse in between two lines which handle proper setting
of flfirst?  I was looking at this thinking about where the pag structures
get updated, then saw the kind of swiss-cheese placement of the first/count
manipulation...

If pagf_flcount/agf_flcount, pagf_flfirst/agf_flfirst etc need to stay in
sync, should there be a wrapper to encapsulate it all?

like:

xfs_agf_{advance/drop/remove}_first(mp, agf, pagf)
{
        be32_add_cpu(&agf->agf_flfirst, 1);
        if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
                agf->agf_flfirst = 0;
	pag->pagf_flfirst = be32_to_cpu(agf->agf_flfirst);
        be32_add_cpu(&agf->agf_flcount, -1);
        pag->pagf_flcount--;
}

or something similar?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
