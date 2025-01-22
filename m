Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DF8196
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 01:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737510352; cv=none; b=W/k7q07v9HHY14sMqTsxKNEJVqjXkXYmyw8MMQlIp7yctz/ZsLxGx2VWuvOfqitUj1vGEoNhymfJoPPBc4C/SvikEnByw3lShgQb/QN/8Q8X6E1vY6tEtsMQgnOEEIxONixDRsM/P2ppeLpds65iTisAaTDTApUaEdltp4izNWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737510352; c=relaxed/simple;
	bh=j58uK+oBry1D0EXcAoxXdpKkmLkDinma375vgEdL/9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZ5kUUglTY9+WAaYJnLv2Yj9ttnrJ2sysWkFHF1x5vq7MB8qYR8Jyw1V4VJ0iEK+Or0btKUn3QNZNCpNO5v236iJXFpZk5xJmDE7/qta99i1nA7sbFD0cxpPCDtOe3nBP2b38WRTRTP9dJyE8UKWALELDjj+pJedI1V7ODeTzbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQNZtXEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQNZtXEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ED0C4CEE1;
	Wed, 22 Jan 2025 01:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737510351;
	bh=j58uK+oBry1D0EXcAoxXdpKkmLkDinma375vgEdL/9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nQNZtXEtiic21Y8BgqnPW+4A6rl9E/wcb3i4tPYfC6vOry188YImn4AYJQ5TS8Plb
	 L7xtlN5ObzSvPe0Du1fes4XjhtqkiZEn0Zxn0fGCNemK3BWAjDa0t+zhEnFEdIMAC3
	 bHyXdUxZdPCFRfuXGQteWHUXF6uqWLgqKu0r8qWWmhxoNAc0I9RO7+CinBOuVZIPK4
	 tUs4SwQ7vV931TfSCU4XqAkE085Y8pf/Itk3ONvt2rs5Q3BZgNTqOIV1JBb7idmzTn
	 RRQ8Lu5+0rDh4ia2FcoUhn/U0klosS9PFwhgvgHC/91BMfEF/vvLG+68sZO30tWWae
	 wuw70+KC+r9NA==
Date: Tue, 21 Jan 2025 17:45:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 3/4] release.sh: update version files make commit optional
Message-ID: <20250122014550.GK1611770@frogsfrogsfrogs>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-3-61e40b8ffbac@kernel.org>
 <20250116223318.GE1611770@frogsfrogsfrogs>
 <7y44gkonyin7lptiwq4g7ladfdf7eqv7n7chlfmz3pmilkki34@vcman5v2yckh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7y44gkonyin7lptiwq4g7ladfdf7eqv7n7chlfmz3pmilkki34@vcman5v2yckh>

