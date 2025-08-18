Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFFD221DB3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755549935; cv=none; b=QzxXrwhznFClwaa8aO1WDBEhi7mO1NfPcd9sDNOLnMUkeE9UIA8GOBzTHLGrVoWa6o5QwR72SM9FDSh+Ka9N+hXSdEeJrVmQqClB6zN4Vv7E8YEcIH3fwpEvPgxIR67kkNC7AhOodP/1eJq1h7L7i2oY8G8dXASlwdlxHNjAf0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755549935; c=relaxed/simple;
	bh=x5FgEidMJhslyq0zquGk3/nuNEmDTc9TsmbKsbjuQu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUgNfolMKSOJUI+YzSYvocXFeEIW56jNmBs0+ZXAsUKPfTxeBcDyybBMyAwyGnwYDg96c0MQC7mQzb/YdJ0FE80ay1M85FBktMKfA25J9DNjpR5rEGfFLohRko3U94u3KNfTp90kafHbbQ6xyqZvJ6bR3Thcv0PzaNmnchtkaSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMX40NI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMX40NI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB6AC116B1;
	Mon, 18 Aug 2025 20:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755549934;
	bh=x5FgEidMJhslyq0zquGk3/nuNEmDTc9TsmbKsbjuQu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GMX40NI/B490ebrIlHGgwJiJImjwF2MgQaEPrOmLpdZNIW6uYJez+U0lETJOG/DSd
	 G/wnjIM7l4SCgOwwvfC8gWMguTdmABsNQjBTdouH0U/+xMtoV90JOXlimr8q0ggE4r
	 DfacnGjUN2sVfAGigEhyhaHBBbpMJjcmwAzVsNNWWqC2eQDZ9nMA2d5OjykgIbSvta
	 ppJj3JezVdkJojcQKbLMt0iPYFuEyG/LBa9wdo/sr+E0Qa8UjQij7p7TU5j/D9Prk5
	 gIF8VK5cSD5PYbir8JR3xW2JqJcnntn0DUYCWwuYhX3oMBdxFCY6xF1my7HZZ1qbUD
	 /cyXJwr5ZMFPQ==
Date: Mon, 18 Aug 2025 13:45:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <20250818204533.GV7965@frogsfrogsfrogs>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>

On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
> We had a report that a failing scsi disk was oopsing XFS when an xattr
> read encountered a media error. This is because the media error returned
> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.
> 
> In this particular case, it looked like:
> 
> xfs_attr_leaf_get()
> 	error = xfs_attr_leaf_hasname(args, &bp);
> 	// here bp is NULL, error == -ENODATA from disk failure
> 	// but we define ENOATTR as ENODATA, so ...
> 	if (error == -ENOATTR)  {
> 		// whoops, surprise! bp is NULL, OOPS here
> 		xfs_trans_brelse(args->trans, bp);
> 		return error;
> 	} ...
> 
> To avoid whack-a-mole "test for null bp" or "which -ENODATA do we really
> mean in this function?" throughout the xattr code, my first thought is
> that we should simply map -ENODATA in lower level read functions back to
> -EIO, which is unambiguous, even if we lose the nuance of the underlying
> error code. (The block device probably already squawked.) Thoughts?

Uhhhh where does this ENODATA come from?  Is it the block layer?

$ git grep -w ENODATA block/
block/blk-core.c:146:   [BLK_STS_MEDIUM]        = { -ENODATA,   "critical medium" },

--D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..6ba57ccaa25f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -747,6 +747,9 @@ xfs_buf_read_map(
>  		/* bad CRC means corrupted metadata */
>  		if (error == -EFSBADCRC)
>  			error = -EFSCORRUPTED;
> +		/* ENODATA == ENOATTR which confuses xattr layers */
> +		if (error == -ENODATA)
> +			error = -EIO;
>  		return error;
>  	}
>  
> 
> 
