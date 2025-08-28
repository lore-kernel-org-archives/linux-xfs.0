Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CD8218ADD
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 09:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756372365; cv=none; b=WlAQftJHGx0q6q5io1uyiOpRVUP66FdMbpCbjpBciRrMlOd4F9FHnEhNk2KhziybQARlsz82I24xdBxsgVy4exH6tv3+pMRynK4gzHZhnkF8HkDElMz+WYJV5mrb+/7X/F9U5LJk6hlJnQtS8MrdyM0MkB9mAwMaQZ5BM1+h288=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756372365; c=relaxed/simple;
	bh=3BxjOKCkNfA2v4V9iAmNVNBNiPMg196U/7GuMUT4niU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9XUocqczUqknJHNaw6QXxka6oHlPNOE+ykp7nx7JMuErs8BponA9t1iiia1QRgSVd5CyULQj1TnBfghcwnhzu8FxAskz/bGBKGnhQ089cD8cidWXvDIBa2baC40lUkJc+3OrrkalYbOwXN2RvuQT54IkDSd50bCNybsyyYdbxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from arkam (ip-213-220-240-96.bb.vodafone.cz [213.220.240.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: arkamar)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 3F5AE340CD7;
	Thu, 28 Aug 2025 09:12:42 +0000 (UTC)
Date: Thu, 28 Aug 2025 11:12:37 +0200
From: Petr =?utf-8?B?VmFuxJtr?= <arkamar@gentoo.org>
To: Johannes Nixdorf <johannes@nixdorf.dev>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] libfrog: Define STATX__RESERVED if not provided by
 the system
Message-ID: <202582891237-aLAdhcE8C25xIhGn-arkamar@gentoo.org>
References: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
 <20250809-musl-fixes-v1-2-d0958fffb1af@nixdorf.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250809-musl-fixes-v1-2-d0958fffb1af@nixdorf.dev>

On Sat, Aug 09, 2025 at 07:13:08PM +0200, Johannes Nixdorf wrote:
> This define is not provided by musl libc. Use the fallback that is
> already provided if statx and its types (tested on STATX_TYPE) are
> not defined in the general case.
> 
> This fixes one cause for failing to compile against musl libc.
> 
> Signed-off-by: Johannes Nixdorf <johannes@nixdorf.dev>

Looks good, it solves the issue for us.

Reviewed-by: Petr Vaněk <arkamar@gentoo.org>
