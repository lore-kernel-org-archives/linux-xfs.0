Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE78FC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 08:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4AFB2071C
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 08:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgCLISb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 04:18:31 -0400
Received: from verein.lst.de ([213.95.11.211]:35390 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLISa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Mar 2020 04:18:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8726E68C65; Thu, 12 Mar 2020 09:18:27 +0100 (CET)
Date:   Thu, 12 Mar 2020 09:18:27 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 5.5 XFS getdents regression?
Message-ID: <20200312081827.GA10247@lst.de>
References: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com> <20200310221406.GO10776@dread.disaster.area> <862b6c718957aff7156bf04964b7242f5075e8a7.camel@nokia.com> <20200311172234.GA26340@lst.de> <1a10a2ec66bd9c72ef317f7a0834b30e6b739e8e.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a10a2ec66bd9c72ef317f7a0834b30e6b739e8e.camel@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 08:09:53AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> > Thanks, this looks good.  Although I wonder if the slightly different
> > version below might be a little more elegant?
> 
> Yes that's better indeed, thanks!

As this is just a slight tweak on all your work, can you submit it with
your signoff and a Fixes a tag?  Thanks for all your work!

