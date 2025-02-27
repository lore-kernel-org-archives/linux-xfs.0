Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3D8227EBE
	for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 09:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740648340; cv=none; b=qDEkqOc6XhOZqaUk1jg/wEv2Am7CkZwbJjkVjIPZ7Wh2SD3Il50ZlGNB89ykkw5WYm9JVsdt5DptHo37UkkjDBoyQa+5gP/JkVBlMHNnir7MA4EQpvdRqsWxKmrLAItcj1iYXf4pM5IorVvnMGW9Uj4qhVRrAGm5EPPJ/Aqu8FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740648340; c=relaxed/simple;
	bh=dy/hhN4p0lABrMGzaAChH/mXyISGb0kWQbrID/XL64s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnE9+BnsR25h99E4kh6hodK9g/DY0rt8r1iR7xQNsMvQmzOw0IC0fJP0lOV1ieSW9mmH7YvRTb/UEkTr89m/IUKDFVYS6vH5l5VofuJG4oCWjkqjVWs4ZBPDrJoEMBi8bpYxnso7QcCy9dGd67LYea2b4NlDjsm42/Cng8b+2ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTyS/ruV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTyS/ruV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7082DC4CEE4;
	Thu, 27 Feb 2025 09:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740648339;
	bh=dy/hhN4p0lABrMGzaAChH/mXyISGb0kWQbrID/XL64s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tTyS/ruV0WSbjyzXhUsFB2iCwSAupYJwQ55n5DPW+EPGxebDFaZjJVXI8uTqqoA4a
	 iotWOy6ncWUVbDIzgfgkS835Uo6ICyofvPp+0tYkonjDbWFUSKNPPR3DWoS/3bifF6
	 DwtQ7PUpkiey66j4yxWmrOXMUBGZwe/lSA2jpWOd4VsrAvhu6xe6Nei8AXS52R+904
	 b1jrouxw2wOppnfc1RRWryoduBJrhFaaYAstPqlZni+IJ2m45hN0Uvmvvwe24VNkAh
	 DcE9R/yd6yOvKyXtjpp0gXVw5xsLV7f59yGnhrKIDVi1GTU+aaGDv4sI3bmK/b6zji
	 510AJ9ZOSAI9A==
Date: Thu, 27 Feb 2025 10:25:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v2 0/2] Add XFS support for RWF_DONTCACHE
Message-ID: <vc7eqsqiyb2pnom4ekaaxmz4abt535a73bnathq2nxbt3yspoe@fnehin4xmzdu>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <3qAP6uD7IZfsvM_o-0b_bXiyjJeNN1cMEaz_Nwk3W6LJ82RK423PSvZPG2VLZU8dIA4Cq1F5uU50XmgFQZgOTA==@protonmail.internalid>
 <ba718fc2-08ba-4d7e-98f9-47f3f52c13a8@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba718fc2-08ba-4d7e-98f9-47f3f52c13a8@kernel.dk>

On Wed, Feb 26, 2025 at 10:30:05AM -0700, Jens Axboe wrote:
> On 2/4/25 11:39 AM, Jens Axboe wrote:
> > Hi,
> >
> > Now that the main bits are in mainline, here are the XFS patches for
> > adding RWF_DONTCACHE support. It's pretty trivial - patch 1 adds the
> > basic iomap flag and check, and patch 2 flags FOP_DONTCACHE support
> > in the file_operations struct. Could be folded into a single patch
> > at this point, I'll leave that up to you guys what you prefer.
> >
> > Patches are aginst 6.14-rc1.
> >
> > Since v1:
> > - Remove stale commit message paragraph
> > - Add comments for iomap flag from Darrick
> 

Hello Jens

> Is this slated for 6.15? I don't see it in the tree yet, but I also
> don't see a lot of other things in there. Would be a shame to miss the
> next release on this front.

The changes looks fine, they are for 6.15, so I don't push things to for-next
for the next release while working on the current one, I'm not sure I got your
point. What else are these 'lot of other things' you don't see in there you
mentioned?

Carlos

> 
> --
> Jens Axboe
