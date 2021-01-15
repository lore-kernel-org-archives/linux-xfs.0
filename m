Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B2EC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 03:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4228823AC0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 03:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbhAODmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 22:42:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730161AbhAODmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 22:42:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610682053;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=4HmbeR3vIN4bc+Jk+FjVwiVY7cEzgTCkTqSNjw9bJ4Q=;
        b=ccJ0cRHMehUpUXLyNxlLVQuZfBlpQVK6Wj3terao2Bmi0DqyYjiFKqK4DGNqVEp0dBWQur
        JF6/SOME+Qn/qtm10Q+jrODIVmiHaiFUVYJCTvfMsiOp4kbtjb+Ihn+jsNsRYz9ilw2G/0
        M8IngR/M1qkp8/KNaxe/F+0IGzyauIc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-pc170LZwMG2aLtx2SCSHCg-1; Thu, 14 Jan 2021 22:40:51 -0500
X-MC-Unique: pc170LZwMG2aLtx2SCSHCg-1
Received: by mail-ed1-f71.google.com with SMTP id dh21so3246402edb.6
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 19:40:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=4HmbeR3vIN4bc+Jk+FjVwiVY7cEzgTCkTqSNjw9bJ4Q=;
        b=ngis8i6IPkB0W6gpWk76dQXoXtX7B5hJElrjHrEr+xJiefBdQmtdwL/68pks98hB3g
         dfLjsoABXBgP/TWU1qkFdhjgBAMOq5ipWguqHqAuVzU+j3+tZH8yP1yY2U8SEy+HsHWS
         jIfWXmOGgK8UddKMR0BuidRchiTX4VZRJJkrEDnNf+OGj+SraBShSD0cUxcZ5SExLE5x
         8RSQMhvVA/fPqeGL+aBFXNJj9LbEoEOycz/tZWJtI0cMMCLtcPIo7ujmhHoBH1FAOgLw
         ll2O6C5s3OCbuOIkTCrNcGecN61WR8c+Uqc0mXOZZXhYAJA9kdMT9kRd99pJlGD8Iob2
         ouCQ==
X-Gm-Message-State: AOAM533lrJQX6JorJEzB+IGB8PEt7VR5WT4tkt8FIySL3iArePLVk7LI
        ScMohMLxex9Z6lev+K3+u17JMy2tIWAH1J2/cTaZ/0uny/zCffNH0jlJ1v55q51JI5oMYSV4CYb
        rPi0RxanjQ94FJByfyHWjU9ZmhHtdj43Nynfs
X-Received: by 2002:a17:906:8597:: with SMTP id v23mr3320949ejx.72.1610682050248;
        Thu, 14 Jan 2021 19:40:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySaL46k70T+WoOOwPlCffUuAT06Zw4JszaVw22THRhXWtTkORkrfY0gCcem7IMllM/y5+2WuCYCgBaVx4tULI=
X-Received: by 2002:a17:906:8597:: with SMTP id v23mr3320941ejx.72.1610682050108;
 Thu, 14 Jan 2021 19:40:50 -0800 (PST)
MIME-Version: 1.0
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
Reply-To: nathans@redhat.com
From:   Nathan Scott <nathans@redhat.com>
Date:   Fri, 15 Jan 2021 14:40:39 +1100
Message-ID: <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
Subject: Re: [PATCH 0/6] debian: xfsprogs package clean-up
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bastian Germann <bastiangermann@fishpost.de>
Cc:     xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Heya,

On Fri, Jan 15, 2021 at 5:39 AM Bastian Germann
<bastiangermann@fishpost.de> wrote:
>
> Apply some minor changes to the xfsprogs debian packages, including
> missing copyright notices that are required by Debian Policy.
>
> Bastian Germann (6):
>   debian: cryptographically verify upstream tarball
>   debian: remove dependency on essential util-linux
>   debian: remove "Priority: extra"
>   debian: use Package-Type over its predecessor
>   debian: add missing copyright info
>   debian: new changelog entry

Having reviewed each of these, please add for each:

Signed-off-by: Nathan Scott <nathans@debian.org>


Also, please add Bastion to the list of deb uploaders - thanks!

diff --git a/debian/control b/debian/control
index 49ffd340..06b92400 100644
--- a/debian/control
+++ b/debian/control
@@ -2,7 +2,7 @@ Source: xfsprogs
 Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
-Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar
<anibal@debian.org>
+Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar
<anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
 Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>=
5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17),
linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python,
pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/

