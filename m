Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB14F322E;
	Thu,  7 Nov 2024 23:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731023034; cv=none; b=NWKdAZLXURK925itGAMza67r4iddyIryak7g8VY9MVvum+JzKbnIOBkhJ8GkkVPxeiQ7AYQ9wUl67wftTezmCv0rUWddtc9vX0Mqe7z6lDDV0WDD8fipX2lhk8bzNYT1+QG0dw/nVAhkqY5SXveuB2IulVyEX6lolLMDLUgTp88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731023034; c=relaxed/simple;
	bh=CQdaSVps2UZDvTCDFsdyUoWl16VQGub6gFL/6D9XY+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVCOANHbN1nrBpYbnRQTUjPNEKxW1XirHdRyauJqcbzHQwqr9c56+o4n1Ki+23/YfU247khIVHcVBaEwG1WZyIn1wIZIVT4J8B4TMdRQL8r8y/rWiqGZuxL1z8rROStGAGBYrws7ZDwTcWQsMWZ0jZqKPauvHSWzBUugUmAFhtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fkg4kfHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fkg4kfHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA1BC4CECC;
	Thu,  7 Nov 2024 23:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731023034;
	bh=CQdaSVps2UZDvTCDFsdyUoWl16VQGub6gFL/6D9XY+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fkg4kfHRszlEMiEjnPydDbc7iDSYdHb2gYrxaTqG8rxX9vvn0erFjtwh3pFySLGMC
	 fHfDYQHupa88C6s1JX6LnhCADTfSmIOC0DlHAj1PgHqSgSDWn//5UGvvU3k+f9Qa9Z
	 hJxnh8kR2oe/iEupEYGg4atZxyIqc27BlY4JrBEQk1ViYBYWN9oKI1wnxwS3RvrbAI
	 WUrUiHZXM64VlPvyhaX+CEdv9K1RbmBXS95Vutd4p+Wxnl5qJvdnYpadZLpvHVBECf
	 3MvEuwQ6SG1KHN4ZsQjGickdeeQfDv5zp5BIPkb6krYEyr/A0Q9MyfcWH3yR7WdtfC
	 8bAX23Dtg1jNA==
Date: Thu, 7 Nov 2024 15:43:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH 1/2] xfs: Fix missing block calculations in xfs datadev
 fsmap
Message-ID: <20241107234352.GU2386201@frogsfrogsfrogs>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <20240826031005.2493150-2-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826031005.2493150-2-wozizhi@huawei.com>

On Mon, Aug 26, 2024 at 11:10:04AM +0800, Zizhi Wo wrote:
> In xfs datadev fsmap query, I noticed a missing block calculation problem:
> [root@fedora ~]# xfs_db -r -c "sb 0" -c "p" /dev/vdb
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 5242880
> ......
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
> ...
> 30: 253:16 [31457384..41943031]: free space            3  (104..10485751)    10485648
> 
> (41943031 + 1) / 8 = 5242879 != 5242880
> We missed one block in our fsmap calculation!

Eek.

> The root cause of the problem lies in __xfs_getfsmap_datadev(), where the
> calculation of "end_fsb" requires a classification discussion. If "end_fsb"
> is calculated based on "eofs", we need to add an extra sentinel node for
> subsequent length calculations. Otherwise, one block will be missed. If
> "end_fsb" is calculated based on "keys[1]", then there is no need to add an
> extra node. Because "keys[1]" itself is unreachable, it cancels out one of
> the additions. The diagram below illustrates this:
> 
> |0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|-----eofs
> |---------------|---------------------|
> a       n       b         n+1         c
> 
> Assume that eofs is 16, the start address of the previous query is block n,
> sector 0, and the length is 1, so the "info->next" is at point b, sector 8.
> In the last query, suppose the "rm_startblock" calculated based on
> "eofs - 1" is the last block n+1 at point b. All we get is the starting
> address of the block, not the end. Therefore, an additional sentinel node
> needs to be added to move it to point c. After that, subtracting one from
> the other will yield the remaining 1.
> 
> Although we can now calculate the exact last query using "info->end_daddr",
> we will still get an incorrect value if the device at this point is not the
> boundary device specified by "keys[1]", as "end_daddr" is still the initial
> value. Therefore, the eofs situation here needs to be corrected. The issue
> is resolved by adding a sentinel node.

