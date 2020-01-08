Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905F2C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 07:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 682DB2075D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 07:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgAHHEj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:04:39 -0500
Received: from verein.lst.de ([213.95.11.211]:47767 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgAHHEi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Jan 2020 02:04:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2989168C65; Wed,  8 Jan 2020 08:04:36 +0100 (CET)
Date:   Wed, 8 Jan 2020 08:04:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: attr fixes
Message-ID: <20200108070435.GA2973@lst.de>
References: <20200107165442.262020-1-hch@lst.de> <20200107232346.GH917713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107232346.GH917713@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 03:23:46PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 07, 2020 at 05:54:38PM +0100, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series contains a bunch of fixes for nasty bugs in the attr interface.
> 
> Hm, do you want to throw in the ATTR_INCOMPLETE killing patch (#5 in the
> old series) too?

That isn't really an urgent fix.  With the kernel-only flags clearing
it can't cause any harm.
