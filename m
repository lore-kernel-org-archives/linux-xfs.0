Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208E2171E70;
	Mon,  4 Nov 2024 07:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730706634; cv=none; b=W3Toekh0njnG5FHbEAHVmsrsUiRRLqXWixyMok3eeizM0vpUQRoLAlEzvxBLnHTDKPp49m3H0rIrgdciAfCGf6CvGNBn+4u099WZgmEO5L8TG59TffTAvkjq6Idr53V2l3rqo8jLv9UxAGh+L6gYekedm6zJqYpXEuKR53Sf5fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730706634; c=relaxed/simple;
	bh=kC8fSeEU7iFjwglI2lmOfhtVgecEEefTKASCDugRghs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l58WEGgJnFv7hNv2TUfwxF+mGcRLD/Ro5q0Jvw5QXnBqUcTggWdlJnoHSokGAbH/UNXoC3bk9fp7sD0WWXkcNHhA9+lpWZjM3CzvZPv5dtUzDIT7njQzNypmm46bKTRtETLUue7Yfg4cZg5rhFoyeVALV7JO3yjhMpS8+jPw7LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=13sRbPjX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="13sRbPjX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EcmsWKoCofQclEFUrm7xCKoG2Zv0XvEJ0ny3OiXz82I=; b=13sRbPjXdBN2mVU8xiHBfW4SCn
	3VnF3RGu8vj7V38BcDBv/21OEPWzv75bcqkGa6RWa+1mivoehj1BZvb1aTuyRpDjLajDbwguxnd4M
	v+GNU5WzRX6d62GTnlfxUTZF+vNFskpUvOkyEnfvCUJ+JxFnoOPHH7+pP7MZe4mTqkAmBG0JJ0kBq
	2Q+9WtTCBbm4x2+aYsp2bUJIDUbjl2rZ7CMEwi8kmwqrnJBhynUxulpzGXb1oBkCdsk3o1oeVkewK
	Zsnt57VL9EwW9VH2jlW3HfrAxs9vmubnE0eziwLjdJcQnNRKeL3I4+X+IQJmF+rlh5tF7qBHd+4jf
	ONDPwUEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t7rr6-0000000CtaS-3MAm;
	Mon, 04 Nov 2024 07:50:32 +0000
Date: Sun, 3 Nov 2024 23:50:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <Zyh8yP-FJUHKt2fK@infradead.org>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101214926.GW2578692@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 01, 2024 at 02:49:26PM -0700, Darrick J. Wong wrote:
> > How about unset the MKFS_OPTIONS for this test? As it already tests rtdev
> > and logdev by itself. Or call _notrun if MKFS_OPTIONS has "rmapbt=1"?
> 
> That will exclude quite a few configurations.  Also, how many people
> actually turn on rmapbt explicitly now?
> 
> > Any better idea?
> 
> I'm afraid not.  Maybe I should restructure the test to force the rt
> device to be 500MB even when we're not using the fake rtdev?

All of this is really just bandaids or the fundamental problem that:

 - we try to abitrarily mix config and test provided options without
   checking that they are compatible in general, and with what the test
   is trying to specifically
 - some combination of options and devices (size, block size, sequential
   required zoned) fundamentally can't work

I haven't really found an easy solution for them.  In the long run I
suspect we need to split tests between those that just take the options
from the config and are supposed to work with all options (maybe a few
notruns that fundamentally can't work).  And those that want to test
specific mkfs/mount options and hard code them but don't take options
from the input.

