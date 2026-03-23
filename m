Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620EB3AD513
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273211; cv=none; b=nBQ4G5lkafhVq5YAmRKnKi50vUqHYANCUCO1gRcM8G+qGa9WaTdRcHtUtnpgl5GGnmtO9qdEYsInGxx+S0lN1hLnzdsRy91LDt9oPY2UscFvSC7VWLEW2qrw3AgPLdvEzidLiHNfkWox5AzBeNbYOPWgJ4fLJZnCCostgRWgybQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273211; c=relaxed/simple;
	bh=9Dpyg3x+Sk+U3kRUJdvpysAh9AH8CKJHWEUbI70f5us=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=uqTpRZajrzPWYyA1G+zav3aPVppkvLyrmH5uggB9uykckqRQ80BH2hJn3j2edEDi4jvZ5Wc7pXfwbn3HqUYKPPmXP77njYc21GcLX6cg3dlaEmNlS+OGT2Ydffa/MZlbXW3y5r9/F9W2iJmIHjhrU5c3G5ddUvjcCmYN1Q1TwqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iEbLmqL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iEbLmqL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D15EC4CEF7;
	Mon, 23 Mar 2026 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774273211;
	bh=9Dpyg3x+Sk+U3kRUJdvpysAh9AH8CKJHWEUbI70f5us=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=iEbLmqL3bxeG7z+kPGDzfV+tMPVhaJR3/7wlp122wulkvNVO9th6vqm6SiyoRaU0c
	 ywPy2xk8T5vE8KiPgx6UVKDQNHk3bXStuVSdSLlTGz37+1xp/iGh71qS31FFEwdm4C
	 xe5RGWZTAqUDP1VQm1QwxaEmoqGZcTKjMH8A8jbyw6SjTZ2HAryCnahIXaVxUmoA1s
	 7R4s2PfE29JSwKdi/Kdt99Jc9+4sc66T1M3jojzq9m8y/Meh8GFK5V+AdvVmsJn53h
	 2W14EMdSeoC32K8duMyQcCkOC2/MCsb/9PGDn5Q8juAwr/2yZCf5PGFjTVB7956QHH
	 fwAe2QqOplWWQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 13E0AF40077;
	Mon, 23 Mar 2026 09:40:10 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 23 Mar 2026 09:40:10 -0400
X-ME-Sender: <xms:uULBaSqAvbG5Yihhtfwuzu2qLHTaiLQV7QoHoWTP3PgbscBZ8uiWyw>
    <xme:uULBabchHF18oVppJoR4JAihRtjqTsfEKHYzc1yjszSMsfqVb6VzEBc3XCJZyqUmG
    7QomgeNxacL5EfCiyQR7-BHrSharHt5ThZDGsi0a_bC1BjmiXJj3vM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefudekkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfvehhuhgt
    khcunfgvvhgvrhdfuceotggvlheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhffekffeftdfgheeiveekudeuhfdvjedvfedvueduvdegleekgeetgfduhfefleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhutg
    hklhgvvhgvrhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeifeegleel
    leehledqfedvleekgeegvdefqdgtvghlpeepkhgvrhhnvghlrdhorhhgsehfrghsthhmrg
    hilhdrtghomhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehnvghilhessghrohifnhdrnhgrmhgvpdhrtghpthhtoheprghmihhrjeefih
    hlsehgmhgrihhlrdgtohhmpdhrtghpthhtoheptggvmheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepjhhlrgihthhonheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephhgthh
    eslhhsthdruggvpdhrtghpthhtohepuggrihdrnhhgohesohhrrggtlhgvrdgtohhmpdhr
    tghpthhtoheptghhuhgtkhdrlhgvvhgvrhesohhrrggtlhgvrdgtohhmpdhrtghpthhtoh
    epohhkohhrnhhivghvsehrvgguhhgrthdrtghomhdprhgtphhtthhopehtohhmsehtrghl
    phgvhidrtghomh
