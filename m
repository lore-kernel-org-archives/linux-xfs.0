Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B291D12E5
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 05:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724303083; cv=none; b=rgUYeG7HxPJ9LYFSPv8Dh11DFHBKMBLgdXNF8BIbq5aYMaPqC8bjbv6dPGIagnD8iFJlQC20AFsRlGYLNTukDI51H5lUOITOBroflHAasT8NosaLO7BFlRyZV2DF0X1o8eOkdnOMV7LjdnvECQhJ/tOXzLgCcRHm/HyjMso9zKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724303083; c=relaxed/simple;
	bh=l9W04bwgPi/jtBPqiJIyfGaJAp7jonbDRZjAt9dyE48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=auxIb/oxzmgVklXpCgKBMZRuNXNPI8a4v2GoMk1fR/5RkYV2sRu3kqmNplUlXwmi2xm+xA9VxOJ6G9iNEMI8/cdH2VmmzNDlK70HBIEci6C+Q9vXMBi5NNPnIcevlJ95qp3gEVW8Vg4bu9Z+5ipgA/y809ROmAMahd/ePxculJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1sqmK+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1sqmK+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04A8C4AF09;
	Thu, 22 Aug 2024 05:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724303082;
	bh=l9W04bwgPi/jtBPqiJIyfGaJAp7jonbDRZjAt9dyE48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F1sqmK+/xzaPCGhUmDlcINjMkiThUV/AbsDuaGSdTOi03zBWW0F+wGOTnEA02pc8K
	 VYxy0c3C+FQVRlINSDmoGzsPmNRlAmiCoiMtAFOW13q+emFfgykP3Obo42KLWnEE1c
	 fCB25LxzWgmQbi4Q4DWJFJ5VLCUcYMn4IeEni7V2YRVMYZPyRq0BYjD0epj73c4mW0
	 IYIGu5laKTDgFOf06PydDMv8SKUFEuyuHZyDw+qo+8H2CU+mglxtjQ+TpAj21NXzeV
	 B92YKptP+vTovgNYSSEIiJawFs4Fj5oXXRvcc//3LxDPEm+92lTlvKDxdv/fbUXuwj
	 yMQv9C2/dlj+Q==
Date: Wed, 21 Aug 2024 22:04:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, kjell.m.randa@gmail.com,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix di_onlink checking for V1/V2 inodes
Message-ID: <20240822050442.GO865349@frogsfrogsfrogs>
References: <20240812224009.GD6051@frogsfrogsfrogs>
 <ZrrzUw55-UQZ649j@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrrzUw55-UQZ649j@infradead.org>

On Mon, Aug 12, 2024 at 10:46:59PM -0700, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Hey Chandan, I just realized this didn't get merged yet, even though
there's a user complaint about this.  Can we get this staged for 6.11,
please?

--D
