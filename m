Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60787 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752220AbdCPX1R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 19:27:17 -0400
Date: Fri, 17 Mar 2017 00:25:55 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 07/22] mkfs: Move opts related #define to one place
Message-ID: <20170316232555.GX28800@wotan.suse.de>
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-8-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315160017.27805-8-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 15, 2017 at 05:00:02PM +0100, Jan Tulak wrote:
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0877c196..4ba6df05 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -48,6 +48,80 @@ unsigned int		sectorsize;
>  #define MAX_CONFLICTS	8
>  #define LAST_CONFLICT	(-1)
>  
> +#define OPT_B		0
> +#define B_LOG		0
> +#define B_SIZE		1

How about instead using enums, this way if we use kdoc format (hey the new
kernel doc format is producing nicer docs) we can then document what the
hell each of these things are nicely. Also, when enums are used in switches
the compiler will nag at you if you happened to have missed a case, unless you
have a default.

We could have an enum for the opts and then one for each subopt group.

  Luis
