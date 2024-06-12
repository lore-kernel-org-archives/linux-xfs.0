Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71777CF1F
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218741; cv=none; b=ttFkf3c2NXSMPWlEoOCRjz6Svo4gMkF4YF6/fzrzfM0e04VJVcfRySl9LUaTibL7rFoH6cDvcI8THtxPGksa5lPZS3wffVlCPOpcflv6Ddypalq90Z53w2JGEqAp9Z0PP4MqiEuINLTHvUVoDYT0BMxqj+aXya2hYs/yrTtTL5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218741; c=relaxed/simple;
	bh=mRoQSAVaSZ9sHHTExDSPwmFN1TRAYYBXn4JXyoRY4SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AdoNLmQB6psDblvi58tXqL3y8+g+8xA+cMpUwk4rrSqYaAPeZqA0Ynw+JvVYP7pN2zkJ3+pXEOkH3/yCC4t7BBbfaNdriImGwUIpWtvjEgKi+1mXcgbfKhzII2xij1vbSrLZQfA4G62Tukf3oqQfIrONOTeTY/aoQFJj3Cq5Vpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=PPIBPGcX; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="PPIBPGcX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LplHvfG9HNsHMEtDNlvXJoL7Jqz87srzLyap4rjRzcs=; b=PPIBPGcXYEFI27zabO91uuZFs+
	YtN8QBXNhFUxnorf00iqPGPNtA2RfSoOqNnTIjWiGorYf/KpvUapuvfQyqFr8D78rmQM5C4sQ/GQ9
	VIU/JFhJkFddbO/05BtXsAqIj4EVlHROVDdFlZzzoS+gEWi/PG98ji7u1ChRop6dXVrfJ3t5SnVUW
	51+71dzfj+BzO/0JS51l/8YBxSronTzDbZ+7coJpLsi/tolkWyVLZI63OoEFdTCnr0Zeh87xqZzZu
	vC2Y7JEj7Csu0kAlCrsz6ddO8M5BFKXYK5PYtLRc6UB9gyTOm+3/OpZM3Yyielbl2nyZYK1dqTkEO
	Ofoez5BQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <zeha@debian.org>)
	id 1sHTBQ-0083TL-V2; Wed, 12 Jun 2024 18:58:57 +0000
Date: Wed, 12 Jun 2024 20:58:55 +0200
From: Chris Hofstaedtler <zeha@debian.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] Install files into UsrMerged layout
Message-ID: <yoidu77dijghmk6tgpioz3diswsj53f6m5qjqd5quyruox7oop@o7gb7o6nl6ij>
References: <20240612173551.6510-1-bage@debian.org>
 <20240612173551.6510-2-bage@debian.org>
 <20240612180843.GE2764752@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240612180843.GE2764752@frogsfrogsfrogs>
X-Debian-User: zeha

* Darrick J. Wong <djwong@kernel.org> [240612 20:08]:
> On Wed, Jun 12, 2024 at 07:35:05PM +0200, Bastian Germann wrote:
> > From: Chris Hofstaedtler <zeha@debian.org>
> > 
> > Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
> > Signed-off-by: Bastian Germann <bage@debian.org>
> > ---
> >  configure.ac                | 19 ++-----------------
> >  debian/local/initramfs.hook |  2 +-
> >  2 files changed, 3 insertions(+), 18 deletions(-)
> > 
> > diff --git a/configure.ac b/configure.ac
> > index da30fc5c..a532d90d 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -113,23 +113,8 @@ esac
> >  #
> >  test -n "$multiarch" && enable_lib64=no
> >  
> > -#
> > -# Some important tools should be installed into the root partitions.
> > -#
> > -# Check whether exec_prefix=/usr: and install them to /sbin in that
> > -# case.  If the user chooses a different prefix assume they just want
> > -# a local install for testing and not a system install.
> > -#
> > -case $exec_prefix:$prefix in
> > -NONE:NONE | NONE:/usr | /usr:*)
> > -  root_sbindir='/sbin'
> > -  root_libdir="/${base_libdir}"
> > -  ;;
> > -*)
> > -  root_sbindir="${sbindir}"
> > -  root_libdir="${libdir}"
> > -  ;;
> > -esac
> > +root_sbindir="${sbindir}"
> > +root_libdir="${libdir}"
> 
> Should we get rid of $root_sbindir, $root_libdir, PKG_ROOT_LIB_DIR, and
> PKG_ROOT_SBIN_DIR while we're at it?

Will do.

> That will break anyone who hasn't
> done the /usr merge yet, but how many distros still want
> /sbin/xfs_repair?  opensuse and the rhel variants seem to have moved
> that to /usr/sbin/ years ago.

I think nobody supports split-/usr nowadays?

Chris