X-ME-Proxy: <xmx:uULBaemJHQCoN9xafdBNqp3tAHd9Fis9Si_0rmR895Q2lNXPXhKkMA>
    <xmx:ukLBacOMsRlxdYHZ1HyqYOK5B2eP82qTtgVpif9N7ligDfDKmJwcMg>
    <xmx:ukLBaY5CxM87bmFQsfuY_KmoqCWI6T1Vv9fHP2KCiQNZEN9344gUjQ>
    <xmx:ukLBaQaKsa6K-W7z9af17CEEcVDnTbpTJ42uc7vOvjVZ95DptyWJuw>
    <xmx:ukLBaVczC-5AbMzpJn_xtiCUF-2sLeQrEm3SRMi7-FjypberLOAYYNFK>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D88B0780070; Mon, 23 Mar 2026 09:40:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AIsm7hYmK1tN
Date: Mon, 23 Mar 2026 09:39:48 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>, "Chuck Lever" <chuck.lever@oracle.com>,
 "Jeff Layton" <jlayton@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>
Cc: NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Carlos Maiolino" <cem@kernel.org>, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <1fbdc5d9-d95c-4d1a-816e-028ffd1231b0@app.fastmail.com>
In-Reply-To: <20260323070746.2940140-2-hch@lst.de>
References: <20260323070746.2940140-1-hch@lst.de>
 <20260323070746.2940140-2-hch@lst.de>
Subject: Re: [PATCH 1/7] exportfs: split out the ops for layout-based block device
 access
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Mar 23, 2026, at 3:07 AM, Christoph Hellwig wrote:

> diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
> index ad7af8cfcf1f..616984fe3873 100644
> --- a/fs/nfsd/nfs4layouts.c
> +++ b/fs/nfsd/nfs4layouts.c
> @@ -3,6 +3,7 @@
>   * Copyright (c) 2014 Christoph Hellwig.
>   */
>  #include <linux/blkdev.h>
> +#include <linux/exportfs_block.h>
>  #include <linux/kmod.h>
>  #include <linux/file.h>
>  #include <linux/jhash.h>
> @@ -127,6 +128,7 @@ void nfsd4_setup_layout_type(struct svc_export *exp)
>  {
>  #if defined(CONFIG_NFSD_BLOCKLAYOUT) || defined(CONFIG_NFSD_SCSILAYOUT)
>  	struct super_block *sb = exp->ex_path.mnt->mnt_sb;
> +	struct exportfs_block_ops *bops = sb->s_export_op->block_ops;
>  #endif
> 
>  	if (!(exp->ex_flags & NFSEXP_PNFS))
> @@ -136,14 +138,11 @@ void nfsd4_setup_layout_type(struct svc_export *exp)
>  	exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
>  #endif
>  #ifdef CONFIG_NFSD_BLOCKLAYOUT
> -	if (sb->s_export_op->get_uuid &&
> -	    sb->s_export_op->map_blocks &&
> -	    sb->s_export_op->commit_blocks)
> +	if (bops->get_uuid && bops->map_blocks && bops->commit_blocks)
>  		exp->ex_layout_types |= 1 << LAYOUT_BLOCK_VOLUME;
>  #endif
>  #ifdef CONFIG_NFSD_SCSILAYOUT
> -	if (sb->s_export_op->map_blocks &&
> -	    sb->s_export_op->commit_blocks &&
> +	if (bops->map_blocks && bops->commit_blocks &&
>  	    sb->s_bdev &&
>  	    sb->s_bdev->bd_disk->fops->pr_ops &&
>  	    sb->s_bdev->bd_disk->fops->get_unique_id)

block_ops itself is NULL for any filesystem that does not provide
block layout support (everything other than XFS today).

When an admin exports such a filesystem with pNFS enabled
(NFSEXP_PNFS), svc_export_parse() calls nfsd4_setup_layout_type(),
and bops->get_uuid dereferences a NULL pointer.

Something like the following would restore the original behavior:

    if (bops && bops->get_uuid && ...)


-- 
Chuck Lever
