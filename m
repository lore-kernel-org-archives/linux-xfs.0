Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5C8EEAA;
	Wed, 19 Feb 2025 07:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950055; cv=none; b=NgOL9TMqTCwj/+awkkvlmsGh4xZb0ylGHHCX/DNpr+I1Jjc6kkYf7gRC1I2omwF6ZgO7uPx5XK+NUVYjlIaJBtrYZlMY0G/Tvb1FtvNBmIArfIF1gveh1jZI6yANaJ+njZd2RsbRX/Qg5lGsGM//TZlMvqoVxMba/3E3/3XfCcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950055; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QghInhcPR5vvmW1CwpC8xW0qCu2w8VvZAJH8DXDzgIZ5damoSya6jHYoDOBjBxyw6Od3Svjlf3jKaCNryXnhTZPIervO52NfrttUsFZL51Hk6+k3Z7yAehZuFwUYd88JFVGdhSAZm8LRb5qpd2F8Kx4F948JvgviHj4iF7Ug6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s2Go6DP/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s2Go6DP/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=s2Go6DP/ta86fsKmDW1PoUImCp
	LB2KMHgWwkSRXoB2T3kMBC5sMtOgs+V+4+p8uc8nwYSHmUPFiJfigU4qP7/pujWeVyxJuzw04/+Un
	yorNiBz8aFfBU8uLCDI9N5/FzDMyoWRPfXRNn2eumoRIBBBGI4ezPwamLmt7RQ4v2Tm0UuP2ixEYm
	7xZSA9jciHCgnParlTBR5jzmu1iWtdilaKe4/8LqFDSFnikp/xlBuYaxc/ZCXMM+jvPWiJt5BVbtr
	WUkQCGg8EX5dBDbar3McDdwc8ulGpCGa4YdxbYMf8axSVORQ1qglpFzLQUN3Go/d6kM6dbstHE5a2
	TzBgh7ZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeUY-0000000BEx3-1PQT;
	Wed, 19 Feb 2025 07:27:34 +0000
Date: Tue, 18 Feb 2025 23:27:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs/341: update test for rtgroup-based rmap
Message-ID: <Z7WH5uhX5VdYm_LI@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591223.4080556.9240285310117453482.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591223.4080556.9240285310117453482.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

