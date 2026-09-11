Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30849EC44
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142920; cv=none; b=lY0r/HnF4u92NKLcnabQOWhKqKYI4gOeofDQ4G4eOdnrTAxo8747H1yaINazqc8bn8MmEQLA/dDJV7gNci4NNG885LwrB35AP66hSjL6YALNuqJeWX2SpsjvGE2DhvV6UzhlbkwtdRrHnUOPVX4AxSPRfKVdgOXEoO26kd3XWDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142920; c=relaxed/simple;
	bh=04siACNRfBimJOwrxWTIKTMbJA6gzmffQI5KuKznEqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PY1rsfvgbRUL8VopS0MY4Jds3zDnp2RFtGoN2hPhwLRWcwQ3AXQmQWKNAjULJatL8NSj/Xa7f9tCiHA34p1wAyauyMRZurVRkLqG6w0VQoyHw2Q6I5+GC2SIauGDHqsssRHV2lmkZUsVnHAivLKKqjnKvABrHE1fyXECIAwZG9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3oAg7G4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3oAg7G4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1D96E1F00893;
	Fri, 11 Sep 2026 16:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789142919;
	bh=R93GVoyhWUn5LfFqe7mlPffiT6w/XOwOa53smt7YQdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L3oAg7G4Upntc2XnFPseu1Azj2ruqXSX8UCpD7ekxoQOwOXOHBiawGc4zNHhpccE/
	 yHIcNXR7KcTEicAjoKNv9p2NE9gVw/Wb8QXcWudA+2JYHAVmkBcg5lKhgqZvFcEL7M
	 CTJg/FCnTr0RfF6hksgmRWzhoXje7YlYuEoPA+on6GiL+7dZ++rFAIbXFfPliDmEdA
	 zQfxPg1LMsuMF2WCQqH7lzBoWIcEn8yFruVgDvSR9yysozEgCet9A2J75OaGhRFdaV
	 1HyBUMd5F7/GlIHsCc8ft2oE2lO29452mlakcl3NrPgy/lV1hp58XEtcbImyJqeRVC
	 G45rmiX19Kndw==
Date: Fri, 11 Sep 2026 09:08:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] mkfs: print config file for a given mkfs
 configuration
Message-ID: <20260911160838.GJ6265@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910566.4047311.11716167302378334931.stgit@frogsfrogsfrogs>
 <aqQa1cuREZufaWnT@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqQa1cuREZufaWnT@infradead.org>

On Fri, Sep 11, 2026 at 08:14:29AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 08, 2026 at 11:00:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a -c makecfg= switch to mkfs to emit a mkfs.xfs configuration file
> > documenting the user-visible filesystem featuresets of the configured
> 
> featuresets sounds German :)  Wouldn't english spelling split this
> into two words?

Some English speakers do, some don't.  I'll make that "feature sets".

> > filesystem.  This can be used to emit default configuration files as we
> > do once a year for each LTS.
> > 
> > Note that geometry information is not written to the configuration file.
> 
> I guess this is implied by "This file will contain only user-visible
> features" but maybe the man page could state this just as explіctly?

<nod> I'll add "Filesystem geometry information is not written to the
configuration file." to the manpage.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
