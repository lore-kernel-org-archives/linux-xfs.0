Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665A9C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 22:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C9762065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 22:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGOWWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:22:21 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51616 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgGOWWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 18:22:21 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A64533A5012;
        Thu, 16 Jul 2020 08:22:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jvpn6-0000jd-PS; Thu, 16 Jul 2020 08:22:16 +1000
Date:   Thu, 16 Jul 2020 08:22:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] repair: use fs root ino for dummy parent value
 instead of zero
Message-ID: <20200715222216.GH2005@dread.disaster.area>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-4-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=KtKK4JjewA-TjXlTmhAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:35AM -0400, Brian Foster wrote:
> If a directory inode has an invalid parent ino on disk, repair
> replaces the invalid value with a dummy value of zero in the buffer
> and NULLFSINO in the in-core parent tracking. The zero value serves
> no functional purpose as it is still an invalid value and the parent
> must be repaired by phase 6 based on the in-core state before the
> buffer can be written out.  Instead, use the root fs inode number as
> a catch all for invalid parent values so phase 6 doesn't have to
> create custom verifier infrastructure just to work around this
> behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reasonale, but wouldn't it be better to use lost+found as the dummy
parent inode (i.e. the orphanage inode)? Because if the parent can't
be found and the inode reconnected correctly, we're going to put it
in lost+found, anyway?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
