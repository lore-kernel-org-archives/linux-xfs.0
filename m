Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796F01C3F01;
	Tue,  1 Oct 2024 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727795384; cv=none; b=D1D63dWU48vGfb7PhiMvccsAl2WFDPewoX1mUl6Y+0g21n8B5T+Hb69tPHjIg+VnRIbzaDdFWrj4RJzxPEaJOSchNZwZtGTEeoHZwZHjcdBTPPUwO5dJsIxKyROOonpAbMtz5tWyeuMXJIklwbZ/85cAFw2k8RX1FRdA+Cnp/oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727795384; c=relaxed/simple;
	bh=m8oEA0YQsQETQ4XPSf2EFJEqWqsWS16c+3kHgjJbb34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ub4maetzFKBIB8Cfu0RLdtYcgv0Ux4z+lBF4a/cb8wbfE0e1oGrrrT0nY0IklNIABH1mpYdBYH6viAZobrJFX8U2XEeiSHpKItEzaFRdAyBrj8Xa6TEhlEQF963MsS2W33+kHc3R4aXye/5nVoNVr9nPcti0sS+sTjK/GtfYUbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCLG2UdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCLG2UdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63B7C4CEC6;
	Tue,  1 Oct 2024 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727795384;
	bh=m8oEA0YQsQETQ4XPSf2EFJEqWqsWS16c+3kHgjJbb34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WCLG2UdTiRC6a/WMstvEevPk5Q2y9GEuQpdhw1d2nVHIUDdb4obgosF1PPofq0XGW
	 aeaDHD4rvTIsqIA2H3vL8vDpbPPumScR20rVuKWxAsbBCnLSPcHsHp0ghvIvr/bwmn
	 XYJByZsdJB24H3b0uAfzH3PMPLFm63pLt1QeMjVk7UO8mTMT4VmPEhJQyS+pg7FhUs
	 sYkVy8nR12jqEcu918R8nSIZXB1Tp1mm56ywWQ8m68X4jmrW6rCGQYJZZw/qQuid26
	 upPkG+eCALMW/JDkEKlyrfT/MShedUcja55xwYsaW3P044KQ3T6VQ5qp6gLngxrHX+
	 aHyhmo6WyFm0w==
Date: Tue, 1 Oct 2024 17:09:39 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	Linux Memory Management List <linux-mm@kvack.org>, Josef Bacik <josef@toxicpanda.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, ying.huang@intel.com, 
	feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [linux-next:master] [xfs]  3062a738d7:
 filebench.sum_operations/s -85.0% regression
Message-ID: <20241001-lausbub-skilift-10d22cfbf03c@brauner>
References: <202409292200.d8132f52-oliver.sang@intel.com>
 <3ae3693f35018e73cc6f629cb88c0a5e305e3137.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3ae3693f35018e73cc6f629cb88c0a5e305e3137.camel@kernel.org>

On Mon, Sep 30, 2024 at 02:21:30PM GMT, Jeff Layton wrote:
> This is a known problem.
> 
> I have a fix that moves the floor handing into the timekeeper, but
> Thomas said he had a better way to do this, so I haven't resent them
> yet.
> 
> The patches in Christian's tree are out of date, so it may be best to
> just drop them for now until I have the newer set ready.

Yeah, I only kept including them while the merge window wasn't closed so
not to cause unnecessary churn pre merge window (Since we only got the
performance regression report at -rc7...).
