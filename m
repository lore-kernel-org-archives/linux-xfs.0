Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F3CC433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 00:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B8323125
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 00:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404848AbhAMAnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:43:00 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37036 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390214AbhALXo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 18:44:26 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 465DC5358E2;
        Wed, 13 Jan 2021 10:43:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kzTKB-005qm3-Nu; Wed, 13 Jan 2021 10:43:43 +1100
Date:   Wed, 13 Jan 2021 10:43:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bastien Traverse <bastien@esrevart.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] xfs_corruption_error after creating a swap file
Message-ID: <20210112234343.GE331610@dread.disaster.area>
References: <TMAUMQ.RILVCKL2FQ501@esrevart.net>
 <20210112222558.GV331610@dread.disaster.area>
 <VFFUMQ.9RG39DGXEE5F@esrevart.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VFFUMQ.9RG39DGXEE5F@esrevart.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=8nJEP1OIZ-IA:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8 a=Br9LfDWDAAAA:8
        a=TV3IVOb-i5mnMEjndI0A:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
        a=gR_RJRYUad_6_ruzA8cR:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 12, 2021 at 11:50:19PM +0100, Bastien Traverse wrote:
> Le mer. 13 janv. 2021 à 9:25, Dave Chinner <david@fromorbit.com> a
> écrit :
> 
> > But I thought that was fixed in 5.9-rc7 so should be in your
> > kernel.  Can you confirm that your kernel has this fix?
> 
> This commit does appear in Arch kernel repo, so I can only suppose
> it's in:
> https://git.archlinux.org/linux.git/commit/?id=41663430588c737dd735bad5a0d1ba325dcabd59
> 
> Arch tends to stay close to upstream and I am using the standard
> kernel.

Ok. Given that xfs_repair apparently found and corrected some
corruption and it hasn't happened since, I'm not sure that there is
much we can go on here. It may have been a pre-existing corruption,
and the swapfile thing is a red herring. If it happens again, let us
know and we can see if we can get more information out of your
system about it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
