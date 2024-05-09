Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B7D15AF1
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715265762; cv=none; b=t3h+BYfBjKPTNDqVfMdBbbwkHOq6FeEdKqaUU/v12bBp1eHzdHzpnncjV0cCH9Ruew41AJfiJcEBdQ0g6pt0zRsFVN0lRdlHsOgDU3SLhwtbHeOwNBzTBfr8OhXw+J0w8B1enr+Xb2CRoc2RBFMU3VFG9tob09VqTk+nq6EVxcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715265762; c=relaxed/simple;
	bh=ThYBpHwjukrYClsTJKJy1PtHLsPvckt9pxwkDB5l62Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlCe4O8fa0I/HbnGa+B8wpjSHRyW5vmJ+T9ONG4ZpX0ScSRNRk9NXZPscVmNeVI0EdaDO667ZLKE5M4jFV2N0ovAltnymK77nQ62t5xu17H16pdCMaCi+J5skF+GCaKYangV/dDVjWxhxTcq/huM/SDzlK8Px2BM8Rkh6tX903c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srrMNzJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srrMNzJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18001C116B1;
	Thu,  9 May 2024 14:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715265762;
	bh=ThYBpHwjukrYClsTJKJy1PtHLsPvckt9pxwkDB5l62Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srrMNzJvy31nro6ROg0P9gQQ8vmMyX4Ofx7pRzdrEFg0cQ8Pjh63G+MbAwqyROh7z
	 OPiyJKmWkoRVLh9ZHr8et2Fey0oN6Whq1kG3JwGknYapdgvACywLNCJPz1YLns6kMP
	 HEOYql4611Infmbfd6HXkGXpc29Cvf8SmaILL1MwYOrDSWEZtrr8kbgccZcUWTrh89
	 qWw8q6FPSj8BiBC2hSMy1OK/xpLLt97h2oa9ypThTVAyaZ3OtQ8ecOFX7IpqEc57J2
	 hafFf3XJOprc09HHUyRm26Gncmb/HpOlV6LGAxw7rTQNTS9KzUwR2nuKcB0E//1SWE
	 USzc0MIhFmEIw==
Date: Thu, 9 May 2024 07:42:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Philip Hands <phil@hands.com>, Carlos Maiolino <cem@kernel.org>,
	1070795@bugs.debian.org
Cc: Debian Bug Tracking System <owner@bugs.debian.org>,
	linux-xfs@vger.kernel.org
Subject: Re: Processed: your mail
Message-ID: <20240509144241.GI360919@frogsfrogsfrogs>
References: <87jzk3qngi.fsf@hands.com>
 <handler.s.C.17152516831244576.transcript@bugs.debian.org>
 <20240509144020.GH360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509144020.GH360919@frogsfrogsfrogs>

[actually cc the bugreport this time]

On Thu, May 09, 2024 at 07:40:20AM -0700, Darrick J. Wong wrote:
> On Thu, May 09, 2024 at 10:51:03AM +0000, Debian Bug Tracking System wrote:
> > Processing commands for control@bugs.debian.org:
> > 
> > > tags 1070795 + d-i
> > Bug #1070795 [xfsprogs-udeb] xfsprogs-udeb: the udeb is empty (size 904 bytes) so does not contain mkfs.xfs
> 
> Yeah, someone needs to apply the patches in
> 
> https://lore.kernel.org/linux-xfs/171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs/
> 
> and
> 
> https://lore.kernel.org/linux-xfs/171338841109.1852814.13493721733893449217.stgit@frogsfrogsfrogs/
> 
> which were not picked up for 6.7.  Unless the upstream maintainer
> (Carlos) goes ahead with a 6.7.1?
> 
> --D
> 
> > Added tag(s) d-i.
> > > thanks
> > Stopping processing here.
> > 
> > Please contact me if you need assistance.
> > -- 
> > 1070795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1070795
> > Debian Bug Tracking System
> > Contact owner@bugs.debian.org with problems
> > 
> 
