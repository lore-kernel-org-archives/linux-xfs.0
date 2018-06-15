Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36724 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936183AbeFOI52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 04:57:28 -0400
Received: by mail-wr0-f195.google.com with SMTP id f16-v6so9150483wrm.3
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 01:57:28 -0700 (PDT)
Date: Fri, 15 Jun 2018 10:57:24 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180615085724.pkpfpmuas5ujmcbw@odin.usersys.redhat.com>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
 <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
 <20180613094048.6becmt42cvdhvg66@odin.usersys.redhat.com>
 <CA+Xn3kzsrqjNH2yXdtfsRuiCBfvX2GSWOW2SaLPL4h1PmQsGBg@mail.gmail.com>
 <20180615070829.m5ligybzlods4l5r@odin.usersys.redhat.com>
 <20180615071236.GA17459@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615071236.GA17459@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Ilya Pronin <ipronin@twitter.com>, linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 12:12:36AM -0700, Christoph Hellwig wrote:
> On Fri, Jun 15, 2018 at 09:08:29AM +0200, Carlos Maiolino wrote:
> > As I said before, IMHO, I believe the way you are using project quotas is wrong.
> > Project quotas is supposed to be used on a sub-tree based granularity, not on a
> > file based granularity. But again, that's just my opinion.
> 
> That is not true.  The per-file usage was indeed the original use
> case.  The tree quoats implemented using the inheritance were added
> much latter.  They are the common use case now, but that doesn't make
> other use cases wrong.

Thanks for the info. I always thought project quotas were designed for
directory-tree granularity, and user/group quotas as a file-based granularity.
But, out of curiosity, if this is not a stupid question...
If project quotas was initially designed as a per-file usage use case in mind,
what would make it different from group quota for example?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