On Mon, Jan 20, 2025 at 12:53:05PM +0100, Andrey Albershteyn wrote:
> On 2025-01-16 14:33:18, Darrick J. Wong wrote:
> > On Fri, Jan 10, 2025 at 12:05:08PM +0100, Andrey Albershteyn wrote:
> > > Based on ./VERSION script updates all other files. For
> > > ./doc/changelog script asks maintainer to fill it manually as not
> > > all changes goes into changelog.
> > > 
> > > --no-commit|-n flag is handy when something got into the version commit
> > > and need to be changed manually. Then ./release.sh -c will use fixed
> > > history
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> > >  release.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
> > >  1 file changed, 59 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/release.sh b/release.sh
> > > index a23adc47efa5163b4e0082050c266481e4051bfb..c34efcbcdfcaf50a08853e65542e8f16214cfb4e 100755
> > > --- a/release.sh
> > > +++ b/release.sh
> > > @@ -11,16 +11,33 @@
> > >  
> > >  set -e
> > >  
> > > -. ./VERSION
> > > -
> > > -version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> > > -date=`date +"%-d %B %Y"`
> > > -
> > >  KUP=0
> > > +COMMIT=1
> > >  
> > >  help() {
> > >  	echo "$(basename) - create xfsprogs release"
> > >  	printf "\t[--kup|-k] upload final tarball with KUP\n"
> > > +	printf "\t[--no-commit|-n] don't create release commit\n"
> > > +}
> > > +
> > > +update_version() {
> > > +	echo "Updating version files"
> > > +	# doc/CHANGES
> > > +	header="xfsprogs-${version} ($(date +'%d %b %Y'))"
> > > +	sed -i "1s/^/$header\n\t<TODO list user affecting changes>\n\n/" doc/CHANGES
> > > +	$EDITOR doc/CHANGES
> > > +
> > > +	# ./configure.ac
> > > +	CONF_AC="AC_INIT([xfsprogs],[${version}],[linux-xfs@vger.kernel.org])"
> > > +	sed -i "s/^AC_INIT.*/$CONF_AC/" ./configure.ac
> > > +
> > > +	# ./debian/changelog
> > > +	sed -i "1s/^/\n/" ./debian/changelog
> > > +	sed -i "1s/^/ -- Nathan Scott <nathans@debian.org>  `date -R`\n/" ./debian/changelog
> > > +	sed -i "1s/^/\n/" ./debian/changelog
> > > +	sed -i "1s/^/  * New upstream release\n/" ./debian/changelog
> > > +	sed -i "1s/^/\n/" ./debian/changelog
> > > +	sed -i "1s/^/xfsprogs (${version}-1) unstable; urgency=low\n/" ./debian/changelog
> > >  }
> > >  
> > >  while [ $# -gt 0 ]; do
> > > @@ -28,6 +45,9 @@ while [ $# -gt 0 ]; do
> > >  		--kup|-k)
> > >  			KUP=1
> > >  			;;
> > > +		--no-commit|-n)
> > > +			COMMIT=0
> > > +			;;
> > >  		--help|-h)
> > >  			help
> > >  			exit 0
> > > @@ -40,6 +60,36 @@ while [ $# -gt 0 ]; do
> > >  	shift
> > >  done
> > >  
> > > +if [ -z "$EDITOR" ]; then
> > > +	EDITOR=$(command -v vi)
> > > +fi
> > 
> > I wonder if it would be sensible to try nano as well?  Probably most
> > systems have a vi of some kind, or a nano of some kind, but they
> > probably don't lack both.
> 
> I added this only to make line below '$EDITOR ./VERSION' spit out
> some more meaningful error. Probably this would be even better to
> just change 'command -v vi' to 'vi'.
> 
> > 
> > > +
> > > +if [ $COMMIT -eq 1 ]; then
> > > +	if git diff --exit-code ./VERSION > /dev/null; then
> > > +		$EDITOR ./VERSION
> > > +	fi
> > > +fi
> > 
> > Er... what does this do?  If something has changed VERSION, then we pop
> > it open in an editor before sourcing it?
> 
> ops, right, that's should be if edit if not modified.
> 
> *without --no-commit* Starting from clean repo -> open ./VERSION to
> let maintaner update version -> update version in all other places
> -> commit
> 
> > 
> > Also, do you want to update debian/changelog at the same time?  Normally
> > Debian maintainers use dch(1) to create the changelog entry, but it's
> > basically this:
> > 
> > rm -f /tmp/whatever
> > debdate="$(date '+%a, %d %b %Y %T %z')"
> > cat > /tmp/whatever << ENDL
> > xfsprogs ($version) unstable; urgency=low
> > 
> >   * New upstream release
> > 
> >  -- Nathan Scott <nathans@debian.org>  $debdate
> > 
> > ENDL
> > cat debian/changelog >> /tmp/whatever
> > cat /tmp/whatever > debian/changelog
> > rm -f /tmp/whatever
> > 
> > (I can also send a patch atop your series to do that, if you'd rather I
> > go mess with the debian stuff)
> 
> I do, above in update_version()

Oops, I didn't recognize that it was backwards changelog.

--D

> > 
> > > +
> > > +. ./VERSION
> > > +
> > > +version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> > > +date=`date +"%-d %B %Y"`
> > > +
> > > +if [ $COMMIT -eq 1 ]; then
> > > +	update_version
> > > +
> > > +	git diff --color=always | less -r
> > > +	[[ "$(read -e -p 'All good? [Y/n]> '; echo $REPLY)" == [Nn]* ]] && exit 0
> > > +
> > > +	echo "Commiting new version update to git"
> > > +	git commit --all --signoff --message="xfsprogs: Release v${version}
> > > +
> > > +Update all the necessary files for a v${version} release."
> > > +
> > > +	echo "Tagging git repository"
> > > +	git tag --annotate --sign --message="Release v${version}" v${version}
> > > +fi
> > > +
> > >  echo "Cleaning up"
> > >  make realclean
> > >  rm -rf "xfsprogs-${version}.tar" \
> > > @@ -47,17 +97,6 @@ rm -rf "xfsprogs-${version}.tar" \
> > >  	"xfsprogs-${version}.tar.asc" \
> > >  	"xfsprogs-${version}.tar.sign"
> > >  
> > > -echo "Updating CHANGES"
> > > -sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
> > > -	mv doc/CHANGES.tmp doc/CHANGES
> > > -
> > > -echo "Commiting CHANGES update to git"
> > > -git commit --all --signoff --message="xfsprogs: Release v${version}
> > > -
> > > -Update all the necessary files for a v${version} release."
> > > -
> > > -echo "Tagging git repository"
> > > -git tag --annotate --sign --message="Release v${version}" v${version}
> > >  
> > >  echo "Making source tarball"
> > >  make dist
> > > @@ -83,4 +122,7 @@ if [ $KUP -eq 1 ]; then
> > >  		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
> > >  fi;
> > >  
> > > -echo "Done. Please remember to push out tags using \"git push origin v${version}\""
> > > +echo ""
> > > +echo "Done. Please remember to push out tags and the branch."
> > > +printf "\tgit push origin v${version}\n"
> > > +printf "\tgit push origin master\n"
> > 
> > I think you can do that all in one push, e.g.
> > 
> > git push origin v6.13.0 master
> 
> Yup, seems to work, will change it
> 
> -- 
> - Andrey
> 
> 
