Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1E31AA7B9
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081662; cv=none; b=BIubv318Z18N2RSXKI+9Qg1ExCn4pMqbV6V3W5kpZPmCEqLoTuZZMnA4/NmjAIHorfjEZR3SQSMLsYhc0OzjaavlHPsxIRuUo/zjFfiHYkTR4tLsaLi+UrHCChRTvxC4IRRSN2uPFX8uAYteJT+pgsbQJG9hJo8AbY4CsYSYgHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081662; c=relaxed/simple;
	bh=c4B7h+lDQ5wmzaLdCX7Q+fDg+ipHB7dMGHDNORVGT0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqfu7BxqOLn0cjdCHbq9xSVN4gNHQ2HHVRlGamDUEjWHtA2WMJVnbWtFtUPrS0nA3DE4ZkYa5pTxAWa0Jd+1xSszQoQI8GA7YyKREHoAlj7P0CNCDLQ5+SMrioSImE3FZ1HF7dZTgRrValJ2GoX8nlCP499ez/jydwsb9uqfXxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PNyf+7xU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PNyf+7xU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o0s41RzCafdnQRj11dOwXgcsS+f1wRmsUHyy2Ck6r78=; b=PNyf+7xUBnQJT+E+I/HXbCEMAY
	Vsv40/EfAM3plJBt8IdsTtU+KAYbwa69PsESoPsWxeMDBe5Max8fS7K9EskR7RpFh83VtB9vezXzZ
	fY6RyPxh5bXlbTjo+hXBe82HFBnTAYrIsz4l3gwOdKQOXO7wNRZVwsOtpjoJerO27OruHiUyoR65S
	Xa8pIkjCZj4UKMZsASN8obZ4oIGsBYkTtanIPjqyQsQwYqofYLgzDstM8HcVg656uoereUGlt9BA8
	E7WXFRQq7dfmQZyGmzhWky2zS1MQj4e0mhv1JL7j7sRrc5uF1D/koWTNvEq+boRYXFWWTAoDOeo5w
	RrV3dYqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1r3-00000003ETB-0nWg;
	Fri, 13 Dec 2024 09:21:01 +0000
Date: Fri, 13 Dec 2024 01:21:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/43] xfs: check new rtbitmap records against rt
 refcount btree
Message-ID: <Z1v8fe60Bz9HCdPl@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125183.1182620.16371102582007178677.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125183.1182620.16371102582007178677.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:19:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're rebuilding the realtime bitmap, check the proposed free
> extents against the rt refcount btree to make sure we don't commit any
> grievous errors.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

