Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4BA1E0DE6
	for <linux-xfs@vger.kernel.org>; Fri, 28 Mar 2025 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743197972; cv=none; b=m2q12QWibExMxHR8zukWlP8DWFhEvhZNUnnku1GVXnbzI4Gp/luibWRCCB1OHG65psPpfWj7Lhf2bkjJ/Jw9kcZogggml20DLo+5gWv+4ex8CrNZomRsQuUliN9s7V/sSkhXTuYIDud6Jc+/rMpkGIwmzmQ0913yD3J6eGw+i9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743197972; c=relaxed/simple;
	bh=kdsMFxKuvAmUm9YVA85Bwsyg+hSKxNSpBG+h6IszkIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgJ6xBv/ktC3AToTGXXHlObcCnrcefXLBWpGlCSoHuSTWmI202i2hfLAU1ER9fl14mV/9VJK7ixh6NKq3AQ9aq73G1DZNR6bEUs5QLecbLxSUep3YGhQHkxZOMCxIqYR8vdMiLH+g4BHh8MHkuaFVAGownT6LPVPdpYHCd2UFY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-82-222.bstnma.fios.verizon.net [173.48.82.222])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 52SLdAq1024110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Mar 2025 17:39:10 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1F04E2E010B; Fri, 28 Mar 2025 17:39:10 -0400 (EDT)
Date: Fri, 28 Mar 2025 17:39:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [XFSPROGS PATCH] make: remove the .extradep file in libxfs on
 "make clean"
Message-ID: <20250328213910.GA1235671@mit.edu>
References: <Ma-ZKGYU7hIk8eKMYW8jlYh_Z0idBm-GTBibhJ9T1AQdH_B6PFLlAEEOXoTUJ85eBFU_fC2m0pdM3xOdcrf4mg==@protonmail.internalid>
 <20250219160500.2129135-1-tytso@mit.edu>
 <rqpluafkqedqjl3acljv3nugq3gjxpldmglon72a3j3up6cvn3@inq2q6xj5rtb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rqpluafkqedqjl3acljv3nugq3gjxpldmglon72a3j3up6cvn3@inq2q6xj5rtb>

On Thu, Feb 20, 2025 at 09:12:46AM +0100, Carlos Maiolino wrote:
> On Wed, Feb 19, 2025 at 11:05:00AM -0500, Theodore Ts'o wrote:
> > Commit 6e1d3517d108 ("libxfs: test compiling public headers with a C++
> > compiler") will create the .extradep file.  This can cause future
> > builds to fail if the header files in $(DESTDIR) no longer exist.
> > 
> > Fix this by removing .extradep (along with files like .ltdep) on a
> > "make clean".
> > 
> > Fixes: 6e1d3517d108 ("libxfs: test compiling public headers with a C++ compiler")
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> Looks good.
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks like this hasn't yet landed in the xfsprogs repo?  Is there
anything that I need to do?

Thanks,

					- Ted