Why don't we set end_daddr unconditionally, then?

Hmm, looking at the end_daddr usage in fsmap.c, I think it's wrong.  If
end_daddr is set at all, it's set either to the last sector for which
the user wants a mapping; or it's set to the last sector for the device.
But then look at how we use it:

	if (info->last...)
		frec->start_daddr = info->end_daddr;

	...

	/* "report the gap..."
	if (frec->start_daddr > info->next_daddr) {
		fmr.fmr_length = frec->start_daddr - info->next_daddr;
	}

This is wrong -- we're using start_daddr to compute the distance from
the last mapping that we output up to the end of the range that we want.
The "end of the range" is modeled with a phony rmap record that starts
at the first fsblock after that range.

IOWs, that assignment should have been
frec->start_daddr = info->end_daddr + 1.

Granted in August the codebase was less clear about the difference
between rec_daddr and rmap->rm_startblock.  For 6.13, hch cleaned all
that up -- rec_daddr is now called start_daddr and the fsmap code passes
rmap records with space numbers in units of daddrs via a new struct
xfs_fsmap_rec.  Unfortunately, that's all buried in the giant pile of
pull requests I sent a couple of days ago which hasn't shown up on
for-next yet.

https://lore.kernel.org/linux-xfs/173084396955.1871025.18156568347365549855.stgit@frogsfrogsfrogs/

So I think I know how to fix this against the 6.13 codebase, but I'm
going to take a slightly different approach than yours...

> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/xfs_fsmap.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 85dbb46452ca..8a2dfe96dae7 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -596,12 +596,27 @@ __xfs_getfsmap_datadev(
>  	xfs_agnumber_t			end_ag;
>  	uint64_t			eofs;
>  	int				error = 0;
> +	int				sentinel = 0;
>  
>  	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
>  	if (keys[0].fmr_physical >= eofs)
>  		return 0;
>  	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fmr_physical);
> -	end_fsb = XFS_DADDR_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
> +	/*
> +	 * For the case of eofs, we need to add a sentinel node;
> +	 * otherwise, one block will be missed when calculating the length
> +	 * in the last query.
> +	 * For the case of key[1], there is no need to add a sentinel node
> +	 * because it already represents a value that cannot be reached.
> +	 * For the case where key[1] after shifting is within the same
> +	 * block as the starting address, it is resolved using end_daddr.
> +	 */
> +	if (keys[1].fmr_physical > eofs - 1) {
> +		sentinel = 1;
> +		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
> +	} else {
> +		end_fsb = XFS_DADDR_TO_FSB(mp, keys[1].fmr_physical);
> +	}

...because running against djwong-wtf, I actually see the same symptoms
for the realtime device.  So I think a better solution is to change
xfs_getfsmap to set end_daddr always, and then fix the off by one error.

I also don't really like "sentinel" values because they're not
intuitive.

I will also go update xfs/273 to check that there are no gaps in the
mappings returned, and that they go to where the filesystem thinks is
the end of the device.  Thanks for reporting this, sorry I was too busy
trying to get metadir/rtgroups done to look at this until now. :(

--D

>  
>  	/*
>  	 * Convert the fsmap low/high keys to AG based keys.  Initialize
> @@ -649,7 +664,7 @@ __xfs_getfsmap_datadev(
>  		info->pag = pag;
>  		if (pag->pag_agno == end_ag) {
>  			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
> -					end_fsb);
> +					end_fsb) + sentinel;
>  			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
>  					keys[1].fmr_offset);
>  			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
> -- 
> 2.39.2
> 
> 
