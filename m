Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:33528 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfCOAQ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 20:16:29 -0400
Received: by mail-io1-f68.google.com with SMTP id b6so6939776iog.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 17:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <155259742281.31886.17157720770696604377.stgit@magnolia> <155259745436.31886.466306969009991047.stgit@magnolia>
In-Reply-To: <155259745436.31886.466306969009991047.stgit@magnolia>
From: Nathan Scott <nathans@redhat.com>
Date: Fri, 15 Mar 2019 11:16:18 +1100
Message-ID: <CAFMei7PZ4c+n5Fm7fH9riOCwzku7TpeDUdTigY6Do4_N4QKBuQ@mail.gmail.com>
Subject: Re: [PATCH 05/36] debian: don't bypass top level Makefile when
 building subdirs
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
> The top level Makefile does some processing to set build environment
> variables (Q and CHECK_CMD).  debian/rules uses -C to build subdirs
> directly, which bypases this feature of the top-level makefile, which
> causes more build spew than necessary (because Q never gets set to quiet
> the build).
>
> Since the top level makefile can be used to build the subdirs
> debian/rules cares about, drop the -C and build subdirs via the top
> level Makefile to quiet the build.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Neat.

Reviewed-by: Nathan Scott <nathans@debian.org>

cheers.

--
Nathan
