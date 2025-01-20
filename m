Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68A01DFD87
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737375265; cv=none; b=Y9UJ1Rx1S78BgmcTUgeqpGaa0olz3zWzLKofMjrUIRkYyfpFr4UMIoiqrfHsKdmb0ux2pPLpjmq+LcczyWxYjLzpGJDIgHcZyfRazjKQp/EYSjT4ZgxZOcszF17Gf/6d1LLCcGuXchNkL9QMS4I3KwskRUpLJPzOo8MaLVPc5m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737375265; c=relaxed/simple;
	bh=Zm821hzcw8ZA9uce6328QuGl87n/SsXydIvbMQJR9MU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fjqf4W5AOCuHU9m02yWE6tE5jzfCqosfTqUubRJ5aM+P5nJXKkK4HZ4KXoTAlDuwCEgnKhWzzfAPbG31aXlFmhdvqgd5UDVFghz+n6Xi+1m36k1T2Dsd7rJ54LEQy2H6jTU15DYmOmhxWSRo9qyl++on99k8Fz9V3lYqQPeDH4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPim2bCC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPim2bCC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737375262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OV7ARG2vtvQq5lurITZDHSbzQnyXqzTz6m/tKlcVDgs=;
	b=SPim2bCCs4nNHf8Ym2IpjO7Kq0AknWm03wXH1P3JF9j7JRU+JQPluHUY3G0uo+uiUPNB5V
	K7pHba957w1E3CcVPDet9NnfuVhy45WDPipCXfj9pCtETIk723gi/zM/JTYFfkveBCR/cl
	jE5Jfs2CNmJWqpT+Ajdn3hE5oQp8YIk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-9yFoxpNSNrubzjEK0a6C4Q-1; Mon, 20 Jan 2025 07:14:21 -0500
X-MC-Unique: 9yFoxpNSNrubzjEK0a6C4Q-1
X-Mimecast-MFC-AGG-ID: 9yFoxpNSNrubzjEK0a6C4Q
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-436248d1240so21279175e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 04:14:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737375260; x=1737980060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OV7ARG2vtvQq5lurITZDHSbzQnyXqzTz6m/tKlcVDgs=;
        b=C7VahbsBQeWSzEQINP++avW+4JERFzoJgnMjOs3/PLUk1HIT2O2WHHOq/a7GHMYCgW
         UJaEp3FP96XYzbrdugstkfvN4bai/KT8TYHrGWe57EH5iG0brJ5wiYmEqWPyb2plgrUp
         l8A0LEkFMFtI5rAja0/q+Spt69nqGizJowrREEDvBT+602razu1puYZ5+2D5mE2y+qii
         b1X/gQx1YngQ9H831OiIIZOyhnAOwcSB0pTJnMmFFKq4y7Z94Jq3nP6AGBkoy98A0D3I
         HBKBrT1eG0PqE5M7s5b70ta8xQG5lLA+73ZhwzQU7SiEexHQEgpuLm/kJNRseB2Tny6U
         u2Xw==
X-Gm-Message-State: AOJu0YzHVOLn/Idiz3pQjEiT+4Ghw42uGM/PImX9CwFMgplkINReZ8qP
	bc0mLioDguO7ULAYrYZeNDPKZDltqqyXktqsV1ZTt9dOLL0P0V7NqNTn+lVnJwlz/WG+K1z5C7r
	+Ovh6RsARrNVEFuw0l050wogqAFmOSFbU4ljV7inMHiB/wvcXEYb4ORGF
X-Gm-Gg: ASbGncvg9Muhat6ESDFIBrTq4XIwUcVNg94udpV8TDiBqt33/CY81yGBRL1qAWnvbTa
	GCedjtagsBY3ZMEH/BLBU9E0mfzWVto4AdFy1H0NvP2XKrQUzQUTkacBysv+mpwlasqOvlg1tht
	7YGL7IdGFlPTk+VkLxbINconed2HRmQZAcpMkeWoAYilqNtRR2m5RcBW8XrKCVxXVuJtCHjRZHi
	5pxS7obIaaIIkkn8effvRK9dQ0XTfx22EiF0NM5u2R+MoKmKO2uOoY8fTIWcjxmZF7m/5yZVm3f
	d+vHZYSTikRObA==
X-Received: by 2002:a05:600c:4e08:b0:434:a4a6:51f8 with SMTP id 5b1f17b1804b1-438912d4a3bmr130794625e9.0.1737375259871;
        Mon, 20 Jan 2025 04:14:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkuvkHyyq5sVRa3jPSQRoETaqSl3WsFGHe/doVf7jvOT1U+uMxJ8QcyRjbR7j+r0wdf7RVEw==
