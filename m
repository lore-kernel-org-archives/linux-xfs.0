Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EA735B659
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 12:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776085033; cv=pass; b=JLs12GlUcAuthZuwGJxMehc/LUYCdpNia6oSpciJ3maDS8MNbut/XkzsqmODPPOt5QTK7MN5aLqDu/laxZts99B6xQTYpOLOAhaVRDZ6864PJQW4OiDkUBZI60/KYsHfaUXuazd5N/axDg/cOIOmU1xd6TQkwVqopITArBGpkuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776085033; c=relaxed/simple;
	bh=uR/kevUl8c9GVofidVM1Qc0TkH3ZYw9y8ugO0bKps4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D+tek2/g4EfTdqM4ZGjDNk3qYZnEYOPfmXcjT5IYIgQuzcld2hcrYG9cFXoK0VbXVneLFaPzBOFyVutK7XR4/P995i0+04LxTFBr1gmuYGXEpK2mAu5AoiUG9oR23sSWPIGWTbLLRYMN1o8Sk66j3YnHnkPHqzPmrWR+vPPKRq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Go6x8cn8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZbmOgejr; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Go6x8cn8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbmOgejr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776085031;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boxzopIMxLyKEjb47TmR/p9TidxK7IB7oU/k+K+6nrc=;
	b=Go6x8cn8USGZgQGzLt/8TU4TCcNanotMt5VaIfYxXsdiHxPyKHJQcAbBxlqpQa1p65dyK2
	ACW4oj0wfske97qFkVo2iPXTrDPGswNeI+4nkJSFAlwx/K0JkbGXWt+iVoxqGkLBL12VYn
	i5AHFM8xGG6wzTcXx6O6l3kffIXG9MI=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-aysZ7J1XMeW6auk27IS8wg-1; Mon, 13 Apr 2026 08:57:09 -0400
X-MC-Unique: aysZ7J1XMeW6auk27IS8wg-1
X-Mimecast-MFC-AGG-ID: aysZ7J1XMeW6auk27IS8wg_1776085029
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-644548b1d9aso6321655d50.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 05:57:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776085029; cv=none;
        d=google.com; s=arc-20240605;
        b=kEICV5iozGeP+Tbke8bWIeFNwcn1yFR7bwkZsoONlLgJ6JhfYlDLvxLktV1QEBpndf
         FMXpeSIsozx9ErNdjfAdJaZLvJAVk/Qc4BtQAmcDhbyMd4ytmf7+La1xjcCNQrsqE/We
         31d5gobCF4PqpbXz5zRY6q/b7OIMkDK4OI/D/EN4g+Y4ifcQvNqDbLlRimrV7WEWv85Y
         mKHJ3vdNY7gxsKpAGMmYPI7CiX1AS1TNR3p7+X/KJqs2KpkXvNH9lNf0kXkvM1Th2cMM
         jmcnmOig+IV7ncH3c4GnHFJtoneRI0rvBF+O1RZZjEch6sx+1RY1MgZAI7zKAyOJ4v/f
         5+/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=boxzopIMxLyKEjb47TmR/p9TidxK7IB7oU/k+K+6nrc=;
        fh=nn7H9BjKK1G3iP7ITEIlwkYmlo9vD05pQKV/wkl5c0Y=;
        b=ABGKXB2hXzBvwds1e87h1yNLwmu6j3lr+1fBpV3rMi+Angl/qC+biot+v3eH0K3oFC
         C2X6p2qsbyP97nb+ru0uH86BWsURiFyU45VQG6clUXjjAv99bgbVxkfWS90YELKl7I5f
         6nyV5+1wmvAuz6vEJ/C5FWYLrTSMG/NCe0OQkUoOD5T18EoNFl6AyuWSK4KkvRGKjiz8
         qT/UIJmtMKBgbVTOu5zX+qRolSzzkMoP2jalc/jQH8wB8gwNNFvlVg2LO4+/NUAgrbbl
         X0FPsnVJFI7Ew3WHgiSW8p35Oh8eaz6/rJfLPBnBbe347ob7GXhiO4cAQ8ikLtIeeydy
         UQJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776085029; x=1776689829; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=boxzopIMxLyKEjb47TmR/p9TidxK7IB7oU/k+K+6nrc=;
        b=ZbmOgejrneX2hPkZrIb13cGudrwjtPFcowW9JDFf/Aurm/lS6g16ZjsCLKvRpX6yws
         K4LHCyNi6Ku5HAI6HT+4P42XLoXPgCZDdVEOlXHVrlYeqkijhc4WQfikKIQLbOVxDcYl
         B5W5ZKxInQffJcLU0RrW/ks5d6oWZ2fZyn6cySpZhq68+VkQ6Nlo1LZnxm8lJGF0HopR
         aLwqZ4AKS1TQ9ryWoELXLBm886XH9Rn7PNAd5ctzrNNjjCKGEpoHeE8vVf5MBDpab/fa
         Nf8qTBGwjOKj/eaHmdUF4ix7RG1gWI27RkATMwXPMZ/dAYCztm+l3YfJ+yfgKEaxSVd/
         58yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776085029; x=1776689829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=boxzopIMxLyKEjb47TmR/p9TidxK7IB7oU/k+K+6nrc=;
        b=Tr8S4q/10MvSVCUtXS6PjerdJFlqfpsdNwqkdcsSn3ecjO0wTPMDnlj+FZAeqXIbCP
         iwni1oobx6jCeG7PB7VN0tEaQV2uEbh1ER25RspdnWpqoY3lehsK6oLba+u7qTVSFDfA
         oMBy35LeAh0QjlZVP5IlYcelh7R432/63s6XMYAsEyDC3kdOGZdVXw5ND0vp4xEGrhD1
         NFpmtMqbHjGQsyj8+jLihgSyPFcZwQdZjZ6Xu7eobzXkW+MlgVeWLGTBWZGN4b6peflw
         GddWGGin6kvpbx/b5zU8+vpTEtB/0Wxb3V/KzIB1G4dE8whrksgre1S6OWXdabXd1NaT
         GM9w==
