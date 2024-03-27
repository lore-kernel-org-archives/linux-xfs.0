Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D3E13A3F7;
	Wed, 27 Mar 2024 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711558758; cv=none; b=pnvPHGVQN5T42FoDZeEpxL8g7UhGjWJrfvYGwzesPLwVHlJ99SGIg3dyG2Iw82qhn3N8hCC85PKDFyKT6ylYeY2GJNYZjJt1+EvYMMlY2/mv1Nk31BDEOEeGJOf/wpaj3zXA2JICpcK4rQT/VJg01FvHK4WKDNQqIF/qwHEkRzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711558758; c=relaxed/simple;
	bh=ajm5OQI0eRDnM1c9YdwiR+ZNtPG3FggbkX8BzzzSehE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMFM16v6FVE4oq3EUBXSyLVLOR7yMZ+wPkVJnpyzMKlPVpR05pleYYEDe7RpwOq0ZDfFCNPGiIBHNW4zQqB8hufDcVKqvwjGLZdI9F5c7l1RBInBw9AMro5Pky68KCd2fCrp09T5/DznmsR/3PNR8Blgg+DMnRmbcdqrk6MuBPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZZUppb7e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZZUppb7e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SKk0i2OTam2me4BcDSIDIjfRC5F9vU9QGRHsjHGlJug=; b=ZZUppb7eqTzB8lbBAopa03Re2y
	PIMj5JdPw1GAqyCg5BUK94NHj3IzceR+4B2Jq2pAX98mnpz9Qd1asPa7Yde8pGcfhlzXvcAIF7Dbj
	TB6mrTZtkVdyN1ECKaCC0UrfAzC6KHyMTR+gEDw2b+0zYIqk25EmAiRLIYWOOON1LRq5BtG+EIaRD
	9tYabUwRHc7WK5RWw7bRJBtWakZN8QDBjqiCXeyGzHcOXIA2l4tW5RnCboDgaaqEU6+qEE+zkT76o
	OBHFkU3ldeH/lNYvqPJyKIpH8p4ltixvmJ4heu98VQ43u9Uq+ehWDCCHDTmVD1oBbZyPYZEHzjvdd
	AyXWN5ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpWcL-0000000ABJT-3qPB;
	Wed, 27 Mar 2024 16:59:13 +0000
Date: Wed, 27 Mar 2024 09:59:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH 3/4] generic/{166,167,333,334,671}: actually fill the
 filesystem with snapshots
Message-ID: <ZgRQYV_uc94IImTk@infradead.org>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150741593.3286541.18115194618541313905.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150741593.3286541.18115194618541313905.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 07:43:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS has this behavior in its reflink implementation where it returns
> ENOSPC if one of the AGs that would be involved in the sharing operation
> becomes more than 90% full.  As Kent Overstreet points out, that means
> the snapshot creator shuts down when the filesystem is only about a
> third full.  We could exercise the system harder by not *forcing*
> reflink, which will actually fill the filesystem full.

All these tests are supposed to test the reflink code, how does
using cp --reflink=auto make sense for that?

