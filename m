Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9392AE8B;
	Mon, 25 Nov 2024 05:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511685; cv=none; b=nc4ivknGwSjKMikizYQ+cuIGrqxHUW/ZT14G9RSn6TMAuvsha0s3DuiRWx4oNZNmNjfjrOmEN+PHz7vdbhQ34pxL0kiphW4BSQMh44h1lJg0bOXSb+8BzzDVwSoODaYWJDVoCW+EiXUWg4vDA1Wcs9Ef4E9s4tPXbH8ybjbanx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511685; c=relaxed/simple;
	bh=PK9H/tzwuqc0etiytxAfWT1+s0CJb3TcZDYsF0Xi98A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txv5TJutRuAoQbC61EQgvamecgD1rp6uQ0Ytf50aztKEqIXb2oAqtHMi9NCot0w9XoiTQB8nw4tq4dghMwkcXr+aq0dlM9EKaamcYB8Ivl2tf8Q6TnLh3qUj3woc5QAZsk+eAdtivo6gcPB5I520CVI5wJXAejvHmVw9jXdBTOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YEYDcb4z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YEYDcb4z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J0mC1lCuZ9q8rvoZbprDCcOkakUzfkbqhpEXLbgVEXY=; b=YEYDcb4zxOt002iTMLTdWGBNDm
	NmEybRIQDIBNLNnsCwruWKOPl4FZy5yuWKhHy+YN8fJL7kbv7/bDdHDjqdLJM+slY80OsRKche9s1
	cfFPrh7nLyj+eqOeR1RzRA3+1SAb30IOioVtYCXNxwxXjgGPFsZUcAYe5U+Trkn3QUgYowkNAlavw
	jw7pEf+6st4JiUQvKj7NsPo3NeBJwvvwVk8TFSBCMbqfshC/cMHGFzlcpSp6SSOQYvDEryQcExKlp
	8C+EZGw3xbCQunDstEoUcRmuAXoaSlmo5r0/Y/Ff76MYkP0vDPdjUxgrSAZZYWjAoPtR+xl6K71yM
	QVcInc7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRQp-000000074lL-4ALl;
	Mon, 25 Nov 2024 05:14:43 +0000
Date: Sun, 24 Nov 2024 21:14:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] generic/562: handle ENOSPC while cloning gracefully
Message-ID: <Z0QHw2IGqnTsNcqb@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420148.358248.4652252209849197144.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420148.358248.4652252209849197144.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 22, 2024 at 08:52:48AM -0800, Darrick J. Wong wrote:
> +# with ENOSPC for example.  However, XFS will sometimes run out of space.
> +_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full 2> $tmp.err
> +cat $tmp.err
> +test "$FSTYP" = "xfs" && grep -q 'No space left on device' $tmp.err && \
> +	_notrun "ran out of space while cloning"

Should this simply be unconditional instead of depend on XFS?

