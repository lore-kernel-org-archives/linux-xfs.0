Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D192580FB
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767716172; cv=none; b=FDTuJFpIYqXFPspvqMNIRUgsxV4U5Fi0p98/M7fe+KAXBPhM2yX6id8Ne0mqeChKVYQ37amv3nX3oGHOv29nm6jAwuRkN72rRXyWvmNMExqiAEWq2MOjDxJyQVMWiOkpE9hRHw6zqJQgx5cY1JlxOKbNC5vrltE0FIceg9RtkBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767716172; c=relaxed/simple;
	bh=GdTBsY2mXnXCjpzkpGyhysUpucOLUxE4UinK1EEZpGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbQSuSSyho5Kt3JJ3UFWvBkVMyeD1QQJH7uo70CMHDIEZM8TEHyLAMWi+t5xeFeN8a8gcUSDlc34iebABAi0rdm+iZcPkZJ1VhNpH/SwIeZgxacYbw6juFYaVv6x6T4HlmgSXOAaVk6WiVZ7e7KAab22sVqvtQbTHmHgKe75lPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boM2CBpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boM2CBpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A2CC116C6;
	Tue,  6 Jan 2026 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767716171;
	bh=GdTBsY2mXnXCjpzkpGyhysUpucOLUxE4UinK1EEZpGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=boM2CBpSvXiw+V8K0MPbDuTi0nfG87ZTFJOe8aRRz+/CdLZhY9n3KfNZlbdPi8J44
	 Xo4loJ7yotJ2hEE8ssFHm9hcyJDHN2XeTTGmX2FXaml6t6rOIGY+uEf4DvXFTNS+lf
	 cBqg41gP02uUwUE1x9blhj1wkbkj8mwTrmUaBmR8pWof4Gto3PLSLaKKgY//q7uQ3Z
	 fQ62MuntxjgUXv4S5EM3bCTRl9m2J2mj4cO2hCfJzK22T1l2TmoyiporimQNNoWBV3
	 qDGplMdDYgAPAqbZjLi3UPsgQR/Jv1gaV7qXCJo66gTciqYzGWjUGjT9T1eGXUwrDy
	 A17bfBE7qC1ng==
Date: Tue, 6 Jan 2026 08:16:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 1/6] libxfs: add missing forward declaration in
 xfs_zones.h
Message-ID: <20260106161609.GB191501@frogsfrogsfrogs>
References: <20251220025326.209196-1-dlemoal@kernel.org>
 <20251220025326.209196-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-2-dlemoal@kernel.org>

On Sat, Dec 20, 2025 at 11:53:21AM +0900, Damien Le Moal wrote:
> Add the missing forward declaration for struct blk_zone in xfs_zones.h.
> This avoids headaches with the order of header file inclusion to avoid
> compilation errors.
> 
> Fixes: 48ccc2459039 ("xfs: parse and validate hardware zone information")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  libxfs/xfs_zones.h | 1 +

We don't normally merge changes to xfsprogs' libxfs that haven't already
gone into the kernel libxfs.  If Andrey's ok with this then I am too.

(alternate suggestion: can the forward declaration go in
platform_defs.h?)

--D

>  1 file changed, 1 insertion(+)
> 
> diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
> index c4f1367b2cca..6376bb0e6da6 100644
> --- a/libxfs/xfs_zones.h
> +++ b/libxfs/xfs_zones.h
> @@ -2,6 +2,7 @@
>  #ifndef _LIBXFS_ZONES_H
>  #define _LIBXFS_ZONES_H
>  
> +struct blk_zone;
>  struct xfs_rtgroup;
>  
>  /*
> -- 
> 2.52.0
> 
> 
