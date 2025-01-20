Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AA32770C
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737373993; cv=none; b=pbjfPbPodtEdhK/pRlh1V3JP4YJfX1IB2d9LdHPXN3xvQqDV426pV10EANyt6u5zomlQrqUDyZb9yUw4UK6v1dX7EnWd6I9WaF0yQKv3nOTK0ALOZeYP/5mweTTH5Fwi13jLm/77u6JiChdTYVHf7sqAO1+ySMXwYv0XB8pgOek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737373993; c=relaxed/simple;
	bh=7ekFlDYBun/oOBOIIBryhwY8EOcZ4NCTXRy2c2isRLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2+8HL+fAGdoOGEqDLz3a+1syM3ucBhPxki7Isfpk7g1ls2GeFLmnQjnPEvTabMZqxu2kZDPVK/QYtJ0oegGonSQ/6mDXqe6p2QfdBqxPC5KY9tyiz21VWrUXEvbWUJFc+TA8jo+HvecBZqaNm4euusKJFT+Q8Dmh3xMQU8ITmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N3FrVeMi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3FrVeMi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737373989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8F5UEKubb8KadPx43dOsgQqjqilsEzXfSoHQoUf7B0U=;
	b=N3FrVeMiSGWdV20ERnA/rii0p8Ow57hEi6bEKIVOKDu+X4L8alcOuQZCLssNBQ8sYC51Wf
	qFF254NW8XcJBj6IYyffumsQwrVkPOe79KJRW071gUls5xfBKEfCdFm2lz5lgdl7zSFmMI
	0C0wG614tKDEibieg/5ITPmFNUr/Tz4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-dsHg-JKhNOyxkeHxMj8s2Q-1; Mon, 20 Jan 2025 06:53:08 -0500
X-MC-Unique: dsHg-JKhNOyxkeHxMj8s2Q-1
X-Mimecast-MFC-AGG-ID: dsHg-JKhNOyxkeHxMj8s2Q
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-436219070b4so21074435e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 03:53:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737373987; x=1737978787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8F5UEKubb8KadPx43dOsgQqjqilsEzXfSoHQoUf7B0U=;
        b=px4cPyJu92lfDOzdX6J5Z6WS9RMTZm+/sif2nxb2wlCvtUciI+IVVs12WGVve8DS3e
         M9KgJx8mXRMOsg8PuKWdG/Z8PbRnUOcUDoIvOV8KpWTEt+kG6ZVRXSeKmVIWuRXIZHLC
         o/iW7PttVgqs/8eE8AU8ykrqJR3oM0s/k+pcnAQ3aM117WwInM20qWj1xGdyv8GF7Onr
         hJWjwYJ5e6GsN2LEZJObrrPcMHE0NpGzQ9lNo1ZAPF7hn+ajYtr1DPLSlA9wwfERhHIV
         vBmEOM1zK7BS1BJHBdffajeQtHzXE405rm2QGCSRZ71zKlW5JjcGfQAwMKsbu67OWw2G
         /b+g==
X-Gm-Message-State: AOJu0YyahYXfiJ3TWsAZ+HEwQCFj2nCqGMAL2PG9xkvBa4qXQ+oI+/f+
	bkHyjfJDCcdFV/c0wH0nL73Hyfx2geWEyFVN+t9vUpvVzkpNbWMgWbSxEt94CmQoDFJ4y5qpIYA
	XyuQkIcSjMj06nmhe2d3HlkgTwhgAaIoWxESAWRQpmpOjiQ7m1Y9RtskQ
X-Gm-Gg: ASbGnctYJgXMshGg4f8WeZrdzISjczWA+8smlOb/lAzF3ZNbY1tyap04FXKy+JPyei/
	Vhfry6ImCafxuWUlyRpZ32Bde2PhRz7Y9EJGfEoJgLmtyh0m0F64lxT3ydjCIp0ZSAeD8Cl2PoY
	UvhpCeJve/Cn0QWYU9nDEFBEmg3oxr60Jn4LjgVWsPxApT1RYjEuwy4CV3GgGPimkz8/tT3aHf2
	0xNDYdbKpMTD5x8jt5RJg/tTtG3LL/vnoGdFPC0kPzG6p+kH3L1OBj1fNycZNPbnZtaZ6oXXgJj
	yhyNT1aKeBvIdQ==
