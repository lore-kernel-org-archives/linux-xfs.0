Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80F11684AE;
	Tue, 10 Sep 2024 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725968067; cv=none; b=Vn5lZkda7W0e2O0pnK5f2Du8/gfwDhCVZoU6eh4IWyO55gFXD3vilNg5XE67xYwi21sVErYrioBK7XZIDqljKY8s7QF26FFr0KWQu8rRMTCQaaATGmSuJ0lgXcXCfAdtNTpbrp+rw0TONqbxpcEc33gqjyyQralVn9uhobKjwXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725968067; c=relaxed/simple;
	bh=4L9ZICwUQ4X5BA1zmSIU+Ry8cIkasTyXNEzgZAOfRS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXLUjRiokTsw1g2AWRvDZjXVUjOZAU/GG8ZoxGAdKq7T14neaBG0B5IRivoWWLkQ7Rx4b8lTJ9rvq6MPqCgwzKLiG0xPFVgXdqxOKal4qM66cfF8cMC08Yc2BzOAka7GfiQuafP+5OF1KffleXJbRRkWmhFPe0EsSWGakLJnDGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 83022227AA8; Tue, 10 Sep 2024 13:34:20 +0200 (CEST)
Date: Tue, 10 Sep 2024 13:34:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <20240910113420.GA7326@lst.de>
References: <20240910043127.3480554-1-hch@lst.de> <20240910085748.jcea37l665dxluge@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910085748.jcea37l665dxluge@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 10, 2024 at 04:57:48PM +0800, Zorro Lang wrote:
> On Tue, Sep 10, 2024 at 07:31:17AM +0300, Christoph Hellwig wrote:
> > Reproduce a bug where log recovery fails when an unfinised extent free
> > intent is in the same log as the growfs transaction that added the AG.
> 
> Which bug? If it's a regression test, can we have a _fixed_by_kernel_commit
> to mark the known issue?

I just sent the kernel patches for it.  It's been there basically
forever as far as I can tell.

