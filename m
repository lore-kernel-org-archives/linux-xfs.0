Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C8F47799E
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806419; cv=none; b=Sw3e0wjahgbXkb9cUYuVnug2OUPzRK9dgRp8H7xY0KSkG+d7M+Yg6/IC4n2DXYJgPRyqK6ef6mtrw6wH8U3AtkeUs+Hcc4b2g4HCenHSQJKzJHvw5GpgqcKnnpCKxaLe0bEGbx7SgWNmpBAE1X7LUaUFT+dOIEIQCd1VL0KR6x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806419; c=relaxed/simple;
	bh=HVYgNd2/fpL8yWq9ffCsp+s+R/tRkTRq7l6FFkmpt4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmWy8PAUgzXYsqoGKTYiftsCG3BmHaj5CaBtpx7Xi+G7ZNkCF5Qji8EsFjgMedGHrGHeEY5TlJJKFoePMUA9XhfJInH33utaRdhGIbeN0VmeY5Te6OWzWjrMhfxamVtA/Og8ZbPm0EPeSYJQrBgyFIgIPi7kJ1D9N/HuVjIzFRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VSuv41rY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VSuv41rY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C8CHJuOFXlpdvvZmOVhRBhuJzYt8lYwSU+MBjfgFFGE=; b=VSuv41rYjbBcV/MMtMt0ZTY/Dn
	vyLQkEFfnWxy/vGwx2BDCRbs2dPL99Z3jfpa513HUYK3TpCcoezFjls7xsa+nIeypu8/sKQ9mhg8w
	KrUGARYZphHpw/pe1ACN73swJBlrWsHTowkfBpIaVKwfHjD1NVAVlDHPb0nljJ0qlC1SFZj9kJXQ4
	fpzo/PtdmoN0A3dafMktGsznmG/+Bwe363bcEuwwp+uPb02WR0GMJcCOuTG8qB+He9L0VyryyEuV+
	PuA1Pnkd/17+B5pG84EN5psLUm+EBlOc0Ti2RT08mFcBPQtoP3zCBdLNOSNMCMnYqYN8KMUOFP2ss
	waZAqxTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGEhM-0000000AOyI-2odp;
	Mon, 12 Oct 2026 12:00:08 +0000
Date: Mon, 12 Oct 2026 05:00:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Lang Zorro <zlang@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Norbert Szetei <norbert@doyensec.com>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: add regression test for swapext reflux
Message-ID: <aszLyDHmUXXprhyR@infradead.org>
References: <20261009221130.GT1615495@frogsfrogsfrogs>
 <101C0648-521A-4ADE-97A2-E03C7A43E4EF@sandeen.net>
 <20261010154147.GV2705364@frogsfrogsfrogs>
 <c23434c9-0d06-4390-ba2b-0feaf7d747f9@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c23434c9-0d06-4390-ba2b-0feaf7d747f9@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Oct 10, 2026 at 03:57:19PM -0500, Eric Sandeen wrote:
> > 
> > And, uh, you could turn on exchrange in your test config like I do,
> > especially seeing as it's been enabled by default for a year.
> Sure. Lots of people run xfstests, sometimes even on older releases! If this test is
> specifically designed to test something that requires exchrange, it could make sure
> it sets up the test to do that whenever possible, even if not default or in an
> environment var.
> 
> I'm not actually sure what the overarching fstests philosophy is here, though.

There's not overall philosophy, and that's a bit of a problem.

Whenver we have tests and the config specifying mkfs options, there's
a chance of conflict, and we're very inconsistent in dealing with them.
I think this test would probably also run into that if someone were
testing say a v4 fs config.

I've tried a few things to clear this up, but it's all been bandaids
so far.  I think the only clean way to deal with this would be to
split test into difference categories:

  1) "macro" tests, using TEST_DIR and SCRATCH_DEV using paramters in
     the config, and not specifying their own mkfs overrides
  2) "micro" tests using SCRATCH_DEV using their own paramters, but
     not those from the enviroment
  3) "supermicro" test using their own synthetic loop/scsi_debug/etc
     device not using the option from the config file.  Or at least
     using new and different options just applying to those tests

Getting this right will be a lot of work, though.
