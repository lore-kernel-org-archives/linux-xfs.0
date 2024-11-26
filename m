Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B831DB361
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 18:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732645508; cv=none; b=qWyXCdjXb4FM282IzidmGvB+Y6f12zVQEcAGD69qeRo4lj+tI7WXPMtGlzgPiS7OyIZQSZvFz2EBR0MOGyXOawRF0vFBuJ2Si9Yi1CXf3M7mPcQ1BkjDqB+R1Epc5Z3558E8Tznhhdf0ys5yO8FMQwP2xQ7J1JgplH2tomVflh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732645508; c=relaxed/simple;
	bh=ulngPNaev3ZB1P7y7iW0jKmMKSB9sqTld3ysz8XCzE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJPSVXj3B8fjopyaBbfTB1Kmb9dmsXYOesOM/bMelpm0I5aDDKXMn1Y8TrFsLvxS8dhk5XnNP367MUZjWmI/zNnCtbxE+dKFYsAXKMRRKf7s5+/VDD5Cuj4DJdyHNth0mRaHWBWhF9ImT5Ji3tZzsKNH2gpR9KHqxASng25ZG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/9KFQvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/9KFQvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E4CC4CECF;
	Tue, 26 Nov 2024 18:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732645507;
	bh=ulngPNaev3ZB1P7y7iW0jKmMKSB9sqTld3ysz8XCzE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a/9KFQvgjSyTlHoPTlmijtbswtRsTVOhvPSWDEmzdASPLoiKs4XlzHS5gMI3gnIuX
	 gB+blKwclBI4EU3R8Xdrk+y9vbGaILVF9DR7T0Jvb5uhCR3HChOpDZ0x8IOM7M2Wi1
	 vokx4FPdgxHYDuRIrySddtTxNDMmYFvhEd7J4CgbQPDCrzvAcWZ+MyNg/ZwxLnofDr
	 OCCL49HFzUkFo8jHOSax1edHia0joMjywgYz5g/5KWaMQC3NKYcrjbQwfyLR+kx1UZ
	 3jmossayjJKQLvBYEcEbEY6+VWsK7D+BvcbgZQxPZtplYuj5fImoXWCcJ9pNl3ANC4
	 obZNq1GeO0fKA==
Date: Tue, 26 Nov 2024 10:25:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/21] xfs: clean up log item accesses in
 xfs_qm_dqflush{,_done}
Message-ID: <20241126182507.GN9438@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398125.4032920.10688788085648644743.stgit@frogsfrogsfrogs>
 <Z0VchQGGV8rYy6Ej@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0VchQGGV8rYy6Ej@infradead.org>

On Mon, Nov 25, 2024 at 09:28:37PM -0800, Christoph Hellwig wrote:
> >  	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
> > -	    ((lip->li_lsn == qip->qli_flush_lsn) ||
> > +	    ((lip->li_lsn == qlip->qli_flush_lsn) ||
> 
> Let's drop the superfluous inner braces here while you're at it.

Done.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
