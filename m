Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A902D33DEE5
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770714304; cv=none; b=O7qh6dHUBd6EyEJImin+rP6hrODBNwDlXNQDYI7NsWmpu850tjnWtoRT1pzpTkM63PkPBzIsmlRc1diIVzdSizPEKHrr6jbPbcFsdLCSMKCvo83QzJ0D0/e2Uy1eRczSOzQ/C2eoIS0bA0DOsKO91K3kQIII1TrBXk/WJO8Pncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770714304; c=relaxed/simple;
	bh=dudylzGJ2GIT80rVh+lbP2S8qTUicX8NDGCBrBS+2ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1Oc7gAoh9hq1tMlQHro4OMYN92NEvsK7GmbHf/I/jqWkg8zKRLxVRGY2XDdFwSTzGcMoVNYOx5vy8ptAeIjjhXQJicBjoJevc/ZHpK6fWRwM+WW0HRCO3djOQ/43R2jKslKRs/KYa+rFjddHU5rJP6QpCBTQiBndoQwXQOZsGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpOKO2B2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpOKO2B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63434C116C6;
	Tue, 10 Feb 2026 09:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770714304;
	bh=dudylzGJ2GIT80rVh+lbP2S8qTUicX8NDGCBrBS+2ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NpOKO2B2JWU6N8PvnVfgosuZbQea+h50KndNlxHsVtqgmtHV7d2sU3OGXi/BpUVS3
	 2ao5Vm/i9guJ9KPChGoxwqHN5LzGoYhRQ56M/bgA3XuGrqmXYGMBRzBEF9mCC4KbIf
	 XRYIzSexuVJgd7vlZobFnEQm8aQ0nh/4z9dLUTseA56vKYhM6sCVxN0IIfg+2cc+bW
	 ns7eq28GAO3zW4LHMDCXPOmMSeVluMH50RiWGjgIMsHTaTznMlfKiShDf5Yk4vI+02
	 kQ2CT/6DiTGQf2LPHOHS8MAcA1/YVdtT16BERLSy3NROwBtbfdjEVfpJhg3AWGdt0X
	 c1s4Uol92+xuQ==
Date: Tue, 10 Feb 2026 10:05:00 +0100
From: Carlos Maiolino <cem@kernel.org>
To: techlord8@web.de
Cc: linux-xfs@vger.kernel.org
Subject: Re: What prevents XFS from being grown offline (without being
 mounted)?
Message-ID: <aYr0L94oV0oXE3uo@nidhogg.toxiclabs.cc>
References: <trinity-fb1b39de-006e-4acc-8ab4-22a203b12391-1770653643533@trinity-msg-rest-webde-webde-live-54b976884-dmz76>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-fb1b39de-006e-4acc-8ab4-22a203b12391-1770653643533@trinity-msg-rest-webde-webde-live-54b976884-dmz76>

On Mon, Feb 09, 2026 at 04:14:03PM +0000, techlord8@web.de wrote:
> It seems this has never been asked before, at least I wasn't able to find anything about it on the wiki (xfs.org) and the mail archives, nor on web search.
> 
> While the wiki has a detailed article about what complicates shrinking support  ( https://xfs.org/index.php/Shrinking_Support ), I was hoping to find something like this about offline growing but couldn't.
> 
> From the manual: "The filesystem must be mounted to be grown".
> 
> Common sense tells me offline growing should be simpler given that there is no interference from data being read and written at the same time. So why can XFS not be grown offline?
> 

Without digging into 30 years of history... XFS has been designed to run
on high-end hardware where downtime was virtually unacceptable, so, no
need to spend engineering hours writing a feature that is not required.
Also, this would mostly require the growfs code to be duplicated between
the kernel and xfsprogs, adding maintenance burden and unnecessary
complexity.

Those are my assumptions though, but I didn't dig into any design
documents to come up with them, so take it with a grain of salt.
