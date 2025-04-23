Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6031E9B32
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745398109; cv=none; b=LQjKXi0SOIVjHBWpaukboxeXMh4rCeYSBwlAOYSA4XC8J50l/++ypfLZTV4c3OhZn5yWYxin3sYuz1rnw7dHAQwXZK2dlGs4kVbdFpx/iYFfX0bNk+jGcZbd1LlFp2Xk88Kz01hRbquIS3DmmILD8z2zFq5vvzw/HV5AO7EDHVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745398109; c=relaxed/simple;
	bh=HhH9e2qfBFZKXiiFTSG2HNwetfYY8VrMf+gXa67iIto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFdgnHNvP0pM64dpwiMObLIrVJ1MpMLiqDaZwG6YROCdhYLkyls5YMIaydRw3SvZtd14voJ4+aAMTOF93yXM8Sz8QNqXeCewosHd5fArhC/BOVzYfpQoyVBeCa3QIus6N8TVkThiAbSkpLzfWhUPdxFY82g/0ilczn9ZdUi9K4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d2RBymzH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d2RBymzH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cwv9obxCYYf0cI0SziMdOs1cZP2RDZtq+ygzqXGFqas=; b=d2RBymzHA7P/eojrIbTbjAjvUR
	8ByNRObwTvIJkgpU6n6TeT6P2n1FddMQ9M5kxntg7iLKd9q/TjFaWRbUeAk7+FPwC9M8AJUvWEKIo
	zam8O+aTaODhywcD9nnHN92Pv8PhHfPt6VzcSh6BKVgOJew0N+H4Z6LaJ605VfnNbxFWwuSKVPg/s
	Ui5XYREuRihNKm0MPLICzBJezl9OPBdxLmixVWo1zEuKySiN8l+cdGBrBoMq12ODKzASwKm+yWmz8
	++XX12BKAOXHO3dk0neyDq4bS0JJ+CCO8ECDbpoz9lz0fmdYtFrEt04qousSLkcfiqO31TQ+zuqUB
	8eNfmxKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u7VmM-00000009otb-3uM6;
	Wed, 23 Apr 2025 08:48:26 +0000
Date: Wed, 23 Apr 2025 01:48:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v4 1/4] proto: expose more functions from proto
Message-ID: <aAipWpLfxraBTXzp@infradead.org>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
 <20250423082246.572483-2-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423082246.572483-2-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 23, 2025 at 10:22:43AM +0200, Luca Di Maio wrote:
> In order to minimize code duplication, we want to expose more functions
> from proto. This will simplify alternative implementations of filesystem population.

Nit: please cap lines in the commit message to 73 characters.

I wonder if these helpers should instead move to a separate new source
file.  But let's leave that lingering for now until we're fully reviewed
the functional changes.

