Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE32B33468D;
	Fri, 17 Oct 2025 04:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760674971; cv=none; b=SrVRKi4Qj9aa/XBGiHQ6FPQE5+XTb44sCZysv3/jDAXSYLAkyWE3p5dQNFYN64ZSxptwNLk/Ka29O1Roq0Oo+Ix43I3py0crDBYEsyHd+3SroottX7wXB8cX+Dt0Ui3ByxjuhZYNeDCWvdWVqrV2sfTsoqIfbJM8rpOLBV94OKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760674971; c=relaxed/simple;
	bh=HwmkcszUinzxfiHBn5O+Ws66Q0pOnofUakdo31e/zlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n75wguT2OrIsQMMxM4CCI1q1u48d/sWM0hUzWKrdkx2JDEz/GqjitM46Gc0LhjcCk1RGkfvfCLltTf5Dt9CkMiy4FN61/nekrnZGnrY9LGFM6XosL2BWUoItAd5XUlry9QaI+5hVzd8YX9qkiDd3E7ckGpXN/KSofgZYlkmDLoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MO5NOUDD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MO5NOUDD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TsdSVj0wfzmZYMp4yT0hgobnUYD4M4j0vWrnmC1RYWo=; b=MO5NOUDD8PDijm38/iacn+HifA
	8MYTGJ+uvQ1DP5DIay0U/+7fKlf3viTI03/CY5HG4eqRPrulq4UcbOGfC06fXa7msWVOYWU5V6+4a
	zPA3OiO1LJvczwJFX43/XxEYxB6/BBU0d86uA/+VY3Op1QbIV+Wu0NOz/EqGcWDwIIpUXLqyHY3bo
	LPLa7Pul9DbQ1abgOr8L6BKKXCdcfjFV00AFrsmn8VjoKnfhmIxgNc7ImoDWK8p4Tt5IYicejbau/
	0uiwA11knpNYmxNnIy4JerK4EuRgZ8E7M7XGm5wcVH+uTpusIYURJJdW4i+s++1f9rHGEOe3IRu3s
	6ZpPYtaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bzN-00000006W2o-1vqS;
	Fri, 17 Oct 2025 04:22:49 +0000
Date: Thu, 16 Oct 2025 21:22:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] generic/{482,757}: skip test if there are no FUA
 writes
Message-ID: <aPHEmXmseASGsj9h@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617970.2391029.13902894502531643815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054617970.2391029.13902894502531643815.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 15, 2025 at 09:37:45AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Both of these tests fail if the filesystem doesn't issue a FUA write to
> a device, but ... there's no requirement that filesystems actually use
> FUA at all.  For example, a fuse filesystem that writes to the block
> device's page cache and issues fsync() will not cause the block layer to
> issue FUA writes for the dirty pages.  Change that to _notrun.

Hmm, zoned ZXFS never issues FUA and didn't fail.  Oh, these use dm thin
and thus are _notrun. 

> index 8c114ee03058c6..25e05d7cdb1c0d 100755
> --- a/tests/generic/482
> +++ b/tests/generic/482
> @@ -82,7 +82,7 @@ _log_writes_remove
>  prev=$(_log_writes_mark_to_entry_number mkfs)
>  [ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
>  cur=$(_log_writes_find_next_fua $prev)
> -[ -z "$cur" ] && _fail "failed to locate next FUA write"
> +[ -z "$cur" ] && _notrun "failed to locate next FUA write"

This isn't really the last but the first FUA write we're looking for
here, right?

>  
> -[ -z "$cur" ] && _fail "failed to locate next FUA write"
> +[ -z "$cur" ] && _notrun "failed to locate next FUA write"

Same here.

The only reason I'm asking is because if we did this for every write
we'd kinda defeat the purpose of the test.  But we're only doing it
to see if any FUA writes exists as far as I can tell, so we should
be ok.  But it might be worth changing the messages.

