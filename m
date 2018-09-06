Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32805 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeIGDdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 23:33:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id s7-v6so5979325pgc.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 15:55:39 -0700 (PDT)
Date: Thu, 6 Sep 2018 15:55:35 -0700
From: Brian Norris <briannorris@chromium.org>
Subject: Re: [PATCH xfsprogs] build: don't assume $BUILD_CC has fsmap.h just
 because $CC does
Message-ID: <20180906225534.GA114388@ban.mtv.corp.google.com>
References: <20180906183529.117251-1-briannorris@chromium.org>
 <30774ff1-57c1-c9f4-4ec3-31c177b11489@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30774ff1-57c1-c9f4-4ec3-31c177b11489@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Hi Eric,

On Thu, Sep 06, 2018 at 05:33:56PM -0500, Eric Sandeen wrote:
> I was trying to just get the selftest to build with a custom set of
> userspace headers, like the patch below, so we don't have to pull in all
> the various and sundry xfs headers & dependencies.  Not sure what the better
> approach is here ...

I think an ideal goal is still to remove all usage of HAVE_* from
anything that gets built with $BUILD_CC. I guess that's just
crc32selftest? So even if you do that, it would still be good to do
something like my patch. (Maybe even more than that -- remove the BLKID,
FSETXATTR, etc., flags from $BUILD_CFLAGS.)

But your patch does work for me. (Well, I had to port it back a little,
since my cross-compilation environment isn't building off the
development tip.)

Thanks,
Brian
