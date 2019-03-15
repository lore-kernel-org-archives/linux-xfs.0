Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:38966 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfCOASo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 20:18:44 -0400
Received: by mail-it1-f196.google.com with SMTP id l15so8150187iti.4
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 17:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <155259742281.31886.17157720770696604377.stgit@magnolia> <155259746044.31886.13633380455067163247.stgit@magnolia>
In-Reply-To: <155259746044.31886.13633380455067163247.stgit@magnolia>
From: Nathan Scott <nathans@redhat.com>
Date: Fri, 15 Mar 2019 11:18:32 +1100
Message-ID: <CAFMei7MhwDDLvZ41Op5ij7S0_h3FpK19eXZdX6=guS_nBJ361A@mail.gmail.com>
Subject: Re: [PATCH 06/36] debian: enable parallel make
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Sandeen, Eric" <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 15, 2019 at 8:04 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Use parallel make to speed up dpkg builds.

Seems a little more involved than I woulda expected, but LGTM.

Reviewed-by: Nathan Scott <nathans@debian.org>

>                 for dir in include libxfs; do \
> -                       $(MAKE) -C $$dir NODEP=1 install-headers; \
> +                       $(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
>                 done; \

OOC, does the $(MAKE) -C above warrant the same treatment as the earlier patch?
(i.e. removing the -C there for less verbosity)

cheers.

--
Nathan
