Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBD136CDF3
	for <linux-xfs@vger.kernel.org>; Wed, 20 Aug 2025 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755703553; cv=none; b=pagPNxb/OpQiFwKuuJlJcGxlAenLVfoLIlXBKFbANz6oXzug+D+Wh2EKWE0/cpUrT1kQVdNvheIfDiO2l0PQJFC93X69yZ+zl6CGEJE/qmrwRJO5UiKveg87zlH/Q5PYv9oa5rBOxb9AzF1AHHC//bN/3l+6iL/TBubrxnw3ZTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755703553; c=relaxed/simple;
	bh=R9alDJNi3S9evUljS+b07Jjju41HZO2HOVzmSL6mx5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcSucwQuApYBOYB4ZZupi2jGh0pDtQSCPmoHJlx/7wh/bSze+l3+j7Iedppm79GLCVWrwwYa7cU2RNj4vmTcdEn6TwI/ArGQpcmyakE02WPVZHn4E1E1xgBoSoIfJe+FFdC8HsTtMybbhMxBqKXJbmxHUpoIL1dQmtzK8WhduRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzkTlGwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzkTlGwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CDCC4CEE7;
	Wed, 20 Aug 2025 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755703553;
	bh=R9alDJNi3S9evUljS+b07Jjju41HZO2HOVzmSL6mx5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UzkTlGwyzlkwC4yNWr7U1lp1j2pckDPXd3UNal1sbSkTRuK2EkQfufC6RpWvIc7Sc
	 2tSr0alu+4qkeL5e8A1lF7ENJHwt+3olNrAcI7pSRs1frqLdhetbpROtKl8/6jTYFf
	 R1RbokIeDg8sDEsjGxieY0c7ROoZyha408Lk45fqMDS+8UzeDmwc6eTHOJLFYDx4Ki
	 b6gb9sOyUO9GxZ+fsM8dJQw/UwSvvc4bzbRLoHZOoCL/B5Uc1L7jZ/CkFYJJr7mzwz
	 iKxOEj6LzDkEJh1oTacqIexfZvjvYBJB5iiCMrxA96/YZIgtSNjDPgj8ivOiM/xMRH
	 aHpxmgPR3ebvw==
Date: Wed, 20 Aug 2025 08:25:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Zorro Lang <zlang@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Yearly maintainership rotation?
Message-ID: <20250820152552.GD7965@frogsfrogsfrogs>
References: <Pd4KqICHYbjm5ZYOHBmgSRgs-uKNopGdeI4ARGEXr12t8ZnKctQMdfVRNceZbMeFFKncvIv9_fKyKoMCmCiLfg==@protonmail.internalid>
 <20250819225400.GB7965@frogsfrogsfrogs>
 <7svscwa3oy5oxavscjgapcvr7lbumsntu32fq7uhmrfqr6pino@7awm4hxzzqzb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7svscwa3oy5oxavscjgapcvr7lbumsntu32fq7uhmrfqr6pino@7awm4hxzzqzb>

On Wed, Aug 20, 2025 at 10:07:02AM +0200, Carlos Maiolino wrote:
> On Tue, Aug 19, 2025 at 03:54:00PM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > Now that it's nearly September again, what do you all think about
> > rotating release managers?  Chandan has told me that he'd be willing to
> > step into maintaining upstream xfsprogs; what do the rest of you think
> > about that?
> > 
> > Also, does anyone want to tackle fstests? :D
> 
> Considering you were specific about xfxsprogs and fstests, I believe
> you excluded kernel on purpose, but anyway, from my side I'm pretty ok
> with how things are now, and I'd rather keep it as-is, specially because
> I'm enjoying the role :-)

I specifically mentioned xfsprogs because Chandan volunteered, and
fstests because Zorro has been maintaining that for a very long time.

It's fine if everyone wants to keep going as they are now, but positive
re-affirmation once a year feels (to a longtime maintainer like me,
anyway) like a face-saving way to give people an offramp if they decide
to take it.  IOWs, I think it best to help the maintainers avoid
burnout.

> Of course I'm talking about my side and my workload only, I don't speak
> for Andrey or Zorro.

<nod> No rush, you all have plenty of time to give things a good
thinking through. :)

--D

> Carlos
> 
> > 
> > --D
> > 
> 
