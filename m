Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB32154457
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 06:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504902; cv=none; b=UiXBCA7vWuZf6Ie4VoMsllKIuHzHf3tpnbVKttRBDgITFprHEPQbotyhrbbd+zFyigp86Jh3RfpMUdzc68ER3Hnj+oTPFTTgQ9k1gXdyyz5WiQYq7IPRCu/L5CkcjbTEkM2rtT1mYmwxbHq4JyWcFurprMm3BQy0On8Mn8GgpIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504902; c=relaxed/simple;
	bh=cW3AzU+463oripl5Kein5VriV99G/4Cdf414wYTINxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBB3coP41pXkEibUlFyiHJywPVAA5JuOkIuKEREShZpX+bDnDFVE1820I0atdCczqtB9KSR15u1W2h90xFvDpjNQJwgIbexiz3c1T6fklyhoIeHOZNe7z4wkRPKNhBkautJ1zJLJFliAkZbWg0VqWKmTKoFfxCAPLeYyWUgS/l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mlsZgdp/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mlsZgdp/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zJXR/o8eENkfL895KcPg+lw4GflfaofTjCmPPfhP3TU=; b=mlsZgdp/rsV48MninyIN5Mqnj7
	WfHQvPp7X9dh11YpSSdlwmgFfPjo1+/fwYAnE8eg5bOgoDK4IQc7PfVGwwBj3y40coAa40P2gs8f/
	6g1l/Q+s3Cr7mWYjtFBTzMOYlcEeaG9liifBWGRZd8tnvdvvNyjy5jUrIaG84Dw1T+QcMYMFZgu4E
	kQOgvHDBffay3N1pv7I7YrvWhyJZvwaXXYX6NLSTGKqvPqjv1dkIxU2r9dy3rJgtEWKNAeXzBRwNf
	mXagPXOWL0wkA/Tw3pg2FulNAhbXwClYX1YtJe2Anj2AgGod99HmDsZuIyk8XichmZyXMo8NmJVl8
	4wTU85Yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNnxU-0000000FldG-3Et7;
	Wed, 18 Dec 2024 06:55:00 +0000
Date: Tue, 17 Dec 2024 22:55:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/37] xfs: online repair of the realtime rmap btree
Message-ID: <Z2JxxKSSMS9NH5oR@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123864.1181370.13663462267519047567.stgit@frogsfrogsfrogs>
 <Z1viTA146gDB-ddP@infradead.org>
 <20241217204112.GT6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217204112.GT6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 17, 2024 at 12:41:12PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 12, 2024 at 11:29:16PM -0800, Christoph Hellwig wrote:
> > > Repair the realtime rmap btree while mounted.
> > 
> > And actual description of how this repair works, and the changes to the
> > non-repair code required for it would be kinda useful.
> 
> How about:
> 
> "Repair the realtime rmap btree while mounted.  Similar to the regular
> rmap btree repair code, we walk the data fork mappings of every realtime
> file in the filesystem to collect reverse-mapping records in an xfarray.
> Then we sort the xfarray, and use the btree bulk loader to create a new
> rtrmap btree ondisk.  Finally, we swap the btree roots, and reap the old
> blocks in the usual way."

Sounds good.

