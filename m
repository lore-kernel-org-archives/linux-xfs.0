Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37994 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753624AbeEWAZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 20:25:54 -0400
Date: Wed, 23 May 2018 10:25:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Deleting a project from XFS quotas
Message-ID: <20180523002552.GY23861@dastard>
References: <d30e573b-9c2a-cf97-7608-ad10a7b1b21c@gn.apc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30e573b-9c2a-cf97-7608-ad10a7b1b21c@gn.apc.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Macdonald <imac@gn.apc.org>
Cc: linux-xfs@vger.kernel.org

On Tue, May 22, 2018 at 10:46:28AM +0200, Ian Macdonald wrote:
> Hi,
> 
> We have been using XFS project quotas to track disk usage for various
> websites that we have on a server. The machine was running Debian jessie
> and this is what the quota report looked like:
> # xfs_quota -xc "report -h" /var
> 
> Project quota on /var (/dev/xvda3)
>                         Blocks
> Project ID   Used   Soft   Hard Warn/Grace
> ---------- ---------------------------------
> web01       74.3G    80G    81G  00 [------]
> web02       72.5G    75G    76G  00 [------]
> web03       18.5G    20G    21G  00 [------]
> web04       33.3G    40G    42G  00 [------]
> web05       10.3G    20G    21G  00 [------]
> web06        2.9G    20G    21G  00 [------]
> 
> However, after upgrading the server to Debian stretch, that same report
> now looks like this:

Yup, newer kernels use a different (more efficient) mechanism for
iterating the known quotas. It's driven from the kernel side, so
it finds all initialised dquots in the quota file, not just those
that userspace has name mappings for.

> Project quota on /var (/dev/xvda3)
>                         Blocks
> Project ID   Used   Soft   Hard Warn/Grace
> ---------- ---------------------------------
> #0          14.3G      0      0  00 [------]
> #15             0    20G    21G  00 [------]
> #32             0    20G    21G  00 [------]
> #33             0    20G    21G  00 [------]
> #34             0    20G    21G  00 [------]
> #35             0    20G    21G  00 [------]
> #36             0    20G    21G  00 [------]
> web01       86.5G    95G    96G  00 [------]
> web02       73.2G    75G    76G  00 [------]
> web03       19.5G    20G    21G  00 [------]
> web04       33.3G    40G    42G  00 [------]
> web05       10.3G    20G    21G  00 [------]
> web06        3.1G    20G    21G  00 [------]
> 
> I only have the 'web01' to 'web06' projects listed in my /etc/projects
> and /etc/projid files, for the particular directories whose disk usage I
> want to manage via XFS quotas.

The quota file has dquots on disk for quota IDs 15, and 32-36 as
well as whatever you have assigned to web0[1-6]. Quota ID 0 is the
default project quota, telling you how much used space is not
assigned to other project quotas. What you are probably seeing is
old dquots from previously configured project IDs. They are still
allocated on disk, just empty now that nobody is using them.

I don't know if reporting these empty quota IDs is intentional or
what you need to do to avoid having them reported - someone involved
in changing the dquot iteration mechanism will have to chime in on
that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
