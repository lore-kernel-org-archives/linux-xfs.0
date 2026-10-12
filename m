Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79753345EB1;
	Mon, 12 Oct 2026 12:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806456; cv=none; b=G4kwWyx7ToKrrgoVqMQlrrrJrDPF4aG2jVJayRs61jiNbR8O/KOZInYF9v3z60C9iucTz58LE6as7bN8v9ghY1UZmnK7M2MRatohf3rsEJA8cnB+7a2a5tCGKgavyD8ynFvHdXLBbx00+LcOlJ+J80mE38MFdfH90bzNsy7lE+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806456; c=relaxed/simple;
	bh=vSslSBOzAX2IIAsmeokHU3JH9aZkB8rbApV6+tkE5mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOHIbbg3ew+W/b9GFhMkFAFZ3gYj5xJGZIQuDSPwMSv0bb6l1+uiafd0NRl1lOrOzlNLeKzHBY92yMUv8PFQM1QjVrBQtvhhlrAvfSclNxMN/eocAkaGCz7i2ZpJ3qSTJ43Gl5KwhG0qYb59xNMieCOs+OAihDNSO7n5cM8glM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oVGRw3Fw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oVGRw3Fw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2U4kx0woTlzIPtRdmkP5aHdf61ghJ6TwJmuIXp+bnBo=; b=oVGRw3Fwn63i8GNYjY6pzmjzJb
	je4/4LeKLX+8h2Ug884brkRvSrwWZWprMsNWHwCzyWaJh+r8bflcJUa9cNJ+p95vS0FjHW5pAYGn9
	2ipDVAbfsd7A7ifcwIroYVd9jT8DObLr22/wCIiPYLUCHKVISpjMNzRx4GJbh2sVJotE6pygHpxav
	DQaiscy9Mw2LScEYevMdsXtZy3JQyyhex7etz2BdRdwrKc4MKbl6AifUS7HRfMLErlD2V4djnTkCF
	/2xY6qjBpth7qC9hNsyLxhkXVHktW0v7yBZGyHSp6RCHCxK3wPjMsYRg5Nhx8P+xmwifQQ9w6E1S6
	C7ufwyMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGEi4-0000000AP0C-415G;
	Mon, 12 Oct 2026 12:00:52 +0000
Date: Mon, 12 Oct 2026 05:00:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: improve dirent bounds checking in scrub and
 repair
Message-ID: <aszL9GYlmMgwoPxg@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612639.479634.13348969749056583205.stgit@frogsfrogsfrogs>
 <aroLMeT0OiY37AnN@infradead.org>
 <20260929041222.GR2705364@frogsfrogsfrogs>
 <20261010154634.GW2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010154634.GW2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Oct 10, 2026 at 08:46:34AM -0700, Darrick J. Wong wrote:
> > I really wish C had a way to make it so that you could hoist just the
> > *dirent walking code* whilst retaining the custom bits of functionality
> > (each error handling, and finding dirents).  I don't know of a good way
> > to do that in C that doesn't involve cpp.
> 
> I think I misinterpreted the feedback here -- I think hch wanted me to
> break up the contents of the loop body, not the loop structure itself.

Yes.  Sorry for now being clear enough and not responding quickly
enough.

> So, having broken out the "process dirent" and "process unused" logic
> into smaller helper functions, the loop body remains compact.  The
> bounds checking doesn't seriously complicate the helpers...

Cool.

