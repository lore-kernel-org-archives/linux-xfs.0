Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2E3C09F2;
	Mon, 25 May 2026 07:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779693272; cv=none; b=bPDOHvue2AwivDxqH/VJn1/XgKRCEF1DUObeCy1IunCZ5e3zRQFUvbAbzDCObPUHnXQy3eq9rk8J2aSIDK9oHexXQUTStDPnAvlKcITrY1Y0+8tNFHiwtnXlgIHdiIqSWpfkis87OVfGDCU9r3Oo+qRYLSvZDyqxh7TIiQ4PGOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779693272; c=relaxed/simple;
	bh=Gv+DjH3DuRMov/nsKLiOHdcW5QCIC7xj865ypNSyYh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shvrgXUCj6GZbzIfifxPJ9QeIf4Rl6gVJnKBqOsRtvMi0Rgq4CSuClW64RRdDL5iRmMTvI3ro4xHsXQ4+gteDi6Gyc4nKhG98S1uov/2tjGyeN9jXrQyMMD3rqz7csP9Wa6qLH7MO1DJiABcHqVnhRgLkyxVRbdZsDFPRofJKFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NiOrqSNy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NiOrqSNy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wkgqix2gKGeeM32weQX9G52CUZG166IwZQL8MWxmQc4=; b=NiOrqSNyNfZnwcxXBnRTnutbhR
	HGpgkaRrrm8iaP/Y1wggpPiut4dqcZjFYACAYQKT5L48M9Gozx8Irj+Ekd/Wa40FqmYMGC4R8AoRK
	bP1/KxzETR0sJbKdrspKWfkvAbX0oK4fqfOx+GzhHTg3wCrZrwsVKq2XFM7FZTrelhfK09g0nW8SW
	Isu7Bq7U9880TndL1gi4S0Xwt0of+78DjkZSUWb52Vbxvh/EBFQgpsdmEeYvqwc0+1D/R3J9wup6T
	+SVcZXumirmyp518RRdti7CEUcklbg6jWsILOpNv0FOLeBcdb0xzSnx3E5UWREX3HO24gv7g4kb23
	8DSlFDXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPW9-0000000GVSl-41zK;
	Mon, 25 May 2026 07:14:29 +0000
Date: Mon, 25 May 2026 00:14:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: fstests@vger.kernel.org, zlang@redhat.com,
	Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
	Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v5 09/10] fstests: add pre_clone_tune_uuid() healper
Message-ID: <ahP21UfAr3DvEG1B@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <0d9f455d20145103faaf4e45262ee44418cbaca1.1779367627.git.asj@kernel.org>
 <fbc03a78-0a6c-4c3a-9608-656d0df83d29@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbc03a78-0a6c-4c3a-9608-656d0df83d29@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 21, 2026 at 09:10:36PM +0800, Anand Jain wrote:
> > +pre_clone_tune_uuid()
> 
> 
> I missed the "_" prefix for pre_clone_tune_uuid() to match
> the common/rc style.

and a comment explaining the helper.  Also I think it should
be named to describe what it does, not what you use for, i.e.
something about changing the metadata uuid.

