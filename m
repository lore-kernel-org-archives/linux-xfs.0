Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDE586323
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737048535; cv=none; b=Br0fdNMGLeLW+bjPoB6gbw1IbV8ycenQCBiorLRf6supOtLulTTw8QHUV5w/BxK++sa+/O4lgm3wNHtAn+VznFIAJDIJPSOc3eqvfFaRgqJNFL5pM5jUm/ah/YGi7MqnG/uN2tNGMNHsgPJ9Pe3Yywc+mLaPYQIB5ipthP7wVy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737048535; c=relaxed/simple;
	bh=R4w9DnXaU/M/cXpPxQ3ZaPWtCCLtfTBoKwK2b5PfsmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJwFAReCQ7WsUQWp8XhL7W7nJr5Q9jdvMr+noPHKGXbGelpyzGpav1cicxuhl6THdaD+aGtDTtkqu1xslRBIfAc8+PWDcUbKkgC5ArptBwATE/LMlSpDZ6rz3WX+Bj6CHzjRy3bbiCAREe9Dh+yOyJOhdGugHUmnpi46F2eHfWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUuUkoo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUuUkoo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E5CC4CEE2;
	Thu, 16 Jan 2025 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737048535;
	bh=R4w9DnXaU/M/cXpPxQ3ZaPWtCCLtfTBoKwK2b5PfsmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AUuUkoo5AiiajNM0OMQ3TsCmJuwtybWBr1SBd4yJMqj75/901quGrGTs1CY3dh/yY
	 L5se5n0eVVAF/6ExDz7y4SXOz8SA6a5GMnj15i35sBfNFb8GRhK1daSI2bJX3SleiL
	 Gpn5+F9rATyriiiRANdArqO5iK7+WJ94jIyAOWhTqHKCxW2mijhKEPxTZ2sD6Zf72w
	 V9DBuP1w3omLJlYUDdlXF/kVoLOqVeS1eQ+aw5UEFPaqmkdJMDMOBMjIBYIZdF9nZA
	 NidUER/mrbepOQTdrVmSlPB2vWI5z0PrEMEexuTjfhaN2+xxBGykmJ5NFd7m5UACI/
	 pZwX+g0js+i7A==
Date: Thu, 16 Jan 2025 18:28:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: Remove pointless crc flag check from
 xfs_agfl_verify
Message-ID: <ejmkhfoj6e6bd4njcb34olq7xm2kkdusaxm7msl7c7uwve4gam@j5qcydnmh5vw>
References: <20250116163304.492079-1-cem@kernel.org>
 <20250116165352.GG3566461@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116165352.GG3566461@frogsfrogsfrogs>

On Thu, Jan 16, 2025 at 08:53:52AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 16, 2025 at 05:32:56PM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Just a small clean up.
> > xfs_agfl_verify() is only called from xfs_agfl_{read,write}_verify()
> > helpers.
> > Both of them already check if crc is enabled, there seems to be no
> > reason for checking for it again.
> 
> ...but it does get called via ->verify_struct, which in turn is called
> by online fsck and buffer log item "precommit" if
> CONFIG_XFS_DEBUG_EXPENSIVE=y, so please don't remove this check.

Woops, true that, my cscope didn't find it somehow :( Thanks for the heads up.


> 
> --D
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 3d33e17f2e5c..619e6d6570f8 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -787,9 +787,6 @@ xfs_agfl_verify(
> >  	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
> >  	int		i;
> >  
> > -	if (!xfs_has_crc(mp))
> > -		return NULL;
> > -
> >  	if (!xfs_verify_magic(bp, agfl->agfl_magicnum))
> >  		return __this_address;
> >  	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
> > -- 
> > 2.47.1
> > 
> > 
> 
