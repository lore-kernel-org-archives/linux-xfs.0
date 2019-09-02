Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CE8C3A59E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F2C6206BB
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 17:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfIBRJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 13:09:44 -0400
Received: from verein.lst.de ([213.95.11.211]:51685 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbfIBRJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Sep 2019 13:09:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 035DC68AFE; Mon,  2 Sep 2019 19:09:41 +0200 (CEST)
Date:   Mon, 2 Sep 2019 19:09:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsprogs: provide a few compatibility typedefs
Message-ID: <20190902170940.GA7067@lst.de>
References: <20190830150327.20874-1-hch@lst.de> <20190902034349.rzglgsd4aajmhtup@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902034349.rzglgsd4aajmhtup@XZHOUW.usersys.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 02, 2019 at 11:43:49AM +0800, Murphy Zhou wrote:
> > +/*
> > + * Backards compatibility for users of this header, now that the kernel
> > + * removed these typedefs from xfs_fs.h.
> > + */
> > +typedef struct xfs_bstat xfs_bstat_t;
> > +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
> > +typedef struct xfs_fsop_geom_v1 xfs_fsop;
> 
> Still got build failure about this one.
> 
> Either change this line to:
> 
> +typedef struct xfs_fsop_geom_v1 xfs_fsop_geom_v1_t;

Yes, that is correct.  I'm obviously not competent enough to send
userspace patches :)
