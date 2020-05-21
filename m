Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9D7C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 08:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A75552070A
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 08:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="I4gqzcyc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgEUI35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 04:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbgEUI35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 04:29:57 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF04C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 01:29:55 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id m44so4838817qtm.8
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 01:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cllSm4spHwxIp84j3Fl4PSwTuufVNnDvq98SwVeJTAQ=;
        b=I4gqzcycTFY6KXl1q1mVh51MLTnnqtICkkTaek7DSN9sV2EP/eXUoMO4IQ/2U7dSmH
         W5ImCb6/JikVyh9Eb5jmAS5XJTU8ChRm4QcZg2o61Bc1a8SoFvihDdwEfTGz37XJwxgB
         hVWB7iXsTXEdohl1D8vRuQpwWvN+rlUYm80gJJ2LZz6JLgZ/NuAYDdGHn4pm9V96otGr
         fLZMnoxbWDaV0xQM95/v3ekcRFdCRnNFLxeJ9zl/O1cA6SEJwCBR1U/20K4LTcc1d17c
         eH2iDtUtkMyKzaazUqe4dmDSQUlaiU9eodJXWJBEvXXkybmr8ZuJ/41dSYCwbvqAZkf8
         qNMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cllSm4spHwxIp84j3Fl4PSwTuufVNnDvq98SwVeJTAQ=;
        b=A6VyhT0NWxsgkdxghr0ZrgbRUejBLUPIJB3MHAIbE80KBMw8oBdP7njUaAUaE50X0H
         XOmy0SKs8EinRzlsFp9k0kLqjnhygML1tgt/RicmfYXZKh+C5+k7C82onvH3uOZG1kPf
         J/tSREOiIlLgllb9DfiOcOgydkVqfbrMSVsfYJq2/cFwxnTpVnCrZBOo+0EK+xnmBOqF
         ST9RYOollYTx5CzRRx27Difx4fitTl+TZIHHU3wyseXiN2GPMj5XBF3FfUvR3U6+p2z+
         6jeWpbhSWHmpkCMr2O5My1maLopPRnRSjLcBXJj98zDMQkANGMtHwfqfT+5n95akNeQq
         q31g==
X-Gm-Message-State: AOAM532rH2ZFAbz9vqk9KKoDJ7lgBlKsYjCJrzVaonXCIj1OIg56cqA8
        IwcfAdUPq0e98wUI421MNKqAqyO0J5Rjmdy91qc=
X-Google-Smtp-Source: ABdhPJw1KKbCvee44tFeYkk67m9F9UvjCQtF5tXdfr3PHF3GdF3/7x49JjjzesYT7fQWf8rD9UJ+1H3INoOIBaOEkjU=
X-Received: by 2002:ac8:39a2:: with SMTP id v31mr9541939qte.33.1590049794911;
 Thu, 21 May 2020 01:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200513023618.GA2040@dread.disaster.area> <20200519062338.GH17627@magnolia>
 <20200520011430.GS2040@dread.disaster.area> <20200520151510.11837539@harpe.intellique.com>
In-Reply-To: <20200520151510.11837539@harpe.intellique.com>
From:   Mike Fleetwood <mike.fleetwood@googlemail.com>
Date:   Thu, 21 May 2020 09:29:43 +0100
Message-ID: <CAMU1PDjKGBVqog+JRB9OmYXTsT4y_chnDTHbF9P8xCJxN=aXqA@mail.gmail.com>
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 20 May 2020 at 14:25, Emmanuel Florac <eflorac@intellique.com> wrot=
e:
>
> Le Wed, 20 May 2020 11:14:30 +1000
> Dave Chinner <david@fromorbit.com> =C3=A9crivait:
>
> > Well, there's a difference between what a distro that heavily
> > patches the upstream kernel is willing to support and what upstream
> > supports. And, realistically, v4 is going to be around for at least
> > one more major distro release, which means the distro support time
> > window is still going to be in the order of 15 years.
>
> IIRC, RedHat/CentOS v.7.x shipped with a v5-capable mkfs.xfs, but
> defaulted to v4. That means that unless you were extremely cautious
> (like I am :) 99% of RH/COs v7 will be running v4 volumes for the
> coming years. How many years, would you ask?

[Trying again hopefully without HTML]

So initial RHEL/CentOS 7 releases did create XFS v4 file systems.
However from RHEL/CentOS 7.3 [1] (circa Nov 2016) they are creating XFS
v5 file systems by default.


[1] RHEL 7.3 Release Notes > Chapter 9. File Systems
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/ht=
ml/7.3_release_notes/new_features_file_systems


# cat /etc/centos-release
CentOS Linux release 7.8.2003 (Core)
# mkfs.xfs -V
mkfs.xfs version 4.5.0
# mkfs.xfs /dev/sdb13
...
# xfs_db -c version -r /dev/sdb13
versionnum [0xb4a5+0x18a] =3D
V5,NLINK,DIRV2,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CR=
C,FTYPE
