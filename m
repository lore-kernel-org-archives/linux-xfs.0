Return-Path: <SRS0=kaVg=2T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B88C2D0C0
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 03:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1239620409
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 03:15:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="rUpa0m3R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfL2DP0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 28 Dec 2019 22:15:26 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:39037 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfL2DP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Dec 2019 22:15:26 -0500
Received: by mail-wm1-f50.google.com with SMTP id 20so11590724wmj.4
        for <linux-xfs@vger.kernel.org>; Sat, 28 Dec 2019 19:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BsOPFuTIPa+r7NQHHy+T+rm4SU2TjmXEVIHSKzlGWps=;
        b=rUpa0m3RbW/HMIeae1SmSZ15LL5aWLYv8344leuRI54iD7rvn7dZOjYRE+KUoDLhZC
         T7XYS3ePH1n3Hu3/jNUrpIJAjy/Sbw7cRqItnQWQJUcQVUt/tfK/qh2VXWSiJbFl4BvQ
         Oh86I9VAbA27cddeSIRbg9h4+l8RLve60Wv/GPvlHj4i3Dbme9UWxGwUbaNwu9Lrob9/
         6RMaby5AGq3/WPs8w+THuueFhQlt+COelHJRILrLsDQHP1g2Ww+R/fWRL3E8jJhTDQIU
         td4LQxc5IXD1+bfnadStBg/kTsZq7O8M1n5d+jGybSce2Tf3j1JDNBm1vfYyFo1Wq/Uw
         diUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BsOPFuTIPa+r7NQHHy+T+rm4SU2TjmXEVIHSKzlGWps=;
        b=W2j6eAnFaTOMAnscU8yQmz+m0o689jOFy9LGjzVMpNIAFCN7VQnFBgjokOAOkf9Eln
         kShv5IXDtWqC33SaoMN2VObr4Ky5mx+z8gamUVn2mqQbVOR+akyT1WhfXnFrSq5xC2oA
         spH+siKScVcG3S9eKXH5OgO9/5hc1yKqwjVi47UZr2KAfMdLkppyRMt1Bgw2grPRy5Dl
         P02j21YRZgu9F+Ah1yO36XSU82XlUKUtD95MjaO29YaoWQvOL7yyNefkMQmG/alqZiSC
         0g7ZDWInp8anlo6jEAHPvBuT2a1bCNjh3JVtjD0ZxTH2IWwfz6R5dEUrZJlRCxFL1v97
         c3+A==
X-Gm-Message-State: APjAAAVBOOGVpC97f3GhzXyJR0iLIEfhuZEhFgkUJ6+V4RUThr/KcObp
        bZ8nK0AKs1cLqPXFB50P3ksbL9gpd7dFrCieeBLD+g==
X-Google-Smtp-Source: APXvYqyYDNPdPVUGL2or0bqS+1ZtnbuwpCDS97MePmljJAOHtxR8qL8QdS8Kt//n+WuomlFXVvEOKOThNuGU+yNgWcs=
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr26977879wmh.164.1577589323921;
 Sat, 28 Dec 2019 19:15:23 -0800 (PST)
MIME-Version: 1.0
References: <CAH3av2k4c63LKQ0eG9twweXEgC7QD7G_w3=c23tSO5rLP_cAfQ@mail.gmail.com>
In-Reply-To: <CAH3av2k4c63LKQ0eG9twweXEgC7QD7G_w3=c23tSO5rLP_cAfQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 28 Dec 2019 20:15:08 -0700
Message-ID: <CAJCQCtT5aMOX1RtFgbhzKsfq2BY00fwsF-UJMnt+0V8wBAJ93Q@mail.gmail.com>
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of
 512 bytes
To:     Utpal Bora <cs14mtech11017@iith.ac.in>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 28, 2019 at 4:12 AM Utpal Bora <cs14mtech11017@iith.ac.in> wrote:
>
> Hi,
>
> My XFS home drive is corrupt after trying to extend it with lvm.
> This is what I did to extend the partition.
> 1. Extend Volume group to use a new physical volume of around 1.2TB.
> This was successful without any error.
>     vgextend vg-1 /dev/sdc1
>
> 2. Extend logical volume (home-lv) to use the free space.
>     lvextend -l 100%FREE /dev/mapper/vg--1-home--lv -r

What approximate byte value is 100%FREE ?

> 3. Resized home-lv and reduce 55 GB
>    lvreduce -L 55G  /dev/mapper/vg--1-home--lv -r

If this is really a volume reduction, along with -r I would expect
this entire command to fail. XFS doesn't support shrink. Since a
successful LV shrink requires shrinking the file system first, or else
it results in truncation of the file system it contains and thus
damages it, off hand I think this is a bug in lvreduce, or possibly in
fsadm which is what -r calls to do the resize.

My suggestion is to make no further changes at all, no further
recovery attempts. And head over to the LVM list and make the same
post as above. It's very possible there's backup LVM metadata that
will reference the PE/LE's used in the LV prior to the lvreduce. By
restoring the LV using that exact same mapping, it should be possible
to recover the file system it contains. But only if you don't make
other attempts. The more additional attempts the greater the chance of
irreparable changes.

https://www.redhat.com/mailman/listinfo/linux-lvm

> I assumed that -r will invoke xfs_grow internally.

Right, but xfs_grow only grows. It doesn't shrink. So my expectation
is that the lvreduce command should fail without having made any
changes. And yet...

--
Chris Murphy
