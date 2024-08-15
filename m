Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4630F26AE4;
	Thu, 15 Aug 2024 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723739795; cv=none; b=saM3vGQNXr7KZ7ML2SsnofI0UKZ4G5ir3EdAPEhVNLAshfLLW2vVrYcVaHxvKlPvLaJoAWloxcT7PEbgDiLQUchfoEt5sMeoorwF18yyf2EyNZ7J3x3JQzD1I9/x81SGeYkzJX8jNXJqfxvXbacKADvArO0T/kRqVR/fiCap24A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723739795; c=relaxed/simple;
	bh=xKVVPX3rDcMygqr4duaL+U23CUdrlkMrIkiE6lBMEFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBcvELixth7sbejw7KM+YOUqZOczWgCxZKFCW6u6PrakxzmsgAYbeTFC0JVoeNMXBgIFWsyFYCGI8560WMaRsgdNDfss9oa5Mt/mwHeR/uXjofvMOxIVAcRUAI1C8r5nBOlUVlSOngSjrddngGXvqVEmWfSrJ59N8xPIWOrbk3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sMfQ1Wi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sMfQ1Wi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E2AC32786;
	Thu, 15 Aug 2024 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723739794;
	bh=xKVVPX3rDcMygqr4duaL+U23CUdrlkMrIkiE6lBMEFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sMfQ1Wi2wCpmRS2RPMPrdGCCYj4oc34JzrUZiTu4+06mlW3ao9Ox1PoT4/3eAFoQt
	 RDSxwxpDOz3K1fuzGAkmgJO7NtfMIusYQeE4CHHVmGO2C42r4oz6PmAOdBKqmbOBKh
	 dvhtGKbnm+A337zbKE/8L38Z5pzNDsvEuUeRRhQ71jOxk8KLUl+hOPCaXqCA98W5xg
	 4gLSoGVsQdka6WXPgIAwhCSImSLqGHIrLukLqnAGSe7lZ+nOAOFvmQNjJaOtjyU/fI
	 mx3JxVUlK34yA7LuV/vzivGnH39GKBz0CzRiUjBwCNipgl1G50CFXH/6K1yBrZHXaz
	 rolsYiaQFRalQ==
Date: Thu, 15 Aug 2024 09:36:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V3 1/2] xfs: Fix the owner setting issue for rmap query
 in xfs fsmap
Message-ID: <20240815163634.GH865349@frogsfrogsfrogs>
References: <20240812011505.1414130-1-wozizhi@huawei.com>
 <20240812011505.1414130-2-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812011505.1414130-2-wozizhi@huawei.com>

On Mon, Aug 12, 2024 at 09:15:04AM +0800, Zizhi Wo wrote:
> I notice a rmap query bug in xfs_io fsmap:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
>  EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
>    0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
>    1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
>    2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
>    3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
>    4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
>    5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
>    6: 253:16 [104..127]:           free space                          0  (104..127)               24
>    ......
> 
> Bug:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
> [root@fedora ~]#
> Normally, we should be able to get one record, but we got nothing.
> 
> The root cause of this problem lies in the incorrect setting of rm_owner in
> the rmap query. In the case of the initial query where the owner is not
> set, __xfs_getfsmap_datadev() first sets info->high.rm_owner to ULLONG_MAX.
> This is done to prevent any omissions when comparing rmap items. However,
> if the current ag is detected to be the last one, the function sets info's
> high_irec based on the provided key. If high->rm_owner is not specified, it
> should continue to be set to ULLONG_MAX; otherwise, there will be issues
> with interval omissions. For example, consider "start" and "end" within the
> same block. If high->rm_owner == 0, it will be smaller than the founded
> record in rmapbt, resulting in a query with no records. The main call stack
> is as follows:
> 
> xfs_ioc_getfsmap
>   xfs_getfsmap
>     xfs_getfsmap_datadev_rmapbt
>       __xfs_getfsmap_datadev
>         info->high.rm_owner = ULLONG_MAX
>         if (pag->pag_agno == end_ag)
> 	  xfs_fsmap_owner_to_rmap
> 	    // set info->high.rm_owner = 0 because fmr_owner == 0
> 	    dest->rm_owner = 0
> 	// get nothing
> 	xfs_getfsmap_datadev_rmapbt_query
> 
> The problem can be resolved by setting the rm_owner of high to ULLONG_MAX
> again under certain conditions.
> 
> After applying this patch, the above problem have been solved:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
>  EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
>    0: 253:16 [0..7]:          static fs metadata                  0  (0..7)               8
> 
> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/xfs_fsmap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 85dbb46452ca..d346acff7725 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -655,6 +655,13 @@ __xfs_getfsmap_datadev(
>  			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
>  			if (error)
>  				break;
> +			/*
> +			 * Set the owner of high_key to the maximum again to
> +			 * prevent missing intervals during the query.
> +			 */
> +			if (info->high.rm_owner == 0 &&
> +			    info->missing_owner == XFS_FMR_OWN_FREE)
> +			    info->high.rm_owner = ULLONG_MAX;

Shouldn't this be in xfs_fsmap_owner_to_rmap?

And, looking at that function, isn't this the solution:

	switch (src->fmr_owner) {
	case 0:			/* "lowest owner id possible" */
	case -1ULL:		/* "highest owner id possible" */
		dest->rm_owner = src->fmr_owner;
		break;

instead of this special-casing outside the setter function?

--D

>  			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
>  		}
>  
> -- 
> 2.39.2
> 
> 
