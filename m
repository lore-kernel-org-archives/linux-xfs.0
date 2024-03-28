Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1540126F19
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711647584; cv=none; b=j8ss32HA2FMGwnrH5VX0ArICX1qakNvY2vln+Qlh+xDz7POCE3r1WfZbPxUsFKIQSEfexpJSOn/ITqWb5/jYcNuFhcb2JL+CF8qh5RsPOik3n4Erj+uvjsiNvK2TbDFrbcY2T49i9xVqx5Nv07+wLaazTShC+PfoJcqRVTVVg3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711647584; c=relaxed/simple;
	bh=iZv/jvqIXDgyqTkrCBNr2iAwHfW8ttoca590b+SoGi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vx7nYodlgsFJV6Qr661vHdQE//OvctZ3KLRqECZISfTx7p9XZHYex8+KoTB3eG1JO4BlQmNYVaJQ+3U3IG2NzoBSEqB5j3ZR232mdlYgIo+hMuJWFXYBOtXZZDJyr+j740Nkngdpf5zn1mCsJypHe/b1e3Fgm9qeKegKpz140Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIDdovj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIDdovj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B0FC43390;
	Thu, 28 Mar 2024 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711647583;
	bh=iZv/jvqIXDgyqTkrCBNr2iAwHfW8ttoca590b+SoGi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tIDdovj/FTWjcixUEsAggSXblpHWdESZdPVva74QXilihiwiQ4CguylSrZIk8rkU2
	 rB+fLzRLFRU4Y+tmPg9fO8s/NHJSNwSbO0nJuivjpOTWMwG9E9Ksebw/rooh68UTNL
	 yzd2eM7kiLF1o0Tyx6xa7eD0AYs94pz7uFlQywnM5s7ZYEsWSp8h3C2NgkIn6S+Ij5
	 TDMXk/i+d1hDAj2CKgYBZyoG7obtwL2rhsoGya8VcPTdX5D3mMALRjpi42doY8VxNG
	 nmMHIjF3UmFWyfJnS2yMdQRuXT9TRvwJt9XSVexWvxCQ0/awdIg4Gy2TtlAx3ZpD7o
	 QEidXXCRSTllg==
Date: Thu, 28 Mar 2024 10:39:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: reduce indenting in xfs_attr_node_list
Message-ID: <20240328173943.GD6390@frogsfrogsfrogs>
References: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
 <171150382175.3217370.15842303765544950135.stgit@frogsfrogsfrogs>
 <ZgP_Xn6zkn0TY7nm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgP_Xn6zkn0TY7nm@infradead.org>

On Wed, Mar 27, 2024 at 04:13:34AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 06:59:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Reduce the indenting here so that we can add some things in the next
> > patch without going over the column limits.
> 
> Wouldn't you normal say 'reduce indentation' and not 'reduce indenting'?

Err... yes.  I'll fix that up. :)

> Either way the change looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
