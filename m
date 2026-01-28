Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095B81D86DC;
	Wed, 28 Jan 2026 05:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769576731; cv=none; b=JGCa9XvM3DfPSD8qXUXzKSwuovykJbNAGyC0ewqXtuCegNjva8CYVsnbEeWSptFIdsMRxfxggCalTk2YrA73IZjGybr/2PwLKO/5/eLpnOYhCqaYk03/8pI3Y0sMlsxw2CYivyCJRqOlOMORpPURJOsY5eHnAkasRj+P/CYzUvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769576731; c=relaxed/simple;
	bh=b/1XT9nyXAp8VF8G/YHRzh5mkMgIuALfVJRYBByMXMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FD965SJ0durDzyo7HvYjl4kha6TeNRCIE6xAITKb5s9+WkuGJE5Ob/1nQ2WmGDISDee7XcBxKoaC65xOHNlTSKIsjxs62T5dzMHKxWzhlOVuRSZvlvsSc8vfBmG959iN9ISF6rVCw+vMvt2cXeqeFJCwt/8N/6at9+0NA9OTCSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dI03Ai9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dI03Ai9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835C0C4CEF1;
	Wed, 28 Jan 2026 05:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769576730;
	bh=b/1XT9nyXAp8VF8G/YHRzh5mkMgIuALfVJRYBByMXMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dI03Ai9RvDUXTgc/87kkhUrp4tUQMjuddF0d5Y9xVI5jFgfN7/nXSVcAJbFWgnetC
	 nXHCwvk13T92bxJHSrstm853q/34fVUEtWWuWGnUWTT5eThnfVWcUor27kMmOKMXma
	 uWIjL6zanNABDMQ190tjRPGcnve07lJxwhZklTE3UBaO+Z7iZw6+lMycpdI2Ej3TjE
	 YASytQ++LgGvzO3Hf/aArTBWnMGuXIu6ULmgiXXlyO3C3GqOB59NNodK+FPSQ5gpGy
	 w8v3/nNdgyEGMyZeij/XoOm2WaUI/EteuQXnnuZxvqO9knXneheWHtzCa+VDIvDLkD
	 QfX2XRWiZvzEQ==
Date: Tue, 27 Jan 2026 21:05:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: test zone reset error handling
Message-ID: <20260128050529.GM5945@frogsfrogsfrogs>
References: <20260127160906.330682-1-hch@lst.de>
 <20260128014255.GK5945@frogsfrogsfrogs>
 <20260128033819.GA30962@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128033819.GA30962@lst.de>

On Wed, Jan 28, 2026 at 04:38:19AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 27, 2026 at 05:42:55PM -0800, Darrick J. Wong wrote:
> > > +# try mounting with error injection still enabled.  This should fail.
> > > +_try_scratch_mount && _fail "file system mounted despite zone reset errors"
> > 
> > Is it necessary to _fail here explicitly?  Or could you just echo that
> > string and let the golden output disturbance cause the test to fail?
> 
> The echo would work to.  But why would that be prefable?  Is there some
> hidden downside to _fail I haven't noticed in all the years?

Nah, I was just wondering what happens if the test keeps going instead
of exiting immediately.

--D
