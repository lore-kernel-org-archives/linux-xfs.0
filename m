Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B5AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 01:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 593622137B
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 01:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbhARB0a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 20:26:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729469AbhARB03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jan 2021 20:26:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610933102;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=2uz2XuOYNoJ6I22OAPUzy3VH+2DGpH9uvYucMqQ37xk=;
        b=eBZUQlyKZL2GWmw6pM24LrkkPz060mZFBsKmn09Z+IUDILd1ZWX70/GnHga+z3w9hlt8pi
        hOZhqUg5DGWbu9ywZ58b+5ziEjiL6Ugx85h9QlrXcWmnk1sdpQiABNLOwSobthBifqTH0/
        pbPlmhbkJK7L0wWlCqPq/PgyeyipadA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-UMRC33waNsyGjkUP0v9bZQ-1; Sun, 17 Jan 2021 20:25:01 -0500
X-MC-Unique: UMRC33waNsyGjkUP0v9bZQ-1
Received: by mail-ej1-f71.google.com with SMTP id gs3so4702848ejb.5
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 17:25:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=2uz2XuOYNoJ6I22OAPUzy3VH+2DGpH9uvYucMqQ37xk=;
        b=eoyYxc1b1tfuuDdJ+vgh4hHaElKvXChgGsMOnHB4peF2PzunuObsamuHPnh0ul3DsC
         AWBnT+Fy7cixzZeeeNPd3fFlSLNwEVV4egmRAY216X/MRGpyppy8ADDzMdWKPIodXp8u
         cP74kATbdX8MPGuNmXdqKYziNmC+BMnCta3GAj+Ub3KFkY5BlMjMuj2QHMMIUpz58CoD
         BD4/I8jFlD/+YvlqcoMlzbXi120/C3iimevwOTlcMLcDSxDqxAi6KwMpQ3aTXaE7PQsW
         MPRvayyXqzA3SwcQS1PuI0n2AhxmtWssGv2Av8R+oSpGXlHxoZev0S+Dw34v6PPD4iLx
         RNyw==
X-Gm-Message-State: AOAM532bmNLKJ1L5DQ8nGtaB9FghfXLh3BIZrG2QHIrXFCYobdrrDf6O
        elo3xGrlHxAGg+WRKwbZ9261y27ceaJB9AiSSTj1bl1epk81wOeQgpGUJb8z9aWm8uUeqzA9vV6
        hfD/Mv+j8aDLKWaPCuaDddblV1SBWgDh1+sHf
X-Received: by 2002:aa7:d94b:: with SMTP id l11mr946971eds.1.1610933099925;
        Sun, 17 Jan 2021 17:24:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbWOxd/JTLPlVTD1/QaYALO4ems4wAo/yUZpBipb0yc0lRyskO2o36Att6bsYmxYzFw0i0T8CoZTWuiXKydfM=
X-Received: by 2002:aa7:d94b:: with SMTP id l11mr946960eds.1.1610933099708;
 Sun, 17 Jan 2021 17:24:59 -0800 (PST)
MIME-Version: 1.0
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de> <efbffecf-9dcd-79fd-4fe6-8f0e67d307c0@sandeen.net>
In-Reply-To: <efbffecf-9dcd-79fd-4fe6-8f0e67d307c0@sandeen.net>
Reply-To: nathans@redhat.com
From:   Nathan Scott <nathans@redhat.com>
Date:   Mon, 18 Jan 2021 12:24:48 +1100
Message-ID: <CAFMei7MN0PUs0oVR5GqGhi=buNZ5hfmrM-WDH3tLY-CdRLpBEA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 17, 2021 at 12:09 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
>
> On 1/16/21 3:23 AM, Bastian Germann wrote:
> > Apply some minor changes to the xfsprogs debian packages, including
> > missing copyright notices that are required by Debian Policy.
> >
> > v2:
> >   resend with Reviewed-by annotations applied, Nathan actually sent:
> >   "Signed-off-by: Nathan Scott <nathans@debian.org>"
>
> Heya Nate - please confirm that this was your intent.
>

Yep - thanks!

cheers.

--
Nathan

