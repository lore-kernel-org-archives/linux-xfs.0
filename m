Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27004178CE4;
	Wed, 13 Nov 2024 08:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731487682; cv=none; b=M9HjsQAn1maKG49DvTIDkv/wWk4ZVPyUqvvTLetsBXmRoU6fTv5aKHg0cX/KLV8ar8PZ2KB1AH+dEBkWCHsUpH3BSGibtfxe+jf8DeJIDIvzydjfQpBbenJhewlEFaFZ0ZaJD2H+ad6GSylzrcOMsgozHvOZcrPkJJ/jj0l2FBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731487682; c=relaxed/simple;
	bh=FjAOzZ7T11leLKRLfW0lfXCEL/gkPnNwHOCg6TD3lb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdO1PmdGuP2llwHme2ETExoPVC/ZR0SPVkUvMQcBQTojqozTf0I9ptcS8OdhQB50JtP9+b6/J7ZmOR0Y1PkONFLnhV/YN4BtItjakFPRlwcYEj5RvIvSTDlB34MW9Ej8dCbRqeeGBFl2kO2G15uBiA4Wd18MD0oln+qioB0NrRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=31ff8waY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="31ff8waY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=215pU80vB/eOgshy5Pjxq71BM7IUdtrMWgirnW79lPI=; b=31ff8waYCzfPWcHlayEHLbeHqq
	SEi/ZXJvR4hWMi+B5l0i33Mfacj/PqE8OhKjlp4udA5cKXZfTbFIvrcRr2+Mq5puaC0NmIDdTWrg4
	95frRhDAHgxEtcezasOP9Gm59rOlXMMNrrOXAHYr8xkvBq9gypUki4LMaLk5gGnDhdvUNBBayTkI6
	GQB1fXXB/LykYoFyJfMM2pfUA8YdoSr7ZjfyHaMjGT8SGHqX11TYZWGq79j91RSWQeFxsyd1KPnJ5
	Cb1xDGtTEWvTvILsNO5PNUjnn1mvdXp6aCWETFPJtVODxmYXORJ/D/QtQ/mywpAK5cruWJHodZBQt
	Oo6J7a3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tB92e-0000000692l-2S4f;
	Wed, 13 Nov 2024 08:48:00 +0000
Date: Wed, 13 Nov 2024 00:48:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] generic/757: fix various bugs in this test
Message-ID: <ZzRnwPqL6jTK6Y8F@infradead.org>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178859.156441.16666438727834100554.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173146178859.156441.16666438727834100554.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 12, 2024 at 05:37:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this test so the check doesn't fail on XFS, and restrict runtime to
> 100 loops because otherwise this test takes many hours.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

