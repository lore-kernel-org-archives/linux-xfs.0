Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC47A423165
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778771131; cv=none; b=oREMfH71tPdogwsXVjfE2yFDMfghcXCchD4jXM86vmmpPxrOHZgZX/VWJJ4jOrOWzVL3QYQwOykJbFmXXe1ZZ53G6kfGArUWp71oMm6l3XnEfXfWJPWcTWWAdi/kOY1pfRAuzFxRlYtXPidzsiilwrQJ0woomAUphyggJPfw4JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778771131; c=relaxed/simple;
	bh=H83bzG1mvFawgCwngtSFuLPzBBaIqJCINZzO+vtngdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyTmSf+yuobTDOART7zeAGFurVdR0EyLgyK+d48CxmLFV3c7KVh6VgiQj9FCKo2nZoBJm2dSDmUjcczodSiT3KqBJKoCxuZo5vT0fnSYTsyi44oKFHZxEiaTF2pv6Y3kmUzfHziRF3bCr1EAUcRM77vQVDfL0S4RbbTzs7LALuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oc6qMX20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oc6qMX20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33062C2BCB3;
	Thu, 14 May 2026 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778771131;
	bh=H83bzG1mvFawgCwngtSFuLPzBBaIqJCINZzO+vtngdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oc6qMX20sAOgtPpB4QE4WPGFW2hRfoqQRMErGmoOaQ+eJGxrtF3ZcM4oo+JSHR2Fp
	 pBXdpIfMEvi4F9VZ/h3+qW66BJy3jynhtAuuvnFCkbHULMxXFgwuti4wBvOp2lFwiH
	 GZpr+MpXbkYtVPdiSc1wtlMtSbtMD4+eFADeVsuUd1L47L9RsjfnbaPb3Yy5RDhEeE
	 ijiRPnEIIv0kZ/fhnCcHuUSczyQ10ctSqbYRLQ9sktwzmoIBlr939SUw1x7K23XnK5
	 zx3Z5HSkeeHqCihqDwLGha30Hecd2BrYKweGtbHNzQsTHslzSU+ogFxPd/2e3HUAVy
	 PtC99F9s4LErg==
Date: Thu, 14 May 2026 08:05:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 0/1] Add default config file for mkfs.xfs
Message-ID: <20260514150530.GV9555@frogsfrogsfrogs>
References: <20260514143716.893814-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514143716.893814-2-lukas@herbolt.com>

[add ted to cc]

On Thu, May 14, 2026 at 04:37:16PM +0200, Lukas Herbolt wrote:
> Hi all,
> The default values cannot always satisfy everybody and users/packagers
> should be able to override defaults without the need of specifying
> configuration file on command line. It was previously discussed in
> here [1]. 

Hmm.  A long time ago Ted asked for a slghtly different alteration to
help him make running fstests easier.  What he wanted iirc was a way to
install a set of default mkfs settings from a config file, but still
allow the settings to be overridden by cli arguments.

Apparently I never sent the patch because it doesn't exist in lore, so I
suppose I should send it now. ;)

> The proposed patch adds /etc/mkfs.xfs.conf where the default values
> can be set.  It also lightly changes the default behavior for -l/-d/-r
> concurrency allowing now to be set to -1 to keep autodetection on
> SSDs.

I don't think I like magic negative numbers, but I'll save that for my
reply to the actual patch.

--D

> https://lore.kernel.org/linux-xfs/84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net/
> 
> Lukas Herbolt (1):
>   xfsprogs: mkfs.xfs add default configuration file.
> 
>  include/builddefs.in |  1 +
>  mkfs/Makefile        |  3 ++
>  mkfs/mkfs.xfs.conf   | 50 ++++++++++++++++++++++++++++++
>  mkfs/xfs_mkfs.c      | 72 +++++++++++++++++++++++++++++++++++++++-----
>  4 files changed, 119 insertions(+), 7 deletions(-)
>  create mode 100644 mkfs/mkfs.xfs.conf
> 
> -- 
> 2.54.0
> 
> 