X-Received: by 2002:a05:600c:1908:b0:434:9c1b:b36a with SMTP id 5b1f17b1804b1-438913dbf63mr113469655e9.13.1737373986743;
        Mon, 20 Jan 2025 03:53:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRXO6kCuwuV41jZ2Yltvq0rzf9bs+Y1UobBHZ8QwNGQ2ugLchUtYQ7ZooQY6YA2FY8mn5VGQ==
X-Received: by 2002:a05:600c:1908:b0:434:9c1b:b36a with SMTP id 5b1f17b1804b1-438913dbf63mr113469425e9.13.1737373986263;
        Mon, 20 Jan 2025 03:53:06 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c752935csm193911745e9.26.2025.01.20.03.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 03:53:05 -0800 (PST)
Date: Mon, 20 Jan 2025 12:53:05 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 3/4] release.sh: update version files make commit optional
Message-ID: <7y44gkonyin7lptiwq4g7ladfdf7eqv7n7chlfmz3pmilkki34@vcman5v2yckh>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-3-61e40b8ffbac@kernel.org>
 <20250116223318.GE1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116223318.GE1611770@frogsfrogsfrogs>

On 2025-01-16 14:33:18, Darrick J. Wong wrote:
> On Fri, Jan 10, 2025 at 12:05:08PM +0100, Andrey Albershteyn wrote:
> > Based on ./VERSION script updates all other files. For
> > ./doc/changelog script asks maintainer to fill it manually as not
> > all changes goes into changelog.
> > 
> > --no-commit|-n flag is handy when something got into the version commit
> > and need to be changed manually. Then ./release.sh -c will use fixed
> > history
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  release.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 59 insertions(+), 17 deletions(-)
> > 
> > diff --git a/release.sh b/release.sh
> > index a23adc47efa5163b4e0082050c266481e4051bfb..c34efcbcdfcaf50a08853e65542e8f16214cfb4e 100755
> > --- a/release.sh
> > +++ b/release.sh
> > @@ -11,16 +11,33 @@
> >  
> >  set -e
> >  
> > -. ./VERSION
> > -
> > -version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> > -date=`date +"%-d %B %Y"`
> > -
> >  KUP=0
> > +COMMIT=1
> >  
> >  help() {
> >  	echo "$(basename) - create xfsprogs release"
> >  	printf "\t[--kup|-k] upload final tarball with KUP\n"
> > +	printf "\t[--no-commit|-n] don't create release commit\n"
> > +}
> > +
> > +update_version() {
> > +	echo "Updating version files"
> > +	# doc/CHANGES
> > +	header="xfsprogs-${version} ($(date +'%d %b %Y'))"
> > +	sed -i "1s/^/$header\n\t<TODO list user affecting changes>\n\n/" doc/CHANGES
> > +	$EDITOR doc/CHANGES
> > +
> > +	# ./configure.ac
> > +	CONF_AC="AC_INIT([xfsprogs],[${version}],[linux-xfs@vger.kernel.org])"
> > +	sed -i "s/^AC_INIT.*/$CONF_AC/" ./configure.ac
> > +
> > +	# ./debian/changelog
> > +	sed -i "1s/^/\n/" ./debian/changelog
> > +	sed -i "1s/^/ -- Nathan Scott <nathans@debian.org>  `date -R`\n/" ./debian/changelog
> > +	sed -i "1s/^/\n/" ./debian/changelog
> > +	sed -i "1s/^/  * New upstream release\n/" ./debian/changelog
> > +	sed -i "1s/^/\n/" ./debian/changelog
> > +	sed -i "1s/^/xfsprogs (${version}-1) unstable; urgency=low\n/" ./debian/changelog
> >  }
> >  
> >  while [ $# -gt 0 ]; do
> > @@ -28,6 +45,9 @@ while [ $# -gt 0 ]; do
> >  		--kup|-k)
> >  			KUP=1
> >  			;;
> > +		--no-commit|-n)
> > +			COMMIT=0
> > +			;;
> >  		--help|-h)
> >  			help
> >  			exit 0
> > @@ -40,6 +60,36 @@ while [ $# -gt 0 ]; do
> >  	shift
> >  done
> >  
> > +if [ -z "$EDITOR" ]; then
> > +	EDITOR=$(command -v vi)
> > +fi
> 
> I wonder if it would be sensible to try nano as well?  Probably most
> systems have a vi of some kind, or a nano of some kind, but they
> probably don't lack both.

I added this only to make line below '$EDITOR ./VERSION' spit out
some more meaningful error. Probably this would be even better to
just change 'command -v vi' to 'vi'.

> 
> > +
> > +if [ $COMMIT -eq 1 ]; then
> > +	if git diff --exit-code ./VERSION > /dev/null; then
> > +		$EDITOR ./VERSION
> > +	fi
> > +fi
> 
> Er... what does this do?  If something has changed VERSION, then we pop
> it open in an editor before sourcing it?

ops, right, that's should be if edit if not modified.

*without --no-commit* Starting from clean repo -> open ./VERSION to
let maintaner update version -> update version in all other places
-> commit

> 
> Also, do you want to update debian/changelog at the same time?  Normally
> Debian maintainers use dch(1) to create the changelog entry, but it's
> basically this:
> 
> rm -f /tmp/whatever
> debdate="$(date '+%a, %d %b %Y %T %z')"
> cat > /tmp/whatever << ENDL
> xfsprogs ($version) unstable; urgency=low
> 
>   * New upstream release
> 
>  -- Nathan Scott <nathans@debian.org>  $debdate
> 
> ENDL
> cat debian/changelog >> /tmp/whatever
> cat /tmp/whatever > debian/changelog
> rm -f /tmp/whatever
> 
> (I can also send a patch atop your series to do that, if you'd rather I
> go mess with the debian stuff)

I do, above in update_version()

> 
> > +
> > +. ./VERSION
> > +
> > +version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> > +date=`date +"%-d %B %Y"`
> > +
> > +if [ $COMMIT -eq 1 ]; then
> > +	update_version
> > +
> > +	git diff --color=always | less -r
> > +	[[ "$(read -e -p 'All good? [Y/n]> '; echo $REPLY)" == [Nn]* ]] && exit 0
> > +
> > +	echo "Commiting new version update to git"
> > +	git commit --all --signoff --message="xfsprogs: Release v${version}
> > +
> > +Update all the necessary files for a v${version} release."
> > +
> > +	echo "Tagging git repository"
> > +	git tag --annotate --sign --message="Release v${version}" v${version}
> > +fi
> > +
> >  echo "Cleaning up"
> >  make realclean
> >  rm -rf "xfsprogs-${version}.tar" \
> > @@ -47,17 +97,6 @@ rm -rf "xfsprogs-${version}.tar" \
> >  	"xfsprogs-${version}.tar.asc" \
> >  	"xfsprogs-${version}.tar.sign"
> >  
> > -echo "Updating CHANGES"
> > -sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
> > -	mv doc/CHANGES.tmp doc/CHANGES
> > -
> > -echo "Commiting CHANGES update to git"
> > -git commit --all --signoff --message="xfsprogs: Release v${version}
> > -
> > -Update all the necessary files for a v${version} release."
> > -
> > -echo "Tagging git repository"
> > -git tag --annotate --sign --message="Release v${version}" v${version}
> >  
> >  echo "Making source tarball"
> >  make dist
> > @@ -83,4 +122,7 @@ if [ $KUP -eq 1 ]; then
> >  		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
> >  fi;
> >  
> > -echo "Done. Please remember to push out tags using \"git push origin v${version}\""
> > +echo ""
> > +echo "Done. Please remember to push out tags and the branch."
> > +printf "\tgit push origin v${version}\n"
> > +printf "\tgit push origin master\n"
> 
> I think you can do that all in one push, e.g.
> 
> git push origin v6.13.0 master

Yup, seems to work, will change it

-- 
- Andrey

