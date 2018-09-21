Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45659 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391184AbeIVA1N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Sep 2018 20:27:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id i26-v6so6333145pfo.12
        for <linux-xfs@vger.kernel.org>; Fri, 21 Sep 2018 11:37:05 -0700 (PDT)
Date: Fri, 21 Sep 2018 11:37:02 -0700
From: Brian Norris <briannorris@chromium.org>
Subject: Re: [PATCH xfsprogs] build: don't assume $BUILD_CC has fsmap.h just
 because $CC does
Message-ID: <20180921183700.GA203751@ban.mtv.corp.google.com>
References: <20180906183529.117251-1-briannorris@chromium.org>
 <30774ff1-57c1-c9f4-4ec3-31c177b11489@sandeen.net>
 <20180906225534.GA114388@ban.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906225534.GA114388@ban.mtv.corp.google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 06, 2018 at 03:55:34PM -0700, Brian Norris wrote:
> On Thu, Sep 06, 2018 at 05:33:56PM -0500, Eric Sandeen wrote:
> > I was trying to just get the selftest to build with a custom set of
> > userspace headers, like the patch below, so we don't have to pull in all
> > the various and sundry xfs headers & dependencies.  Not sure what the better
> > approach is here ...
> 
> I think an ideal goal is still to remove all usage of HAVE_* from
> anything that gets built with $BUILD_CC. I guess that's just
> crc32selftest? So even if you do that, it would still be good to do
> something like my patch. (Maybe even more than that -- remove the BLKID,
> FSETXATTR, etc., flags from $BUILD_CFLAGS.)
> 
> But your patch does work for me. (Well, I had to port it back a little,
> since my cross-compilation environment isn't building off the
> development tip.)

Ping? Should I send a new version that combines our patches?

Regards,
Brian
