Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44933 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932239AbcJMOMH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Oct 2016 10:12:07 -0400
Date: Thu, 13 Oct 2016 16:11:45 +0200
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH] m4/ltp-xfs_quota.m4: fix xfs quota check
Message-ID: <20161013141145.GA12204@rei.lan>
References: <1476150729-2128-1-git-send-email-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476150729-2128-1-git-send-email-yangx.jy@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: ltp@lists.linux.it, linux-xfs@vger.kernel.org

Hi!
> Current check doesn't work since xfsprogs v4.5.0.
> Undefined off64_t type leads to this issue, so we
> need to define _GNU_SOURCE to make off64_t defined.
> 
> This has been broken by upstream xfsporgs-dev commmit
> 
> commit cb898f157f8410a03cf5f3400baa1df9e5eecd33
> Author: Felix Janda <felix.janda@posteo.de>
> Date: Fri Feb 5 08:34:06 2016 +1100
> 
>   linux.h: Use off64_t instead of loff_t

That kind of looks like a bug in xfs-progs, since off64_t is not exposed
from glibc unless we enable either largefile support or define
_GNU_SOURCE. As a matter of fact the _GNU_SOURCE enables
_LARGEFILE64_SOURCE which then enables the typedef that exposes the
off64_t typedef.

So they are depending on a type that is not defined by default but since
the code has been part of at least three releases already we have to
apply the workaround for it anyway.

Patch pushed, thanks.

[CCing the XFS mailing list in case they want to do something about it]

-- 
Cyril Hrubis
chrubis@suse.cz
