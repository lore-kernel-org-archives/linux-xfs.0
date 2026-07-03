Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF4270EC3
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 15:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093748; cv=none; b=UDVi1apneCipXp21xrkgp3m+96ut72LMOGHqBfFTY0hci1EobW/uAo1mvr+fHeXGiQbZCskwG5/8McRg03n3oUixdfBB3QAfnEkQXTbJpuFO4HUsnwMT0W+eOFpXsFCtc0KzXRCNEiGz3wRWOKFd2t+YsvJ+Kovx0nv2/1FkZD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093748; c=relaxed/simple;
	bh=L468gknzVyQdcjizZjPHjx7VtJoudtJ0tQYXE/twAPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9c0qcL/IlR15dDbMX6bCNpm5fbOzpgvesywSBzeUnqPGUrWMbFeQO0cV+D39kBz/PQbW2t/86ymDhCPMuwxy4xkI4J/+Vnfw8MWlcAMBLoDxjhAbRHhTYTIqR2jp+H+Brazu7a8O8jPjfI7QLmBU4j3rruBWEEd2GCEg0SAkbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2sPtehp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2sPtehp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3EDC71F000E9;
	Fri,  3 Jul 2026 15:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783093747;
	bh=c6vEOBwQ2TWf+J2100PskIbBtyR2Owzww8Z1e7vyUUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X2sPtehpnSB0n1wpqj/QjwKLJcBYhLN1cU6p82oDCi+FS/Nx5kYnEUjpMuQt0v9AL
	 vzMZ+8tDxn9NLuRCuK3Wujcae0ElcoV9oe6RK3v8z8NQuYWb1sFDLCgNzYXZLTmZYK
	 ybVpxRI3l9SO4O/lskv/PnSyjrcPdFTzPZ+jCrrobCxhLzW8yABJAy/fuDQCjPU6Di
	 YF+JW0rD/XdQu1cPOci0OPbUZ2Zakhm+U1bzju2ZCetrZKAstJQWMVbe1CtgDMj94p
	 E8rR6iVA2EOSlqPDVnFmNkEXb0C/JcfKVAB4AlapYMYxxb2JvDrporksM2ZgsaNZoG
	 Z/U6KvfSADW0A==
Date: Fri, 3 Jul 2026 08:49:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Celeste <celeste@collar.sh>, Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on long
 dirent names
Message-ID: <20260703154906.GU9392@frogsfrogsfrogs>
References: <20260625222337.54449-1-celeste@collar.sh>
 <20260625225758.GN6078@frogsfrogsfrogs>
 <178243370553.73182.935356806206037088@collar.sh>
 <aj4z3v6RGnSbxlEI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <DJOCNHYIYK0G.17Q5FWMGKKXMC@collar.sh>
 <akezHvFoqtKWN0f4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akezHvFoqtKWN0f4@infradead.org>

On Fri, Jul 03, 2026 at 06:03:26AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 02, 2026 at 12:58:14PM -0700, Celeste wrote:
> > should we then assume that this is fine to merge?
> 
> I still don't think that just papering over the misuse of the same type
> for on-disk and in-memory uses with different characteristics is a good
> idea.

I agree.

--D
