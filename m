Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53829 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdBBTVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 14:21:39 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Safe XFS limits (100TB+)
Date: Thu, 02 Feb 2017 20:14:34 +0100
Message-ID: <9176347.zh1PoPzZKX@merkaba>
In-Reply-To: <20170202191627.42c50e67@harpe.intellique.com>
References: <CAL8yqihyYEaCEzWJLqAKsw1BBOQDm-AYR2dCUeN-X-449jCwzQ@mail.gmail.com> <20170202191627.42c50e67@harpe.intellique.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: fuser ct1 <fuserct1@gmail.com>, linux-xfs@vger.kernel.org

Am Donnerstag, 2. Februar 2017, 19:16:27 CET schrieb Emmanuel Florac:
> Use recent xfs progs and kernel, use xfs v5 if possible. Don't forget
> proper optimisations (use noop scheduler, enlarge nr_requests and
> read_ahead_kb a lot) for high sequential throughput (video is all about
> sequential throughput) and you should be happy and safe.

Just adding some Debian hints:

For Debian Jessie that means backport kernel – that means 4.8 currently. There 
is not backport of xfsprogs available tough and 3.2 is pretty old. I am not 
sure since when xfsprogs was switched to create xfs v5 by default – so maybe 
the proper options to activate xfs v5 are needed. There is always the option 
to compile xfsprogs yourself, or well just start out with Debian Testing as 
that in the process of being frozen more and more before release of Debian 
Stretch. I would be surprised of any major hichups regarding XFS in Debian 
Testing before the release. It will very likely have kernel 4.9 and xfsprogs 
4.9.

Thanks,
-- 
Martin
