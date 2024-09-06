Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E9448CFC
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 03:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725594294; cv=none; b=KuMliZuZ8hrOzKGX0diKgTqdmDY22QP12khL2iCVrLFud7iZuC6svjUcT6s3MQ3IDDNvC9lsIxjINkASn/8NcNW9P7uXjYWqigsrp0FXfch46HPAv6Z0cXh6lVW2gYZMPneP/6Xd8GXY8V31Tzbfmerj+IgxyTbkjgYP6YJRYSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725594294; c=relaxed/simple;
	bh=3/+vytpspWWORVql5n6t/mT6Bh/MUWPO99Ry4OYJnYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PlHsO/9CuseWpQVhIzHZD410C06iwi/JNQq+mcm19dBJ7ADXpjwJUB/qA1m+V8iBuJuLEX15krstkaZEYFhg/7cVXiseTW5FiMvAWl1MouTXtQdrE+seLQZtpvJstU145OINqQUX/D27Ej2t8yN72fQEwmZyEhrPNT+UzjQmFSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=d+AuAbAI; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="d+AuAbAI"
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com [209.85.219.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3AA043F5AB
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 03:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1725594289;
	bh=FOWKZaZsgk7gRF82n+LEXeVs/JB7uXjutf5ZzKMkFGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=d+AuAbAIOeYUkoMEY0PSXKmmhDqnHfJIrexStrWDQWPs36uqVAWsHNdr9vsHJ0Gl6
	 g682CZvfNEjvsUrMxdFweGwWV+BKuojJwv2cYk7ku+tqucFAar//YdZyhn7T759HbR
	 LlAfGOT59pSXPDsX/foJJS0912EiHFD71FyKzZnhn+U9vU0NRoI2myQ0ArkFzvdaDu
	 Mmjblf/jSSWcnmOg+Zc6jAxhiu2oV+QQ3J93QN5FwrCBlRQjNd5U7zczrUL52xbSb8
	 0Z5v7GJL1l45rmDI7uvAkY6eW0H9RzaD9aiUY5qdo8VZbcK1zuA1G+hei0XdEF5fAZ
	 voDt514f+0jGA==
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-e1a7ef9eb78so3609543276.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 20:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725594288; x=1726199088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOWKZaZsgk7gRF82n+LEXeVs/JB7uXjutf5ZzKMkFGc=;
        b=bvgUpWTv/7kzmbE+Say3/lparLNZHjiymMzkSHgNSY+e/3gx22I0iMA4MZJdd9LgzQ
         vecGwBUlqatu1m30YBos1LWKYKfYHRJgjbvUIZwAmUc59sSnYWi1tE6YcR5is4quJQxi
         WyplSYucRcE39JLROVPcPM5qQ+eHdGLT0FsxDHH+SL1XQ3eDvp8GtEaikXDnHWyRu141
         VugznL/m7+SmLjWPrIoy22cXNqqVa+Sof6PO5H77kCNvfoEsIrvzwPpTQmvW6Z9D/AIZ
         G9g+2Zv3tHAwWgOlLs1ojoN4js2y+TEtV+l0p0GoyrU4keaMF49xxeiJJQyOfrkC0X4P
         Khnw==
X-Forwarded-Encrypted: i=1; AJvYcCXzyyBAQGn/pCYFTKZooIOvZldESFFupSn2h8F8udc56O1BQodWTlaXqfGeeeoRz83Un06Bonxn6PA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp4S9CnHUeCIVlLVpX4N6kaHOARANnAjOn+CbPMCfLJnL0uuKU
	VWf7fTpLQxs2e/skd8N4P9dRBmq97CuQCAC3OaaNZ6T9C+f4gY0WYuv92+hs97/YbHT0BmhmnB2
	vp8ji5Qb/OQOZhLoTHL4afCw8cwdEjdKE2V6Ymz7+5GIu13hWMC5lvI2T9phgkt8PxvGp09ayRm
	uyKWifDqlWHndgQ0kYay1RyU7+vzjJvxDYYOEpoaHuR+sMUyqiniQLUc/lILFVrA==
X-Received: by 2002:a05:6902:1201:b0:e0b:db13:76bc with SMTP id 3f1490d57ef6-e1d348661aamr1656355276.12.1725594287985;
        Thu, 05 Sep 2024 20:44:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYt32VQyfa3UEOLTpB8XTsDVlBVPCy97S3G9sJaRr5HOMT4SokFv3WwCvu9kTTyhbb8JVlOoYSPwKX2Bnkatw=
X-Received: by 2002:a05:6902:1201:b0:e0b:db13:76bc with SMTP id
 3f1490d57ef6-e1d348661aamr1656342276.12.1725594287656; Thu, 05 Sep 2024
 20:44:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240813072815.1655916-1-gerald.yang@canonical.com> <20240813145327.GE6051@frogsfrogsfrogs>
In-Reply-To: <20240813145327.GE6051@frogsfrogsfrogs>
From: Gerald Yang <gerald.yang@canonical.com>
Date: Fri, 6 Sep 2024 11:44:37 +0800
Message-ID: <CAMsNC+vKDt21mLG_VZDyMXZkVOeMsQ45hU7D7gCvHj9HmT0DxQ@mail.gmail.com>
Subject: Re: [PATCH] fsck.xfs: fix fsck.xfs run by different shells when
 fsck.mode=force is set
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you Darrick for the review
I just would like to ask if this will be merged into for-next soon?


On Tue, Aug 13, 2024 at 10:53=E2=80=AFPM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Tue, Aug 13, 2024 at 03:25:51PM +0800, Gerald Yang wrote:
> > When fsck.mode=3Dforce is specified in the kernel command line, fsck.xf=
s
> > is executed during the boot process. However, when the default shell is
> > not bash, $PS1 should be a different value, consider the following scri=
pt:
> > cat ps1.sh
> > echo "$PS1"
> >
> > run ps1.sh with different shells:
> > ash ./ps1.sh
> > $
> > bash ./ps1.sh
> >
> > dash ./ps1.sh
> > $
> > ksh ./ps1.sh
> >
> > zsh ./ps1.sh
> >
> > On systems like Ubuntu, where dash is the default shell during the boot
> > process to improve startup speed. This results in FORCE being incorrect=
ly
> > set to false and then xfs_repair is not invoked:
> > if [ -n "$PS1" -o -t 0 ]; then
> >         FORCE=3Dfalse
> > fi
> >
> > Other distros may encounter this issue too if the default shell is set
> > to anoother shell.
> >
> > Check "-t 0" is enough to determine if we are in interactive mode, and
> > xfs_repair is invoked as expected regardless of the shell used.
> >
> > Fixes: 04a2d5dc ("fsck.xfs: allow forced repairs using xfs_repair")
> > Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
> > ---
> >  fsck/xfs_fsck.sh | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > index 62a1e0b3..19ada9a7 100755
> > --- a/fsck/xfs_fsck.sh
> > +++ b/fsck/xfs_fsck.sh
> > @@ -55,12 +55,12 @@ fi
> >  # directly.
> >  #
> >  # Use multiple methods to capture most of the cases:
> > -# The case for *i* and -n "$PS1" are commonly suggested in bash manual
> > +# The case for *i* is commonly suggested in bash manual
> >  # and the -t 0 test checks stdin
> >  case $- in
> >       *i*) FORCE=3Dfalse ;;
>
> I can't remember why we allow any argument with the letter 'i' in it to
> derail an xfs_repair -f invocation??
>
> Regardless, the bits you changed look correct so
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> --D
>
> >  esac
> > -if [ -n "$PS1" -o -t 0 ]; then
> > +if [ -t 0 ]; then
> >       FORCE=3Dfalse
> >  fi
> >
> > --
> > 2.43.0
> >
> >
