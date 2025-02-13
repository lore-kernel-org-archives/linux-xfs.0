Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F8427540E
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739486861; cv=none; b=KutTazuvu+cKuJIJOr8l3OFfmpOPbToFE3Uz7+MTj+XT2qMkMf7wCDUVAmMEq3DmHDN49BzjAxCW2WaQmBWoZz6PQR7QzZOh2UxwyDtndZyqXWkfgOlqNKDJXQmrDgQDIl+S7zb6kb+e/iUK4FitrTyV9ABWrUFcUo5neRE7eWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739486861; c=relaxed/simple;
	bh=wbhaDAvoUvxBqVhwvclQgvVqo+5peI5vmtlzwCfacig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cfo4DrEa2PCxPJrbKibSoQsNCC86ImV+WjXS6ar625HFT+GZyEvmBS9ZqRRkrsnPMFSVv+5woELylhz6HWaQqVZnI/Chi7hr3ncFU0GEIsd0fJnF4ranSJU6pcf/M5ww4Ir8EsAfXKsw9/ZQ0R4RIsIVnRu+EgQNlXzN7TRsjDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6YKV1Vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6YKV1Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA470C4CED1;
	Thu, 13 Feb 2025 22:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739486861;
	bh=wbhaDAvoUvxBqVhwvclQgvVqo+5peI5vmtlzwCfacig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C6YKV1Vl21payLlHBk582eCLsG6nixVhteoQhxMfkhyD0Pz4fi/mKsb7NYqVXkVGp
	 aHo8IpAf3qmqil+60TaXtkLN3ayL7AhFj/XVVR9jjM1/ycIcj4hjpYMfrh7bOCYTkR
	 E/JiO9g+ws/XIEB560rMmOboKD9vCVxDfZtgMTTno1dIZvWU6v2jhwGpMojpQB2YAK
	 FGmDe6bu96J4uSHPVi+xafd1AmnH3qFIrN6itw02jw5Q2kxNBRCj+6/dcCakvHBzvk
	 cZ8Qp6+Y0BWpL+rADbY1cRP45lcJ9A8xtwpTmGRsz5bK+RXsNkM6G0M57lhSFX5rZZ
	 HvovhQp/3IY8Q==
Date: Thu, 13 Feb 2025 14:47:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 09/10] libxfs-apply: drop Cc: to stable release list
Message-ID: <20250213224740.GW21808@frogsfrogsfrogs>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
 <20250213-update-release-v4-9-c06883a8bbd6@kernel.org>
 <20250213214541.GQ21808@frogsfrogsfrogs>
 <2yzj7wrqodq7d5tt6mcj2yrplgf3kwt34ewl2y3rpcizan4gzb@rj6b2agkbhre>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2yzj7wrqodq7d5tt6mcj2yrplgf3kwt34ewl2y3rpcizan4gzb@rj6b2agkbhre>

On Thu, Feb 13, 2025 at 11:27:06PM +0100, Andrey Albershteyn wrote:
> On 2025-02-13 13:45:41, Darrick J. Wong wrote:
> > On Thu, Feb 13, 2025 at 09:14:31PM +0100, Andrey Albershteyn wrote:
> > > These Cc: tags are intended for kernel commits which need to be
> > > backported to stable kernels. Maintainers of stable kernel aren't
> > > interested in xfsprogs syncs.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> > >  tools/libxfs-apply | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> > > index 097a695f942bb832c2fb1456a0fd8c28c025d1a6..e9672e572d23af296dccfe6499eda9b909f44afd 100755
> > > --- a/tools/libxfs-apply
> > > +++ b/tools/libxfs-apply
> > > @@ -254,6 +254,7 @@ fixup_header_format()
> > >  		}
> > >  		/^Date:/ { date_seen=1; next }
> > >  		/^difflib/ { next }
> > > +		/[Cc]{2}: <?stable@vger.kernel.org>?.*/ { next }
> > 
> > You might want to ignore the angle brackets, because some people do:
> 
> The ? does that :) One or zero of <>

Aha, I missed that!  Thanks for the correction.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D



> > 
> > Cc: stable@vger.kernel.org
> > 
> > which is valid rfc822 even if SubmittingPatches says not to do that.
> > Annoyingly, other parts of the documentation lay that out as an example.
> > 
> > 		/[Cc]{2}:.*stable@vger.kernel.org/ { next }
> > 
> > <shrug>
> > 
> > --D
> > 
> > >  
> > >  		// {
> > >  			if (date_seen == 0)
> > > 
> > > -- 
> > > 2.47.2
> > > 
> > > 
> > 
> 
> -- 
> - Andrey
> 
> 
