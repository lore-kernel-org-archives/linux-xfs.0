Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E14222611;
	Wed, 12 Mar 2025 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811440; cv=none; b=W0/hkxXg9jR/tS9M/rdEkOT2egAzIWyZo0nG2GgXTF96ebNHHmllGQSy9qDyQrI+QdgyZttLn5solrpZAeP51ZlhQG6t/DK/E6nGRkp92arcXIacT862PmDq+rH3qFRJYGg+W1c+9NwG03auyGGaQLF3jp8CT/VB0s6I3BulXR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811440; c=relaxed/simple;
	bh=j2X9Dk9He2RbsBuUSurJ/UOH1kpWQNDuVHspfuG3mNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWj+rrXrE+RIRRdnQ7I8ea/Aw91fpsi2QIMUXuvEhpFBh1phPpSWhWqnvpUBNCBfmImPQyXc2KA8fRa6HXyln1cfe26SDa/ItIC4HRHzXEYt9L8Skdzx8jfwfeUcearvUkpXvnIkWY+Y45yiSmWkihonVrATG9rF3Vk7pA7Sc4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tcJJ0i1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcJJ0i1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4849C4CEDD;
	Wed, 12 Mar 2025 20:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741811439;
	bh=j2X9Dk9He2RbsBuUSurJ/UOH1kpWQNDuVHspfuG3mNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tcJJ0i1XTUY6cvqHZwRX/nxoJwYaInMyCj3R59ygpVMfAqfdn9I40TF9j8XAQNJGu
	 MPBMVuOGb25VBoxIFjk3GpXhwLOGaGuinSv7yhteL/ZTWvafuQgp6l4VYrxJyYITaD
	 JgY5jmIHNtNLHPXYOLAGT1cTu8GmdVXe9+/5/bd+MulV2odXwulTpfzh6VRxCkYcIa
	 sM/N0ROYCX17uQ4N4120BGpnJyAVDQGC0/cvzZsrdx6pEsjUWTOA8lxv3ap1ZvAVuf
	 CNsC9o6aWcvoY6rxnoDFNl4i4nN0OMbXUZbRN+NJKAlfMhS5B0MQEfZX0KZ5pST25r
	 hO3CXuTshnw9w==
Date: Wed, 12 Mar 2025 13:30:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: initial xfstests support for zoned XFS
Message-ID: <20250312203039.GR2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-1-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:52AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds initial support for the zoned XFS code merge into
> the xfs tree to xfstests.  It does not include several newly developed
> test cases which will be sent separately.

Heh, looking forward to that.  I'll give this latest version a spin on
my qa fleet and report back...

--D
