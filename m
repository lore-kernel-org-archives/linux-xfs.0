Return-Path: <SRS0=cq6/=WO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2167C3A589
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 07:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A293420851
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 07:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfHRHlp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 03:41:45 -0400
Received: from verein.lst.de ([213.95.11.211]:38750 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfHRHlo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 18 Aug 2019 03:41:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4B1D7227A81; Sun, 18 Aug 2019 09:41:41 +0200 (CEST)
Date:   Sun, 18 Aug 2019 09:41:40 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190818074140.GA18648@lst.de>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com> <20190818071128.GA17286@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818071128.GA17286@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 18, 2019 at 09:11:28AM +0200, hch@lst.de wrote:
> > The kernel log shows the following when the mount fails:
> 
> Is it always that same message?  I'll see if I can reproduce it,
> but I won't have that much memory to spare to create fake pmem,
> hope this also works with a single device and/or less memory..

I've reproduced a similar ASSERT with a small pmem device, so I hope
I can debug the issue locally now.
