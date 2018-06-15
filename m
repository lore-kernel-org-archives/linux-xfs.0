Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936076AbeFOJAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 05:00:24 -0400
Date: Fri, 15 Jun 2018 02:00:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180615090023.GA7411@infradead.org>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
 <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
 <20180613094048.6becmt42cvdhvg66@odin.usersys.redhat.com>
 <CA+Xn3kzsrqjNH2yXdtfsRuiCBfvX2GSWOW2SaLPL4h1PmQsGBg@mail.gmail.com>
 <20180615070829.m5ligybzlods4l5r@odin.usersys.redhat.com>
 <20180615071236.GA17459@infradead.org>
 <20180615085724.pkpfpmuas5ujmcbw@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615085724.pkpfpmuas5ujmcbw@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Ilya Pronin <ipronin@twitter.com>, linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 10:57:24AM +0200, Carlos Maiolino wrote:
> Thanks for the info. I always thought project quotas were designed for
> directory-tree granularity, and user/group quotas as a file-based granularity.
> But, out of curiosity, if this is not a stupid question...
> If project quotas was initially designed as a per-file usage use case in mind,
> what would make it different from group quota for example?

IRIX had projects integrated into the whole OS, that these did fit into.
Group quotas were only added to XFS after the Linux port.
