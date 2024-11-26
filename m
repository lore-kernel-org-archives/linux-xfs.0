Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D945653
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 05:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732598919; cv=none; b=E3tvHB4LGOQ77zBisqIevdLJI4waIPrEIH1wtZXzuk57ticplWLF58EZQd1poWjL1Oe93Yijqj3+4RJwvqeLX+K+b1Ab35RHNKW0oMaTPe7q70F+y4nM3O4oTYXDFcXRT4/m58/GW2mk9i0A/nEo6yRI7vTX5w0sMjOabX4y0RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732598919; c=relaxed/simple;
	bh=DbWqESQdG3XavBERC0BMXE0zF8KrApQv22O0Q2nPEzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAsyolcR+oq6A0yMIe1cs7C1c+NVfsx8+GOD2F7QovsMMvigzPMEE0muyqCCfZCyFP2PDk2A4cvmxmCKVEt/8mAqMO9CQsCoLYSC8fS7ZlpLiW5AjOFTLgupqMbZN0d/Gj/yzUNouSSoWrDFZsOdbXRrRfc/GhAKEVNrgIIcbrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HbCY4fQA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HbCY4fQA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BEXhuwS8NjU/S/t6s0huvS0ueWPTJMwbToOSzalX9Ss=; b=HbCY4fQAkVRjegSgh3iulBKhll
	G+K8x7p+S2Ar4dFmuPVHx9PHgKCcAN+KzM9uRPHBWsSmr0hyIK0zRW7zhmrGi1kxFWpUoeR0EjbOd
	YQ4dPbJo8PD5eVBjnymTszcibLrlTr12Bd7MuOYtW0MwEbcZiLY70s5s5CQJANDO898/PxPdHiOs4
	JUPJFx72EzACWmO58rfAmLTwaWwJBkOZwuRE8fzi7jrOV//d8O1AYxJ7f7ybfZBBeUjBKHHDIG1Wj
	5nC2Klg0erNkZ41ZdtToZrxa8SFp8z4QMQUdXdoRk4arhY+ksJR6Hg/GBJ+L0X3Hdpkiqkf9M8Gz4
	+gplBOLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFo7p-00000009fcg-3SR6;
	Tue, 26 Nov 2024 05:28:37 +0000
Date: Mon, 25 Nov 2024 21:28:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/21] xfs: clean up log item accesses in
 xfs_qm_dqflush{,_done}
Message-ID: <Z0VchQGGV8rYy6Ej@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398125.4032920.10688788085648644743.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398125.4032920.10688788085648644743.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
> -	    ((lip->li_lsn == qip->qli_flush_lsn) ||
> +	    ((lip->li_lsn == qlip->qli_flush_lsn) ||

Let's drop the superfluous inner braces here while you're at it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

