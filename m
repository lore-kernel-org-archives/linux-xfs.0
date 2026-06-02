Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361F22DB78C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376156; cv=none; b=jkJxGMxmwPzuCTWlosEux9CqbmP4ssEm/dmCfnmmnm6tYfCeg6WyngUi3Ak1APn9zgpP8E8lsDdJyGJcovGmpvvKl94RowEoHNQkLewr+Utbz1XeXYXxG/TRO++DULgi15GDKco24qtNetlHqhwLC+2RUwkHZtqNeqBsVY5IAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376156; c=relaxed/simple;
	bh=TKoNraH1mEcjvuAUmEmH2VfcinOxIForthm8R+rlkT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b2eU/css909Drr7BLKOBb+meMeGBBBMEJXgyLSEfl73UhupgHuUb/I8v77aIze1mmz0AQOW4e57sWra1WKXKEGFjW4aBAgsQWHT3I2wXY2LiohVN91SPpq1TzyaXSyR7L61EOuCnwgt6zx5r8M4NMzSG4TWY0jo6x5yaa0R0IAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Avru2d1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Avru2d1Z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CDF311F00893;
	Tue,  2 Jun 2026 04:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376154;
	bh=Q7ckMZn6Z0U9K+L2b0AqxlvtOQO9MM55Ol9kknEHEm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Avru2d1ZFy4/TYK4zUON64y9ASSCk+xdafAo0kBSvhi1oQOCtvQk7ToO83vGHufWK
	 d/6iDRpdvvIPuFZiV7+zUrjhfHUazke3qgtNOeRT957nJcxHdfyPIJTIGuEgdzuMwG
	 55zDqU/Sh4kNXru+sQmH/vkIfHW0h+DyTfXVH8ShBQaRNqE25R3LdXxjaEo2Kkeq4D
	 SXmR0a/Dq2q4Xg+lTn8z5NZTsX+REz4Ex2B17UHXnyaTC7aqgQtL8AKgm+PqwI3x3e
	 mej/6QrRuw0PD1fjRKaRM1osVrQLvGhdVovT81P2pNcQ/wrR2Mp5el8XVZ0KkZ0wNC
	 DsvGpvlxrf+zw==
Date: Mon, 1 Jun 2026 21:55:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/5] Add option to use default config file.
Message-ID: <20260602045554.GT6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260528051040.GH6078@frogsfrogsfrogs>
 <58a188ce948dc7b02da9175ba97e8297@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58a188ce948dc7b02da9175ba97e8297@herbolt.com>

On Fri, May 29, 2026 at 08:01:55PM +0200, Lukas Herbolt wrote:
> On 2026-05-28 07:10, Darrick J. Wong wrote:
> > On Mon, May 25, 2026 at 09:57:47AM +0200, Lukas Herbolt wrote:
> > > Hi,
> > > Sending a v2 version trying to implement the changes suggested by
> > > Carlos, Darrick, Eric and Dave. The default.conf is not installed
> > > automatically but there is simple example file.
> > > 
> > > The order is now build-time < default-file < command line settings.
> > > Some values like uuid,sunit,swidth sector size and block size are not
> > > allowed to be set in the default config file and if set user is warned
> > > about it and the value is reset to build-time default.
> > > 
> > > I moved setting of some values in cli_params and setting of
> > > mkfs_default_params
> > > into new bld_dft struct as If I get it correctly we were basically
> > > setting
> > > some of the default values on two places. It also  resulted in
> > > cleanup of
> > > unused parameters from some validate_* functions.
> > 
> > This looks mostly good, but I have a couple of suggestions to improve
> > the ergonomics for distributors:
> > 
> > 1. Make it so that mkfs.xfs itself can spit out a configuration file
> > based on the "bld_dft" object.  Then we can always generate the
> > "default.conf" file with something as simple as:
> > 
> > $ mkfs.xfs --write-defaults /root/my.conf
> > $ cat /root/my.conf
> > [metadata]
> > rmapbt=1
> > ...
> > 
> > Obviously this requires some careful thought about what exactly the
> > printing function will actually emit -- my guess is that the only things
> > worth printing are filesystem features and the default fsxattr values
> > that get written into the rootdir, since the device geometry will
> > change.
> 
> Make sense, but I would then remove the example file, also this comes to the
> fact while some (HW geometry) stuff are ignored in the default file. I would
> not allow user to set sector size sunit/swidth from the default file. The
> question
> is should we just exit with some info and calling usage() or set it to
> default
> and warn about it?

AFAICT, the config file parser currently allows you to provide fs
geometry options (e.g. sunit) in the config file.  I think we should
continue adding /any/ option that came from a config file, because if
that makes for an invalid geometry then mkfs will just complain about it
and error out.

But I wouldn't have a program that generates a config file capture
geometry information, at least not without a special switch (e.g.
--capture-exact-config).

> > 2. Make xfs_db/xfs_info emit a similar configuration file based on an
> > existing filesystem.  Anyone needing to create many feature-for-feature
> > replicas of an existing filesystem will now have a much easier time than
> > encoding options into a shell script.
> > 
> > # xfs_info -c 'writecfg' /my/rad/fs > /root/rad.conf
> > # mkfs.xfs -c options=/root/rad.conf /dev/sda
> > # mkfs.xfs -c options=/root/rad.conf /dev/sdb
> > ...
> > 
> > (maybe add an xfs_admin option to call xfs_{db,info} too?)
> > 
> > What do you think?
> > 
> 
> I guess xfs_{db,info} option which would be used in xfs_admin makes sense.
> But again here comes a question should we emit exact copy or leave HW
> geometry aside?

I'd only write out user-visible filesystem features since (at least in
our experience at $employer) customers usually require either specific
features or compatibility with an older kernel.

If someone really wants hw geometry then we can add that later. ;)

--D