X-Forwarded-Encrypted: i=1; AFNElJ/OgMqCOiwS9xNu79Z8XhdaTAg6T98bv7SGfEMntu3lwlTTUqb73uSK+jscRQtXipzAGnbUpkC6t/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOtp+IMmn4NRTYnpzdAKrfnoJsX4k772w3nrrJ42cuxmedT4Xy
	qRdBozG3ZNX/9Lph7QX9JpYEeO0UdLHiBjKJaLXsgbFCnhDZzjpfV6fJ0c52siYhhuPKWWxkacG
	FZGRQq3bVpnTSTG29Cj3DH5oNa4GMjXfUyd2EDj1GDEAxlSG1QORLR6bJ5XD9dUWMNHpk0qdabP
	VOIxQOzu2sQWek7h/5sZSYOwTHf6VjC9IWzZc0
X-Gm-Gg: AeBDiesRa1bR2BKjtGtBNdcgZqo3Rj79qhlU3LWc0Cg97C1yVNdfuwggfy4E0lvBcQZ
	RajRroTlOOjZau2wD6+D0lPIXHjleMvTVZOTJYO9ymrNl9Ak4sP0xA4BxDMLDUse0u7ZI4VC+Ux
	QRdFfRgz9WsGoIOQkyP1ZJFHXsyfYZhU4ECI0Hz9psDmdMoVkuzeHj2GFOIKeQ2CwZjR/mgz6x0
	Pz7EfIV1sDquHObyaUj+J5VtZLnIl0yZJ0euNDVh/JFyEJmmtHm032899RYl9R9HTI/
X-Received: by 2002:a53:e204:0:b0:650:329b:abbc with SMTP id 956f58d0204a3-65198a571c5mr9326586d50.13.1776085029143;
        Mon, 13 Apr 2026 05:57:09 -0700 (PDT)
X-Received: by 2002:a53:e204:0:b0:650:329b:abbc with SMTP id
 956f58d0204a3-65198a571c5mr9326553d50.13.1776085028520; Mon, 13 Apr 2026
 05:57:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ads96yii8bij-UQQ@an3as.eu> <20260413035534.GF1048989@frogsfrogsfrogs>
In-Reply-To: <20260413035534.GF1048989@frogsfrogsfrogs>
Reply-To: nathans@redhat.com
From: Nathan Scott <nathans@redhat.com>
Date: Mon, 13 Apr 2026 08:56:55 -0400
X-Gm-Features: AQROBzD9Bn4EFqxWVhaWHR_jx3Nd1hNgReLhj5WmJ7rKVAFOpSKRrJASi6X5k-0
Message-ID: <CAFMei7Nr6u6xwD+MYber7TCbAj6sN5W1LDDRgu0xMhnxBE3W+Q@mail.gmail.com>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andreas Tille <tille@debian.org>, XFS Development Team <linux-xfs@vger.kernel.org>, 
	Anibal Monsalve Salazar <anibal@debian.org>, Nathan Scott <nathans@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, Apr 12, 2026 at 11:55=E2=80=AFPM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Sun, Apr 12, 2026 at 08:38:35AM +0200, Andreas Tille wrote:
> > Hi XFS Development Team,
> >
> > I'm currently reviewing team-maintained packages that are not exposing
> > Vcs fields.  I assume for some efficient team work you are maintaining
> >
> >   xfsdump
> >   xfsprogs
> >
> > in some Git repository, but the Vcs fields are not set and I could not
> > find corresponding repositories on Salsa.  I'm not even sure whether yo=
u
> > might have some team space there or whether the Debian team might
> > sufficiently fulfill your needs.
> >
> > I'd be happy if these packages could be maintained in a publicly visibl=
e
> > Git repository on Salsa, with appropriate Vcs fields set.
>
> That's more or less a matter of setting a couple of fields in
> debian/control, right?
>
> Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master

This is the correct approach to represent the xfsprogs setup, thanks!

cheers.

--
Nathan

> --D
>
> > If there are specific reasons why this is currently not the case, I
> > would be interested to understand them as well.
> >
> > If you need any help with creating some Git repository I can happily
> > do so since I have developed some training in doing this.
> >
> > Thanks for your work on XFS in Debian, and best regards,
> >    Andreas.
> >
> > --
> > https://fam-tille.de
> >
>

