Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD9738644F;
	Tue, 14 Apr 2026 07:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153553; cv=none; b=iZEKHrShCYTVJqSsgMP6w/+awBgtDNbYX6jrvF+x+hmi2id07QQOGrY0K16jKr/YtlizrxSS8NVX/uXAbvSCZiM1pdPB3YSWQ/Xaedqyg40sPu73DIO0IHVvgtLeITsUV9bf0XgEvA13kTlon9JdEmH8AAuZ2TUZQH2gqqEsd4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153553; c=relaxed/simple;
	bh=wR8Sk5iJ2tDm3VKxeoO3uoCfXmrAuctSjDlb2B5EDck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vd3MMCviv3CZ6S9xELbgcIWdtgflNKECrg7oUggPQLSaxfdQ3XYFZvaZCDJ+NZx7InWqGsPAtiJdgx9gPethwb1hC8izaBKyjV1KtDPfuO61RwC7b9EFJAerv8B1ktIKkOxZbwYlSgdB44Fi60SSdgv4J+H3uD1EBDEVwgqv3J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YqZE0yRz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YqZE0yRz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7XXWJI+CEPlWw+NtDeUgaquYvwSk8YJ/Xqpix4Sg3uY=; b=YqZE0yRza1jpsdKz9jH3+3V8yB
	70lpGDcpLRK1fY8i7bk14F3HohfWKb52WBknLGsIJkr+s48p50+vu+HUGrL7xw2UMamRNlp1vugAo
	tkOG7ocLVfTamdzZcjtLpzTRVaA4dbgFWp0h8C2EvQ5pMtEtSTjMnu74JP2kB/a3/9BTubl/7x5Em
	kcoUNxiTA2YfBebo2B8mhasf9A1v/vlS3ltWOs4a0IjoIn0f23NDMYB9hi4Ym91kyiiCT72+snt+S
	sE1+UNPmXAvJLbtmeeM6mnsBpIViNKr8Cawe1Txc+albAS1AZPMiXjAmMONc84cPNGBBR1E/BSjV8
	PTZVBmPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYfw-0000000Gvo2-0TCC;
	Tue, 14 Apr 2026 07:59:12 +0000
Date: Tue, 14 Apr 2026 00:59:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: capture dmesg of mount failures if test fails
Message-ID: <ad3z0FFzJqhIiqVQ@infradead.org>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
 <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 13, 2026 at 10:51:25AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Capture the kernel output after a mount failure occurs.  If the test
> itself fails, then keep the logging output for further diagnosis.

I have to admit I don't really understand what the xunit and selftests
stuff is doing.  Can you explain that a bit in the commit message?

