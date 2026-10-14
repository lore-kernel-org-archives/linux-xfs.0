Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB23DB641
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003334; cv=none; b=XDHP9gL8Y0bA6yNuOMkYKf0lJQ0O7+vipIZ0kgv6g0yMoUcXJFP2INHRZV620D8eJZhZK6suv6KBqhkS+VWaaaDBsnt5jPfnZG84eTx91pvWxCxcExgpVOiPRJ71VqXXDSnfWbBeBGhiJmSivYqC5m7XdaGoLmAquyA2ncPWKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003334; c=relaxed/simple;
	bh=5yDRd7UNipt8P8jGwPErcuWFKWxXPUxObte64umTtZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7b70Zjm1R/J/LHcTUk0+SpZXdKmau5oFRGOzBgeABKwz9DRmcQok2xXqWAQcjA/t5b24J1VDHzbDM5gmrTavZpAK2l3hWuI43xSEcRUuzoLehP2OioikJVHaQNAFJA+/Du5kfvYBSW/cUzyL/n9hDd7+C+uNzS5iO2JHPMgo2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BbUZmZd2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbUZmZd2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 167911F000C4;
	Wed, 14 Oct 2026 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003333;
	bh=gfcuawTyhm05zh05wQlMg5pov3vUEFqi8wZPpD8y+lE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BbUZmZd2T2tip0d+cXPsDX0wO3ulNbSvnJJkBCq22mQE7yJcUr2Bv9PD35YvSmd7h
	 Mi8Yx3GppJG3oNb8RQEsE2O3DYGfppsS51kHyDZOvPK9/1SbOnm1OsgvtituV9KCBq
	 pjoF25ktGvh8Vdnb9GrWQgODjj+FySKEKf4RdVTBVWtNPeETe1ZEwcemMqN9u/chyM
	 BHtbx4WLbBFBwouVjfIajGt0IkAFZowdxynEM0cmuZP0bbP3OOy3Pg7POl/lPq97+H
	 KkYxtFEFfQ316inTS4IoN58EjdbZ/5P4h4Eyh5loJ3pHaAa7Qa0Zba/HYG/kSQl492
	 VpLcsXbBUGhmQ==
Date: Wed, 14 Oct 2026 11:42:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix compilation errors
Message-ID: <20261014184212.GE1615495@frogsfrogsfrogs>
References: <20261014174442.GK2705364@frogsfrogsfrogs>
 <as_IydSHaWCYgnLJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <as_IydSHaWCYgnLJ@infradead.org>

On Wed, Oct 14, 2026 at 11:24:09AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 14, 2026 at 10:44:42AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add includes to eliminate warnings from -Werror=missing-prototypes.
> > It's not a good idea to let the compiler apply the default function
> > declaration.
> 
> What do I need to do to see these warnings?  I'm getting a few warnings
> at the moment (and plan to look into them), but they are entirely
> different:

Add -Werror=missing-prototype (or -Werror) to WARNINGS in
include/builddefs.in:

WARNINGS += -Werror

Then rerun configure and make

--D

> xfs_alloc.c: In function '__xfs_free_extent':
> xfs_alloc.c:4017:41: warning: variable 'busy_flags' set but not used [-Wunused-but-set-variable=]
>  4017 |         unsigned int                    busy_flags = 0;
>       |                                         ^~~~~~~~~~
> xfs_bmap.c: In function 'xfs_bmapi_convert_one_delalloc':
> xfs_bmap.c:4360:33: warning: variable 'flags' set but not used [-Wunused-but-set-variable=]
>  4360 |         uint16_t                flags = 0;
>       |                                 ^~~~~
> xfs_log_rlimit.c: In function 'libxfs_log_get_max_trans_res':
> xfs_log_rlimit.c:162:33: warning: variable 'i' set but not used [-Wunused-but-set-variable=]
>   162 |         unsigned int            i;
>       |                                 ^
> 2345 translated messages.
> 3139 translated messages.
> prefetch.c: In function ‘do_inode_prefetch’:
> prefetch.c:1027:33: warning: variable ‘queues_started’ set but not used [-Wunused-but-set-variable=]
>  1027 |         int                     queues_started = 0;
>       |                                 ^~~~~~~~~~~~~~
> btheight.c: In function ‘construct_records_per_block’:
> btheight.c:158:11: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
>   158 |         p = strchr(tag, ':');
> 
