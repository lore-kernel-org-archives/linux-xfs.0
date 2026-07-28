Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E4C329E6C;
	Tue, 28 Jul 2026 03:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785209128; cv=none; b=IsqHwmE3TpRLvmnmyitfVtvnsaii8yW+UGNQOKfhg3vEhZo9OCkJrilfTSbWNKluihaZxqHxqoWOGU/WWrm6AOfBlJbmgT2eEaW3tAMRa7b9WHuibF8bxk7bGx98gFBnelNo1pJAE03CFhS1hu5d+/jfM/88ZeWaTF+nVJ1eyYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785209128; c=relaxed/simple;
	bh=OzX+zk8p2qSn6Mk6DVxXt3f7uVWmvAklaSQ3UVn/w30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCWFkFKb70CrV8TiVbeCIQK/atDbUufnGRPljvtuR/j+LESzb0gDz1bed42VkFdOnCDSu4T1gqCv3Tkgt3H+VEhdu9+y7VzGdjtX//p5oCjtPvEB2HfOvYlkV2wl9XgwyaOlR6bKb4LsXJ5qoIcrBjIZvEZhz5Sz+hpgocDYiYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ntdokpKn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ntdokpKn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OzX+zk8p2qSn6Mk6DVxXt3f7uVWmvAklaSQ3UVn/w30=; b=ntdokpKn6hyaPjVDvKMnHq0WaO
	Bw6/uC8i+zcRR6kjfqPsfOjoTOns5rdkEtOhXlAHWoHDxV9dY/jYu1mqVVhGjoHZRjT61hLTNyh4W
	IrZVTNQo7NfN/IIQTb0uWl8+HfnMzgZGT+w9WE8ChFzbR8w1RvB0OG1D6wimlrWW0nerGY1xjoy3k
	7reypKNI0lWLXqjvnClA7KG7v8pBYj7cBdCeGNroEcUTIEL7MIyhMgOUC4vMJaMabwMnHd1f9Ceh9
	ZpphmNFvog8WXTrW5YL9XsQDu0Xq3Ba4ZyTK4uIPzNrjYv6WSSsHTA41UZRo4Z0tBDMtAMT64PFeU
	+/UAm2Nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYRa-00000004KF5-2Rd5;
	Tue, 28 Jul 2026 03:25:26 +0000
Date: Mon, 27 Jul 2026 20:25:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfsdump subtree restores
Message-ID: <amghJgu6Xhhmjlkn@infradead.org>
References: <20260723062617.424905-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723062617.424905-1-ddouwsma@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 23, 2026 at 04:26:17PM +1000, Donald Douwsma wrote:
> +
> +_do "Creating l2 dump" "$XFSDUMP_PROG -L lab_l2.0 -M test -l2 -f $tmp.dump.l2.0 $SCRATCH_MNT"
> +
> +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> +_do "Cumulative restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r $dir"
> +_do "Cumulative restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"
> +
> +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> +_do "Cumulative subtree restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
> +# The next command core dumps prior to xfsdump v3.3.0 when noref_elim_recurse attempts to
> +# rename directories outside of the subtree when their parent has not been created.
> +_do "Cumulative subtree restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"

Maybe break these lines up with \ after the description to make
it a bit more readable?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

