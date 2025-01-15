Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58E11E572F;
	Wed, 15 Jan 2025 06:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736922470; cv=none; b=CCk6MhjbYy8X8WEyppfi5ZuJUBzepTO0avOUYALHKc0Vssce+uMv9TsDykZ0DS2wbgpD/JFBG3xLiBd5q261/463HTZKov+MpcL6yAevA1EnyoYbQXU6CjsqINt1E0L0VIG7+mvCR/8tPWl65GkER0BxMMZCfEXBrfOH2Xf8M8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736922470; c=relaxed/simple;
	bh=j2R4QF6QX6Xs9gB6kFKYzfdEOjAjpD4z8qgvJ/bocl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJvCz2sS6ZDjVcTbbak6FppEFR+o1PT+uoHKuVhkFEl9Ldx0c5tYZ0ngSJlv5W3YyNTmqnyIN0Ofk6B40rGbiWo1KZXDxUah4yuCiQvxXhDbx9fbw+3kjp8W5htswnHOJUyY5nQCT3RmwWvAGJ7pMPLYSJXfFobc44G3T+InJKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0232968B05; Wed, 15 Jan 2025 07:27:43 +0100 (CET)
Date: Wed, 15 Jan 2025 07:27:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, xfs-stable <xfs-stable@lists.linux.dev>,
	stable@vger.kernel.org, david.flynn@oracle.com
Subject: Re: [PATCH] xfs: fix online repair probing when
 CONFIG_XFS_ONLINE_REPAIR=n
Message-ID: <20250115062743.GA29997@lst.de>
References: <20250114224819.GD2103004@frogsfrogsfrogs> <20250115060615.GA29387@lst.de> <20250115062037.GF3557553@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115062037.GF3557553@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 14, 2025 at 10:20:37PM -0800, Darrick J. Wong wrote:
> Good point, we could cut it off right then and there.  Though this seems
> a little gross:
> 
> 	if (xchk_could_repair(sc))
> #ifdef CONFIG_XFS_ONLINE_REPAIR
> 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> #else
> 		return -EOPNOTSUPP;
> #endif
> 	return 0;
> 
> but I don't mind.  Some day the stubs will go away, fingers crossed.

We'll I'd write it as:

	if (xchk_could_repair(sc)) {
		if (!IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR))
			return -EOPNOTSUPP;
		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
	}

but I'm fine with either version:

Reviewed-by: Christoph Hellwig <hch@lst.de>
