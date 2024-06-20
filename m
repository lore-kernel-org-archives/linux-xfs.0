Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2657F1AB91B
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896856; cv=none; b=Ag5P6CJ98YMrv5kI9O0kSOHINCOM6kg3h6Xc6XMveYnCBfcObwYwq+gWEL0w9QHIWXhU2kcrJvpCNk684/MWUEn6HnyINPZAmS7/NYOV2Hub6NTisMyvv2uWMj8USVWlSoJ/lR1fOd5FgXB42iEXiPYxvtthjM+mm9LpjK/UEVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896856; c=relaxed/simple;
	bh=7OXzzeX0jQaKFescqSEfgJGON+Z1kyxkfeG1Y3D0YGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OvAzQ4VGeaa1qjrtgHygr0CwsYLzArhg+OvgrFxO3d5xYwnpapeO2pYPAEf6ZJy8Y7aoMb9D8tOJl1SSgGyEtBqfznRT2OCwFMx8dnX0RH+aaqe9C4MGLWJ5DCMSoaHpAEdp1f1orEtjys5GJzCeA2W3wnfXmPI3lIQANp3pn+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oesvihCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oesvihCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4B6C2BD10;
	Thu, 20 Jun 2024 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718896855;
	bh=7OXzzeX0jQaKFescqSEfgJGON+Z1kyxkfeG1Y3D0YGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oesvihCle9yFNXRHWaofUXYMfJA0YMnIUvOu3rSAdGf5kCW/DLKf7QTqEv+irFhT+
	 VMBhvSCPxJnqnJZb9riyxYP7Z4vo9gGuJND8tO4oBeoDasSYMtMx28wFARn+hkVX8E
	 6F1ByjZwh42NW7sYoHEE9JXSNRlCJyNOSAhDLfsfpkZzC4XLiaSMZmdCOQMZJkoUda
	 2qlulQ9OTuL+WXFFS3MBjy33eHdMduyNNo0x38diHEGhFDgyJiwFvI/vVVy0O2e6h3
	 5gWtIo/kXfH2tMTK+9T0/7ImRiqgFPQdkpSa4Uq+ZNm9ySMtcn98o5owLvYGCPTkvl
	 ZJ0T6Pi1ITFjA==
Date: Thu, 20 Jun 2024 08:20:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: fix the contact address for the sysfs ABI
 documentation
Message-ID: <20240620152055.GU103034@frogsfrogsfrogs>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620072146.530267-2-hch@lst.de>

On Thu, Jun 20, 2024 at 09:21:18AM +0200, Christoph Hellwig wrote:
> oss.sgi.com is long dead, refer to the current linux-xfs list instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yikes.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  Documentation/ABI/testing/sysfs-fs-xfs | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
> index f704925f6fe93b..82d8e2f79834b5 100644
> --- a/Documentation/ABI/testing/sysfs-fs-xfs
> +++ b/Documentation/ABI/testing/sysfs-fs-xfs
> @@ -1,7 +1,7 @@
>  What:		/sys/fs/xfs/<disk>/log/log_head_lsn
>  Date:		July 2014
>  KernelVersion:	3.17
> -Contact:	xfs@oss.sgi.com
> +Contact:	linux-xfs@vger.kernel.org
>  Description:
>  		The log sequence number (LSN) of the current head of the
>  		log. The LSN is exported in "cycle:basic block" format.
> @@ -10,7 +10,7 @@ Users:		xfstests
>  What:		/sys/fs/xfs/<disk>/log/log_tail_lsn
>  Date:		July 2014
>  KernelVersion:	3.17
> -Contact:	xfs@oss.sgi.com
> +Contact:	linux-xfs@vger.kernel.org
>  Description:
>  		The log sequence number (LSN) of the current tail of the
>  		log. The LSN is exported in "cycle:basic block" format.
> @@ -18,7 +18,7 @@ Description:
>  What:		/sys/fs/xfs/<disk>/log/reserve_grant_head
>  Date:		July 2014
>  KernelVersion:	3.17
> -Contact:	xfs@oss.sgi.com
> +Contact:	linux-xfs@vger.kernel.org
>  Description:
>  		The current state of the log reserve grant head. It
>  		represents the total log reservation of all currently
> @@ -29,7 +29,7 @@ Users:		xfstests
>  What:		/sys/fs/xfs/<disk>/log/write_grant_head
>  Date:		July 2014
>  KernelVersion:	3.17
> -Contact:	xfs@oss.sgi.com
> +Contact:	linux-xfs@vger.kernel.org
>  Description:
>  		The current state of the log write grant head. It
>  		represents the total log reservation of all currently
> -- 
> 2.43.0
> 
> 
