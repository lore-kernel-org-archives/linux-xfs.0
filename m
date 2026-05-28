Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D91343888
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 05:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779945043; cv=none; b=lmj/ljclZdxBAz1l5FBTxqjKxHINKAH3vTEfIY7Y+H3zTjsXOFW0xFF0s166TIluJmf2erP8biW9Ht9+2NlKyZiZoJUvvclKQhohrsZvkvn8Q6+h5xfnB8uUUs32crw8cKjpsr7iIGOOVPoyMEus4lkRq5+buT8ptALsSjR/u/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779945043; c=relaxed/simple;
	bh=tJtBqtHkXToind6Ae+2NDX+j2cjBF9S6nFvKnP2Kjeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDIbFMIbQ+vqgWUFca+V3IFMZEL7DlTUSN2NXAwYhwLkAfEsXiaV6mlbbng40T6+uLLLQYtgaZ34kdVEEnne5MIQSWU6o46TbuTqcW5k3KZLw5pDBTKLWChdhC5o8s23VCLTqqREN3n5Q9W390DYwo2xK+MVWh2g+1VTOy9StZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mfIeXTvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mfIeXTvd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7EC0A1F000E9;
	Thu, 28 May 2026 05:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779945041;
	bh=yGs4TOYTxtzPlTfVMTKhu9UjQ6IN0BkoMlUT49yVZbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mfIeXTvd5PDWhK2FnOrYy6cfu6NRwzrDwFmKY0PtD6HC/6ncOlz2jk02SHnRaPgk1
	 ldFGUlPDi8PtMRrcd1OaoMdmz3hBHiUjfXtxoeAmL/bKJwc/QFWZknk96WAhWoDgWa
	 2vJUAQTaSdZgj6in81dtCTRDeiSibWotWj/FHD/1YK0h//O2DZbWHTpMWkpiH5ZNZ3
	 v2ppb/7wgQCBZS0xgVsyif++qhETakxjVM61btkt9+XmeEya/Va16GkKMMzPwYMhzt
	 SnGrReneJcX1+A8lgkCJmkgPaKLo/bVAlGrs+xSexDGc7hGpDcS+KoZ5NlAjdHEmW3
	 Rwi64bVvnS6gw==
Date: Wed, 27 May 2026 22:10:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/5] Add option to use default config file.
Message-ID: <20260528051040.GH6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525075752.4159504-1-lukas@herbolt.com>

On Mon, May 25, 2026 at 09:57:47AM +0200, Lukas Herbolt wrote:
> Hi,
> Sending a v2 version trying to implement the changes suggested by 
> Carlos, Darrick, Eric and Dave. The default.conf is not installed
> automatically but there is simple example file.
> 
> The order is now build-time < default-file < command line settings.
> Some values like uuid,sunit,swidth sector size and block size are not 
> allowed to be set in the default config file and if set user is warned
> about it and the value is reset to build-time default.
> 
> I moved setting of some values in cli_params and setting of mkfs_default_params
> into new bld_dft struct as If I get it correctly we were basically setting
> some of the default values on two places. It also  resulted in cleanup of
> unused parameters from some validate_* functions. 

This looks mostly good, but I have a couple of suggestions to improve
the ergonomics for distributors:

1. Make it so that mkfs.xfs itself can spit out a configuration file
based on the "bld_dft" object.  Then we can always generate the
"default.conf" file with something as simple as:

$ mkfs.xfs --write-defaults /root/my.conf
$ cat /root/my.conf
[metadata]
rmapbt=1
...

Obviously this requires some careful thought about what exactly the
printing function will actually emit -- my guess is that the only things
worth printing are filesystem features and the default fsxattr values
that get written into the rootdir, since the device geometry will
change.

2. Make xfs_db/xfs_info emit a similar configuration file based on an
existing filesystem.  Anyone needing to create many feature-for-feature
replicas of an existing filesystem will now have a much easier time than
encoding options into a shell script.

# xfs_info -c 'writecfg' /my/rad/fs > /root/rad.conf
# mkfs.xfs -c options=/root/rad.conf /dev/sda
# mkfs.xfs -c options=/root/rad.conf /dev/sdb
...

(maybe add an xfs_admin option to call xfs_{db,info} too?)

What do you think?

--D

> 
> Lukas Herbolt (5):
>   xfsprogs: mkfs.xfs Add buildtime default cli_params as global variable
>   xfsprogs: mkfs.xfs add default configuration file.
>   xfsprogs: mkfs.xfs add auto|autodetect value for -d/l/r concurrency
>   xfs_admin: add -d option to manage default mkfs config file
>   xfsprogs: mkfs.xfs clean up unused dft option in various validators
> 
>  .gitignore                           |   3 +
>  db/Makefile                          |  11 +-
>  db/{xfs_admin.sh => xfs_admin.sh.in} |  30 +++-
>  include/builddefs.in                 |   1 +
>  mkfs/Makefile                        |   2 +
>  mkfs/default.conf.example            |  10 ++
>  mkfs/xfs_mkfs.c                      | 240 +++++++++++++++++----------
>  7 files changed, 207 insertions(+), 90 deletions(-)
>  rename db/{xfs_admin.sh => xfs_admin.sh.in} (70%)
>  create mode 100644 mkfs/default.conf.example
> 
> -- 
> 2.54.0
> 
> 
