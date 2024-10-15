Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E2EDDBB;
	Tue, 15 Oct 2024 01:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728954098; cv=none; b=OuZ7Ql5Ar8/vKO0b5Fgv+ANe4CrOhTQu6/hgTBmz0CFKiHyGJCTGA0broa9LbhuhLJh7IYEFnp3ajNEixVXyYxAIfSdPst5zTFZd5805iNn+XyS+v0WaamZMktqDUmXYQwxlyWGUFfzAXpKit9p1sxEpxAqIHlP5udSdNpCrRa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728954098; c=relaxed/simple;
	bh=d2dpPwHVxHqGkZsAVRta2aKkIkGchpw26hQ0FOkHcss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8+Av8VZ0GxMbgx33L/x/DgCAgEhT1xj6dy+hke71IyCGuVNLC1FgrLcvfxVhSeIFzpuhzdvAYnp2u3N3xjJ5CoSv0Brc9pmIKRjdE9KePaEVYkQRzSSU7PtBMZNCDAOJe6aaK6+lj+XzChw/kgxM4hQ6HvHSe+l+sYosUcX7Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTV/7tRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTV/7tRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8F4C4CEC3;
	Tue, 15 Oct 2024 01:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728954097;
	bh=d2dpPwHVxHqGkZsAVRta2aKkIkGchpw26hQ0FOkHcss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jTV/7tRaLMyDPBxjuluGh35h+dKabeCdVVRzXlLHz/8j79QcLJ1QGDPS4ysryaW0+
	 vFDKllxWdCk2XYbRChky66etbu1uRYqyIz/F6x2aduaMpGlERZ8QifzspCtxA6ZbuU
	 4RRj3YbpO4ZpGzyjJZ/NGAFyW/QM9hoA4rkPC23HWyS+WApFNXg7TwMi0P137uJKss
	 O18qtM5piWQju826lu4gTGaeyWM9V1q9jGEvT/cboAepFdowKwWLCNXHHyjzONRWUC
	 irRg59/KO87mYRtZ+T/SoxmGycJRF79dT8d5Bza0khbp0xw/cKtsTVSdamJnRhx/1D
	 ZTFMjzriMJZCg==
Date: Mon, 14 Oct 2024 18:01:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCHBOMB 6.13] xfs: metadata directories and realtime groups
Message-ID: <20241015010137.GO21853@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
 <ZwzNNnbHhlCi8REx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzNNnbHhlCi8REx@infradead.org>

On Mon, Oct 14, 2024 at 12:50:14AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 05:24:02PM -0700, Darrick J. Wong wrote:
> > I'm only sending the kernel patches to the list for now, but please have
> > a look at the git tree links for xfsprogs and fstests changes.
> 
> As far as I can you've also sent out xfsprogs and xfstests patches :)

Oops, haha.  Yeah, I meant to adjust the patchbomb letter and forgot.
At least I remembered to split up the xfsprogs branches into libxfs-sync
and non-libxfs-sync and omit the libxfs-sync branches, unlike last time.

Baby steps...

--D
