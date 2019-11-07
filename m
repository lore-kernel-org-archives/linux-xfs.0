Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576B2C5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23E0521D79
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKGI3u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:29:50 -0500
Received: from verein.lst.de ([213.95.11.211]:55720 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfKGI3u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 03:29:50 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3899C68B05; Thu,  7 Nov 2019 09:29:48 +0100 (CET)
Date:   Thu, 7 Nov 2019 09:29:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/34] xfs: devirtualize ->sf_get_ino and ->sf_put_ino
Message-ID: <20191107082948.GA9802@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-22-hch@lst.de> <20191104203334.GW4153244@magnolia> <20191107010555.GT4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107010555.GT4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 05:05:55PM -0800, Darrick J. Wong wrote:
> > > +}
> > > +
> > > +void
> > > +xfs_dir2_sf_put_ino(
> 
> Also, I think these helpers can be static now...

xfs_dir2_sf_put_ino can and should be marked static.  xfs_dir2_sf_get_ino
is used elsewhere, though.
