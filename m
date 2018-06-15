Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754623AbeFOHMh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 03:12:37 -0400
Date: Fri, 15 Jun 2018 00:12:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180615071236.GA17459@infradead.org>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
 <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
 <20180613094048.6becmt42cvdhvg66@odin.usersys.redhat.com>
 <CA+Xn3kzsrqjNH2yXdtfsRuiCBfvX2GSWOW2SaLPL4h1PmQsGBg@mail.gmail.com>
 <20180615070829.m5ligybzlods4l5r@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615070829.m5ligybzlods4l5r@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Pronin <ipronin@twitter.com>, linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 09:08:29AM +0200, Carlos Maiolino wrote:
> As I said before, IMHO, I believe the way you are using project quotas is wrong.
> Project quotas is supposed to be used on a sub-tree based granularity, not on a
> file based granularity. But again, that's just my opinion.

That is not true.  The per-file usage was indeed the original use
case.  The tree quoats implemented using the inheritance were added
much latter.  They are the common use case now, but that doesn't make
other use cases wrong.
