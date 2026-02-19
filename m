Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE4C2F1FFE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483457; cv=none; b=ScOkK0zyxXa4rQ+olHHX9w5myn9ZXCIeATbOqfWlejWOG0iceLEketZVlvrD1I6ecA8zzg/g2a30l0HR+0D2ZXZVGBA3bz0dkY2u8xYIk2EWE7l82OByxBn1tgkWTYmCX8nP77xf4mQXuB2fmjctxkh2wKNoRpAQx9C2+iawvaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483457; c=relaxed/simple;
	bh=7bR8KwcKxg5/1Gus5BMvtMu1t7L2U2sZN6DLNxULrAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8cQr2Q/8SvgbburCC/G7JYk2e3v0roelOlJTww/+Q/5JfXwOq/KCC+e5TRYg53TSUHS+32onsibDS4nnE7Axx1CMYqaUiX1mcY/0sln3+7i8QNfpW0Ga3ma/reyYuWDlhdX3PYeBDtVPlgbk9u9dOrJHyLpQMohjpBtnwU2kQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qJU68QII; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qJU68QII"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9XiPrfnkMC1TqQLAW04mF7HZxSuJSdTc4+rLvKzqcik=; b=qJU68QIIAG1lgWqE6fEG/lYTkX
	sX2mU/2au0Pc9En75CF4bis9hZ4SsjP5dPe0yz032uA1v7M9KEvTMOG48/2jLp5eKHCyb3/EJfjXP
	1ywGd1SoxLG0/AX8NEDwWhRCoO19+EbVK8EkPRhxbHh35B6Q94lLRapOt7mX7s3QAyggHiwKAuFIy
	ZTtnHuSaYvOxenDt1FPsgztN6YUfsWaukgfjl3YlXrX/yGhJnE5bWVAlgtIJ3cj4gmSePvCRFniF+
	gu3NzMHnnVW/4/HMdLgo2unc5KjxwQjkt2Yloz0atmpa+bYRN6tXaepzum+3TFXRv8Sb2kDoq2NDo
	nIEBAVQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxlo-0000000AyyZ-1yFb;
	Thu, 19 Feb 2026 06:44:16 +0000
Date: Wed, 18 Feb 2026 22:44:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: don't report metadata inodes to fserror
Message-ID: <aZaxQCtVDo-QE5au@infradead.org>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925516.401799.751825387607935746.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925516.401799.751825387607935746.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 18, 2026 at 10:02:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Internal metadata inodes are not exposed to userspace programs, so it
> makes no sense to pass them to the fserror functions (aka fsnotify).
> Instead, report metadata file problems as general filesystem corruption.
> 
> Fixes: 5eb4cb18e445d0 ("xfs: convey metadata health events to the health monitor")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
