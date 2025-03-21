Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36CA1D86F2;
	Fri, 21 Mar 2025 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742570419; cv=none; b=eZWbSxqNmUdRz4MGvXGe0Ud5XpPP5Km7qlQETuIoE+45jkczLzC9xRPaODY3LhL9QMVQErGFs+MsB8RX9L4ktZPbW7LvGWtMcbbXsG4/E4O0/BU4LJg1VFlgZ6jiDm0vuPkS4FbyrmyldumLsEEV3PQi3WsLc92RcvlFn6XJ/Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742570419; c=relaxed/simple;
	bh=MUQMEyvDBXou+kyS/Qj8C4V+2liRzfE5R30O0Uwc81k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9BxsoIw2o4fNc82FKpjP0aPvM3+MT+YmBgZypVyfvZ3GOmpubYOmDSuTiBo7dNJ2F1Sf+vj7PyfC6UNSrC1uAj4k+LwC7y9Ad9dfrEb8laCY8L+0b9hLhsSqpFN9bI9B06QTDeTXokCXp3zit8K9U7/NiWkw1uLCzMqi/6uJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDFj5NOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDFj5NOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D583C4CEE3;
	Fri, 21 Mar 2025 15:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742570418;
	bh=MUQMEyvDBXou+kyS/Qj8C4V+2liRzfE5R30O0Uwc81k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EDFj5NOPculP3MV3Di7DntDUoQAnektXbDLAGSwpRp9MKl5TdpUcAzEWslmMKdwxC
	 cSpLHC+8hKxdV6r7bhq0HMqc7w368dEWaXwGHWp2EJB6AWuPrGd70CBsSyFyLxb4rU
	 0mpp0jQMjqLFzh/+VV3qenFFtVizCjCWHOsK509uoALJXWBo1mrrwYCI2dsOU/0CdJ
	 GSJofBFwcv7U+K1HOjtC6OhO9u8cZLE26SEocSxd+VXxrC1AE/+9kF1IYzc6Vt0XuU
	 GwvIn8XELHmdLVIp6e5v366uWOoTh1xfuBYFUweausiuxOJBbsvOT30Z6074/9dcDK
	 shUA6O4cbiakw==
Date: Fri, 21 Mar 2025 08:20:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: xfs_copy doesn't like RT sections
Message-ID: <20250321152017.GH2803749@frogsfrogsfrogs>
References: <20250321072145.1675257-1-hch@lst.de>
 <20250321072145.1675257-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321072145.1675257-10-hch@lst.de>

On Fri, Mar 21, 2025 at 08:21:38AM +0100, Christoph Hellwig wrote:
> internal or external..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Some day someone ought to make xfs_copy work on rt volumes...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/xfs | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index ccf263aeb969..d9999829d3b5 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1556,6 +1556,9 @@ _require_xfs_copy()
>  	[ "$USE_EXTERNAL" = yes ] && \
>  		_notrun "Cannot xfs_copy with external devices"
>  
> +	$XFS_INFO_PROG "$TEST_DIR" | grep -q 'realtime.*internal' &&
> +		_notrun "Cannot xfs_copy with internal rt device"
> +
>  	# xfs_copy on v5 filesystems do not require the "-d" option if xfs_db
>  	# can change the UUID on v5 filesystems
>  	touch /tmp/$$.img
> -- 
> 2.45.2
> 
> 
