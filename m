Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457C9229B36
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 23:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757979476; cv=none; b=AWnqqaJkz3uyuiW+gUIa91MZLW154mr3fUORN5hOBUCv2iXyhOxBnwG1gX5ogKDQc5vOUZzGUd5yaTFTgCnP20Ktx84IlmzBIOuS5sS3E3HbSwyQbDXks/1SOMN56A99PHkoTf5aqSz98F/q81hqrLVugmv1hvrgv+91GZ2Q4uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757979476; c=relaxed/simple;
	bh=bDLBVXOdjk+rzNKJb7CLv/ZfAXFB7Z7yfscl/k2v8Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGENbISyPHwrLRU92qKUjaxaeqQQ0Nsg7Utjoteiz71mGU0te8FSiugdHWUEuXgGvpmjtU22qaf7gfTzfUE8wuct6zNzR00+Ho9aNP+b90zSOsr3QmS8dOBT2UsJolo/DOBkvUw+HX1z03pK0FiZKWLcJ35g5xb10FlKLMF7NEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QrmsQYJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QrmsQYJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DA2C4CEF1;
	Mon, 15 Sep 2025 23:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757979475;
	bh=bDLBVXOdjk+rzNKJb7CLv/ZfAXFB7Z7yfscl/k2v8Uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QrmsQYJuEamiWtjn4nDkJJhuTqgmt5RMQTn1HsOnr99FqPVh8IFTtKKA92pqk7mWd
	 Xj9SPiUqpZFyieXENzpd3sNOan+q2IBcDbzT47sw9BpZusIkZd11h+TgpNAtLg91bf
	 OfBJ2wczrQFHP0mLPgBXAKpC2XSKKGXX0524roiT8EyB9JbWjREXDEmDGJjUS+wdWc
	 UIyroGIaUtB37OC3EnF27n7dPJHq/b5dgRspQ05N4pkTVNGPWpuAVYaDK02nHnT09I
	 i7SoJs+6JiCF7lSXva/ol7EGI4VXYKYvU1cDloA1raai145RZfsPDpUEvQ+bdo0B2Q
	 NtdIFjbYxh1Ug==
Date: Mon, 15 Sep 2025 16:37:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: centralize error tag definitions
Message-ID: <20250915233755.GA8096@frogsfrogsfrogs>
References: <20250915133104.161037-1-hch@lst.de>
 <20250915133104.161037-6-hch@lst.de>
 <20250915191001.GX8096@frogsfrogsfrogs>
 <20250915205327.GD5650@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915205327.GD5650@lst.de>

On Mon, Sep 15, 2025 at 10:53:27PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 15, 2025 at 12:10:01PM -0700, Darrick J. Wong wrote:
> > > -#ifndef __XFS_ERRORTAG_H_
> > > +#if !defined(__XFS_ERRORTAG_H_) || defined(XFS_ERRTAG)
> > 
> > Hrmm.  So now xfs_errortag.h has two uses: one where we just #include
> > it without defining XFS_ERRTAG, and we get the XFS_ERRTAG_* values?
> 
> Yes.
> 
> > and I guess a broken XFS_ERRTAGS that isn't fully defined?
> 
> Yes.  I wouldn't call it broken, just not usable :)

Heh. :)

> > And then you're allowed to #include it again, provided you enclose that
> > inside a #define XFS_ERRTAG and a user of an XFS_ERRTAGS symbol, in
> > which case it actually spits out a usable XFS_ERRTAGS?
> 
> Yes.
> 
> > That could be documented better.
> > 
> > "There are two ways to use this header file.  The first way is to
> > #include it bare, which will define all the XFS_ERRTAG_* error injection
> > knobs for use with the XFS_TEST_ERROR macro.  The second way is to
> > enclose the #include with a #define for an XFS_ERRTAG macro, in which
> > case the header will define an XFS_ERRTAGS macro that expands to one
> > XFS_ERRTAG use for each defined error injection knob."
> 
> I can add that.
> 
> > > +
> > > +#define XFS_ERRTAGS \
> > 
> > Do you need to #undef XFS_ERRTAGS here to prevent the W=XXX build and/or
> > static tools from whining about redefined macros?
> 
> XFS_ERRTAGS is redefined identically, which is allowed.  And we can't
> undef it here, because we use the definition in the .c files.  We could
> undef it after using it, but that feels a bit pointless.

Sorry, I should have spelled out what I meant explicitly:

#ifdef XFS_ERRTAG
# undef XFS_ERRTAGS
# define XFS_ERRTAGS \
<giant blob of error knobs>
#endif /* XFS_ERRTAG */

You undefine XFS_ERRAGS *before* redefining it, just to make it clear to
anyone reading the .h file that the exact definition of XFS_ERRTAGS in a
.c file can be fluid.

--D

> > 
> > Also sorta wondering if for cleanliness this ought to be:
> > 
> > #ifdef XFS_ERRTAG
> > # define XFS_ERRTAGS \
> > <giant table>
> > #endif /* XFS_ERRTAG */
> > 
> > To avoid cluttering up the macro namespace if the file #include'ing
> > xfs_errortag.h didn't define XFS_ERRTAG and doesn't actually want the
> > ERRTAGS expansion?
> 
> That does sound doable, let me give it a try.
> 
> 
