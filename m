Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36851 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbeCNNFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 09:05:32 -0400
Received: by mail-wr0-f179.google.com with SMTP id d10so4715034wrf.3
        for <linux-xfs@vger.kernel.org>; Wed, 14 Mar 2018 06:05:31 -0700 (PDT)
Received: from odin.usersys.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r19sm1781555wmd.48.2018.03.14.06.05.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Mar 2018 06:05:27 -0700 (PDT)
Date: Wed, 14 Mar 2018 14:05:26 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/4] Remove a few macros
Message-ID: <20180314130526.hg2gdafncrnn3puc@odin.usersys.redhat.com>
References: <20180306130053.13958-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306130053.13958-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

On Tue, Mar 06, 2018 at 02:00:49PM +0100, Carlos Maiolino wrote:
> For a while, these macros have been removed from kernel, removing them from
> xfsprogs brings the code closer to kernel code, and is a first step on such
> process.
> 
> I tried to get rid of such macros as more segmented as possible (1 macro per
> patch), although, last to patches are good candidates to be merged together, but
> I believe it's just cleaner to have them as separated patches
> 
> Carlos Maiolino (4):
>   Get rid of XFS_BUF_PTR() macro
>   Get rid of XFS_BUF_TARGET() macro
>   get rid of XFS_BUF_COUNT() macro
>   Get rid of XFS_BUF_SET_COUNT() macro
> 

Any updates, if I should rebase this patchset over Eric's patches and resend it,
or if I should rework something else?

I've sent a V2 changing the casts according to Dave's suggestions, and hch
preferred this version, due how GCC handles pointers calculation.

Is there anything else I should change, or can I just rebase it against Eric's
patches and resend this version?

Cheers

> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
