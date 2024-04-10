Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F79176FC2;
	Wed, 10 Apr 2024 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712765031; cv=none; b=ngC+KJDWvfIrK0XTKa8rkhFNK7Tynu0raP+zwu0HBYkP/cAElhQsFeETKAPpwmT6ICi3JVkpjL9qrONN92fE7FZ8tAgSIuE4SlpcnEvObFPGf847p6CPmWigOkO029RuEzn5b4IbhWtQfTefuYb4RlOgeaSAjLaftoK4gCbXafo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712765031; c=relaxed/simple;
	bh=x7AxBoTeLTuIt0nJjClDuJPUxvBPyp3m9tYp6jcyxnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQ0122tk9JvJvwkWVJcIaDICt7WcSEecHdyYtKI5iGCZGa09TNZY/iR2yeFn/bdUYmV4zVXmSxHHRqio/xbCnd4neroWdGxInulXQ52Kcby/XzMNLOI08qOGbSNN1PB3YbP1F3fmOUZ+Snax8Ncv+M8/VZIV2ztoNV6CZijQIQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA5fcA4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA5fcA4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B859C433F1;
	Wed, 10 Apr 2024 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712765031;
	bh=x7AxBoTeLTuIt0nJjClDuJPUxvBPyp3m9tYp6jcyxnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NA5fcA4kpDRAo8pg5g6xe1JntgusROU2VJyPSPQB/Jhh3p54IjgthVGUE5/JEZERU
	 4z1INCRKN/OScQ3+VsnlbobxR6WzEmcu9+H79ufOHSr89Rwjc/G7p7zZNq/FeOlfxv
	 cdabs1OMvy57z80w09QLNKO6vf4bgh/eTWZfxSePEHbe0YBC2ryNr+Zi4dvl4VEh4f
	 hKWDMYNWRW9qXZgdXBjVcF41cnDjWPipmiT5oTlZ8e3wIY1C0eiNFK6H5JlZ90M1gU
	 mVCRm8DNCM1/jqmCR59PgTM5QNklaIyKBPGUwt+yhfDl2OXCxoNiAccA0yb/Rt1x8+
	 BXHpJ81KnMO/g==
Date: Wed, 10 Apr 2024 09:03:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240410160350.GW6390@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240408145939.GA26949@lst.de>
 <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240410144254.iiqrxlm64xc6mqa6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240410145140.GA8219@lst.de>
 <20240410151600.GV6390@frogsfrogsfrogs>
 <20240410151800.GA10081@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410151800.GA10081@lst.de>

On Wed, Apr 10, 2024 at 05:18:00PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 08:16:00AM -0700, Darrick J. Wong wrote:
> > I second that.  I'll deal with xfs/158, 160, and 526, but the other
> > patches that were ok could go in.
> 
> Should I resend with the other review comments fixed but the
> _require_xfs_nocrc left in those for now?

Yes.  You could even do:

_require_xfs_nocrc	# FIXME: djwong said he'd fix this for real

If you like. ;)

--D