X-Received: by 2002:a05:600c:4e08:b0:434:a4a6:51f8 with SMTP id 5b1f17b1804b1-438912d4a3bmr130794335e9.0.1737375259432;
        Mon, 20 Jan 2025 04:14:19 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3275755sm10118736f8f.80.2025.01.20.04.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 04:14:19 -0800 (PST)
Date: Mon, 20 Jan 2025 13:14:18 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 4/4] release.sh: generate ANNOUNCE email
Message-ID: <xmsug3nmcya5exv3uq6osooysh7qjjoqh7zz6duqbyxgh5uh75@p4brhy2gdomx>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-4-61e40b8ffbac@kernel.org>
 <20250116224148.GF1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116224148.GF1611770@frogsfrogsfrogs>

On 2025-01-16 14:41:48, Darrick J. Wong wrote:
> On Fri, Jan 10, 2025 at 12:05:09PM +0100, Andrey Albershteyn wrote:
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  release.sh | 46 +++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 45 insertions(+), 1 deletion(-)
> > 
> > diff --git a/release.sh b/release.sh
> > index c34efcbcdfcaf50a08853e65542e8f16214cfb4e..40ecfaff66c3e9f8d794e7543750bd9579b7c6c9 100755
> > --- a/release.sh
> > +++ b/release.sh
> > @@ -13,11 +13,13 @@ set -e
> >  
> >  KUP=0
> >  COMMIT=1
> > +LAST_HEAD=""
> >  
> >  help() {
> >  	echo "$(basename) - create xfsprogs release"
> >  	printf "\t[--kup|-k] upload final tarball with KUP\n"
> >  	printf "\t[--no-commit|-n] don't create release commit\n"
> > +	printf "\t[--last-head|-h] commit of the last release\n"
> >  }
> >  
> >  update_version() {
> > @@ -48,6 +50,10 @@ while [ $# -gt 0 ]; do
> >  		--no-commit|-n)
> >  			COMMIT=0
> >  			;;
> > +		--last-head|-h)
> > +			LAST_HEAD=$2
> > +			shift
> > +			;;
> >  		--help|-h)
> >  			help
> >  			exit 0
> > @@ -122,7 +128,45 @@ if [ $KUP -eq 1 ]; then
> >  		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
> >  fi;
> >  
> > +mail_file=$(mktemp)
> > +subject=""
> > +if [ -n "$LAST_HEAD" ]; then
> > +	subject="[ANNOUNCE] xfsprogs $(git describe --abbrev=0) released"
> > +
> > +	cat << EOF > $mail_file
> > +Hi folks,
> > +
> > +The xfsprogs repository at:
> > +
> > +	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > +
> > +has just been updated.
> > +
> > +Patches often get missed, so if your outstanding patches are properly reviewed
> > +on the list and not included in this update, please let me know.
> > +
> > +The for-next branch has also been updated to match the state of master.
> > +
> > +The new head of the master branch is commit:
> > +
> > +$(git log --oneline --format="%H" -1)
> > +
> > +New commits:
> > +
> > +$(git shortlog --format="[%h] %s" $LAST_HEAD..HEAD)
> > +
> > +Code Diffstat:
> > +
> > +$(git diff --stat --summary -C -M $LAST_HEAD..HEAD)
> > +EOF
> > +fi
> 
> Looks pretty similar to my git-announce tool. ;)
> 
> > +
> >  echo ""
> > -echo "Done. Please remember to push out tags and the branch."
> > +echo "Done."
> > +echo "Please remember to push out tags and the branch."
> >  printf "\tgit push origin v${version}\n"
> >  printf "\tgit push origin master\n"
> > +if [ -n "$LAST_HEAD" ]; then
> > +	echo "Command to send ANNOUNCE email"
> > +	printf "\tneomutt linux-xfs@vger.kernel.org -s \"$subject\" -i $mail_file\n"
> 
> Note: if you put the headers in $mail_file, like this:
> 
> cat << EOF > $mail_file
> To: linux-xfs@vger.kernel.org
> Subject: $subject
> 
> Hi folks,
> ...
> ENDL
> 
> then you can do:
> 
> 	neomutt -H $mail_file

Neat, will update this

> 
> to edit the message and send it out.  I also wonder if you'd like a copy
> of my git-contributors script that spits out a list of emails to cc
> based on the git diff?

sure, is it small enough to be a part of this file?

-- 
- Andrey

