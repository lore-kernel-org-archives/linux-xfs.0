Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752974AbdHXS7j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 14:59:39 -0400
Date: Thu, 24 Aug 2017 20:59:36 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170824185936.GN27873@wotan.suse.de>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824180441.GL27873@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, NeilBrown <neilb@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

On Thu, Aug 24, 2017 at 08:04:41PM +0200, Luis R. Rodriguez wrote:
> On that note FWIW, at this point I've reviewed 4 libraries for mkfs.xfs:
> 
>   o libconfig -- we want to stay away from this [0]
>   o e2fsprogs libprofile -- its a fork of krb5 libparser, size-wise this is [1]
>     a best option, however its also a fork on its own, or 
>   o libini_config -- my pick and what I recommend [2] due it supporting
>     uint64_t well, having a good new community traction, and a good set of
>     tests
>   o nfs: has its own incarnation of a library
> 
> *Iff* we want to share the same library for mkfs.xfs and also a udev helper,
> then a new requirement here is perhaps also having a respective library on
> other higher level language like python for instance, if not now perhaps
> for the future. Unless of course we'd expect such udev heleprs to be C
> based.
> 
> [0] https://gitlab.com/mcgrof/libconfig-int64-issues
> [1] https://gitlab.com/mcgrof/libekprofile
> [2] https://gitlab.com/mcgrof/libini_config-demo

FWIW -- for a more thorough evaluation folks can read a bit more about
configuration file uses for filesystems on this work-in-progress paper:

https://gitlab.com/mcgrof/filesystem-configuration-paper/blob/master/paper.pdf

It does not take into account the newly mentioned possible use case as this
is new and just now considered.

Feedback/rants on other points welcomed.

  Luis
