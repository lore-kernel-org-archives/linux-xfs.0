Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1392F49EE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 11:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756812276; cv=none; b=VB7rqvhHRFgm66FF97Hpj+IjBR0lNAK5UUyXhTRmxcS941q0TUUhrhpwjiMPXtfLHEMGyxoCZDoAufF4YDSvHYNmFlmFFnqh4zOaSBwEVbUZLSljiUjLxNFiP9oSwyVvtPBlU29EwCRehacyB/lVA2JELZQfMv4lsVaUracY0X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756812276; c=relaxed/simple;
	bh=I00Gk9dwXjMxqUwH7k23B8VAU+DgsSCUnq+yKO9RU9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeFAVRO+0h698X0fFFvtoCQxU84p9jMMOy8nLmIVXkR9WkbiErXicFahoe3ayjUegdSwBm17zoBdOx8ADIZQ38hDfK5OGvC9Iue8TszP6qRmpFwMn6JjqemDpwCXn2/C5WJs6zvMQb92L23YbSKiVK2W9X7sYY8bx/X2WEsdKZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGA2/sUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGA2/sUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C004CC4CEED;
	Tue,  2 Sep 2025 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756812276;
	bh=I00Gk9dwXjMxqUwH7k23B8VAU+DgsSCUnq+yKO9RU9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KGA2/sUXdE31gkm4LfHWHtZwFUx1/N+Z2B5keVHCdodBIhjxQP+Xss5NrqAgwha1R
	 C9Q1ilidhQdw4k9nZdE0O+fxjQL7NA5K09nERqybTL+Rno8zH7D7UslEiaEQ52dDka
	 eQqz52BIGWjDjdT4kT8sY+x3g1cCt3xgYOPHklM3FvFLNbYE40m5yofY+b27k66RP+
	 dynPrkw44rQw45hqosCe4MLjqT3LQQTpdWIx26a2S2T1JM7Iu/q8hvGZ5qK/ODnyhH
	 FtT3hVOg8dQrBiuCsP4roRU2/k9EYikCx8GRrc0KIYV1fpdApIdeU2vbhuSVulUNOU
	 4KgW3+lJIy39A==
Date: Tue, 2 Sep 2025 13:24:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@redhat.com, david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Improve information about logbsize valid values
Message-ID: <vxnjhoe7rmevthbnqmj3ac72o4abucywpw2bxvuqkofensye3i@cql4p3gfvqi6>
References: <20250826122320.237816-1-cem@kernel.org>
 <l2LqGJl64vEHUs0JrqOnk2wdSyaBOciUducprKtx5ODky9hRvAsbg2halj6cNnJjSjipbJJn6c5dwvyv7SvBEA==@protonmail.internalid>
 <20250826145442.GA19817@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826145442.GA19817@frogsfrogsfrogs>

On Tue, Aug 26, 2025 at 07:54:42AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 26, 2025 at 02:23:12PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Valid values for logbsize depends on whether log_sunit is set
> > on the filesystem or not and if logbsize is manually set or not.
> >
> > When manually set, logbsize must be one of the speficied values -
> > 32k to 256k inclusive in power-of-to increments. And, the specified
> > value must also be a multiple of log_sunit.
> >
> > The default configuration for v2 logs uses a relaxed restriction,
> > setting logbsize to log_sunit, independent if it is one of the valid
> > values or not - also implicitly ignoring the power of two restriction.
> >
> > Instead of changing valid possible values for logbsize, increasing the
> > testing matrix and allowing users to use some dubious configuration,
> > just update the man page to describe this difference in behavior when
> > manually setting logbsize or leave it to defaults.
> >
> > This has originally been found by an user attempting to manually set
> > logbsize to the same value picked by the default configuration just so
> > to receive an error message as result.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  man/man5/xfs.5 | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> > index f9c046d4721a..b2069d17b0fe 100644
> > --- a/man/man5/xfs.5
> > +++ b/man/man5/xfs.5
> > @@ -246,16 +246,18 @@ controls the size of each buffer and so is also relevant to
> >  this case.
> >  .TP
> >  .B logbsize=value
> > -Set the size of each in-memory log buffer.  The size may be
> > +Set the size of each in-memory log buffer. The size may be
> >  specified in bytes, or in kibibytes (KiB) with a "k" suffix.
> > +If set manually, logbsize must be one of the specified valid
> > +sizes and a multiple of the log stripe unit - configured at mkfs time.
> > +.sp
> >  Valid sizes for version 1 and version 2 logs are 16384 (value=16k)
> >  and 32768 (value=32k).  Valid sizes for version 2 logs also
> > -include 65536 (value=64k), 131072 (value=128k) and 262144 (value=256k). The
> > -logbsize must be an integer multiple of the log
> > -stripe unit configured at mkfs time.
> > +include 65536 (value=64k), 131072 (value=128k) and 262144 (value=256k).
> >  .sp
> >  The default value for version 1 logs is 32768, while the
> > -default value for version 2 logs is max(32768, log_sunit).
> > +default value for version 2 logs is max(32768, log_sunit) even if
> > +log_sunit does not match one of the valid values above.
> 
> Weird, but as a documentation stopgap until someone figures out if
> there are any bad effects of non-power-of-2 logbsizes,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

My point indeed :)


> 
> --D
> 
> >  .TP
> >  .BR logdev=device " and " rtdev=device
> >  Use an external log (metadata journal) and/or real-time device.
> > --
> > 2.51.0
> >
> >
> 
