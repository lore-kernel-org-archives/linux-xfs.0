Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91853C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C979206BE
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgETHMh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 03:12:37 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:38575 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgETHMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 03:12:36 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 8A9B0D589A0;
        Wed, 20 May 2020 17:12:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbIty-0003XD-TB; Wed, 20 May 2020 17:12:30 +1000
Date:   Wed, 20 May 2020 17:12:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Message-ID: <20200520071230.GV2040@dread.disaster.area>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-2-david@fromorbit.com>
 <20200520065743.GC25811@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520065743.GC25811@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=GgGVpSEah5DJhDrGqboA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 11:57:43PM -0700, Christoph Hellwig wrote:
> Shouldn't m_errortag and m_errortag_kobj also go into the read-mostly
> section?
> 
> Otherwise looks good:

kobjs are reference counted and full of random stuff like lists,
sysfs references, etc, so they aren't obviously read-mostly
variables. I left all the kobjs in the write section for
this reason. The errortag stuff is also debug only code so I didn't
so I didn't bother touching it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
