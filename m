Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5CB2941B
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715265621; cv=none; b=g6XCYlZPepKwoLNW0zuLkPtsJo3+1vEfh6OS2aou0bWA1eJ3sIXdPswZKmFa0DvSrMTqGAa+Gpde38acOFI/9OBZ6GccSghp4jfv0amP747AGkOZA94f0RK2JkKvS4LzzAhYkwUtRCQbBilgNfSzE6R8IvikPMu8U72yrO5IVO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715265621; c=relaxed/simple;
	bh=FwvYltcWZoxEu9oG1+npZIjIsJHdjC4cfSGQXYgQZko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCkyTKj1cCMcnH3xfbE4dU1fknKJzGH9aghIjOXEn7eZ9Qfs/CsLJC4WmxsUdjuv+dvmXYgid6eGAf5m13t1L3glDyYKGyI6yq81l52aW22Xx/SY6wOBGkfhQ9hYemThP22LWRTvxCq/21my7w8ixH8ZNDys3GnBjDeVT465yn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pAVnF42S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAVnF42S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C385C116B1;
	Thu,  9 May 2024 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715265621;
	bh=FwvYltcWZoxEu9oG1+npZIjIsJHdjC4cfSGQXYgQZko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pAVnF42SS226LIOcj1P6DSH/S053gjxy2LgHGTY6wMEc/wsAqWqplZb29EPYsi1Wq
	 tIcv8AqmnAN5/4CXjHhK6kj4kryx5+EPodbpqqM7lC7aUvtSxCOoZYsd1sfFDuPla5
	 yxW1FTjsfpL7ZfDZdSXqs3Z4FKwnODLYKjWyTuS6e28yLwgDpy41ZCe1QPcvQ6GXzh
	 8y4FZ/aOfEuDb8V4yQjO2knD9r30oFuFl3EJq60uyTtofpRyjZ/87RAHd4XByxnPoo
	 WzNrgoL6HPPmkbH2h1K2kx27cXjs+69XQsxn3QCnMtxHAKkjasdrBUt2PhqwEF1vrC
	 O4efYCHMTS/Yw==
Date: Thu, 9 May 2024 07:40:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Philip Hands <phil@hands.com>, Carlos Maiolino <cem@kernel.org>
Cc: Debian Bug Tracking System <owner@bugs.debian.org>,
	linux-xfs@vger.kernel.org
Subject: Re: Processed: your mail
Message-ID: <20240509144020.GH360919@frogsfrogsfrogs>
References: <87jzk3qngi.fsf@hands.com>
 <handler.s.C.17152516831244576.transcript@bugs.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <handler.s.C.17152516831244576.transcript@bugs.debian.org>

On Thu, May 09, 2024 at 10:51:03AM +0000, Debian Bug Tracking System wrote:
> Processing commands for control@bugs.debian.org:
> 
> > tags 1070795 + d-i
> Bug #1070795 [xfsprogs-udeb] xfsprogs-udeb: the udeb is empty (size 904 bytes) so does not contain mkfs.xfs

Yeah, someone needs to apply the patches in

https://lore.kernel.org/linux-xfs/171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs/

and

https://lore.kernel.org/linux-xfs/171338841109.1852814.13493721733893449217.stgit@frogsfrogsfrogs/

which were not picked up for 6.7.  Unless the upstream maintainer
(Carlos) goes ahead with a 6.7.1?

--D

> Added tag(s) d-i.
> > thanks
> Stopping processing here.
> 
> Please contact me if you need assistance.
> -- 
> 1070795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1070795
> Debian Bug Tracking System
> Contact owner@bugs.debian.org with problems
> 
