Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EA3CE4BB;
	Wed, 22 Apr 2026 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776862547; cv=none; b=E5M0WcN3yg7KSBHwODVBNHpRS4RyDVk5WHDG+I/qtngwPk6pdYU8pKK4Vjp0NhSJ0POfhpmJXD80baPfAOPGegMc31SjkQ8tVCrjdCdxsQYKDUlNJZR9SQqZUg3uwzsanVTWMAmYEXulvplL9VHoBrpHX5WBBoaKazNU4i2Qkec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776862547; c=relaxed/simple;
	bh=ij8HqMggBQaXhfdlHULTaGPiOU6C35wGOLei/PtZQgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+H1Umnj67M3InX7d/cacfia+EVzXJwiKZ/ndTbqzArxZXT3CnmhLJxwrpDCt4jVmyHv6T+v10Je1xnE/XgqxunIr2m78ComuVmJGctrCxJmedxHav8YsWJMylnPHV9oGmskR64WHwzn8QiAB2t8fpRuNPd87nD5BBz9ip2J2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RpPV7UZ/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RpPV7UZ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NBIhK/tgXmEvj4QOPG0+L1+HSgYBtwxZLnHBdSd/Kw8=; b=RpPV7UZ/mu1jYiHbnbZ2uyAa1a
	lVbQpOlyIefWoSoJknx9yWNCsP6YWb2Kqx/SgAwIF5+u+A3SH8U8vuwBWVAp9zZQKQRwLWDlHchq3
	ExirNxqwM+ic9924/pTtZmBZsXfRSx+iS7ih4ON48UEM1fWiUvXAukAGOdmawmNTlIJETL18uWU8f
	nyPkmXoKQreM9/2rSQqBC+5IpDHrvT4n2SV6sU9dR52L1D7t76jqwBF9XYMyqzwcgwLBR8s3QqF9r
	2yt7glhmJYpugVQ3cZAFpJh83t7LEYKgNcm0u+ZrnLJ9aHEC7qx3e9y7BYzb1GUIooFV+NEo2GSR/
	x9V4QhYw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFX7F-0000000BllJ-0Xwd;
	Wed, 22 Apr 2026 12:55:41 +0000
Date: Wed, 22 Apr 2026 13:55:40 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: hyc.lee@gmail.com, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH] ntfs: use page allocation for resident attribute inline
 data
Message-ID: <aejFTDGOnDbQ3OJK@casper.infradead.org>
References: <20260422104627.8193-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422104627.8193-1-linkinjeon@kernel.org>

On Wed, Apr 22, 2026 at 07:46:27PM +0900, Namjae Jeon wrote:
> The current kmemdup() based allocation for IOMAP_INLINE can result in
> inline_data pointer having a non-zero page offset. This causes
> iomap_inline_data_valid() to fail the check:
> 
>     iomap->length <= PAGE_SIZE - offset_in_page(iomap->inline_data)
> 
> and triggers the kernel BUG at fs/iomap/buffered-io.c:1061.

Hang on, hang on, hang on.

First, maybe this check is too strict.  I'm sure it's true for EROFS,
but I don't see why it should be true for everybody.  Perhaps we should
delete this check or relax it?

Second, why are you calling kmemdup() to begin with?  This seems
entirely pointless; the iomap code is going to call memcpy() on it.
You're supposed to just be pointing into your data structures.
