Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D05C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 20:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 700732072E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 20:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgI2UuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:50:17 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52174 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728362AbgI2UuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 16:50:17 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 26B783AA052;
        Wed, 30 Sep 2020 06:50:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kNMZf-0000oc-Qk; Wed, 30 Sep 2020 06:50:11 +1000
Date:   Wed, 30 Sep 2020 06:50:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] xfs: temporary transaction subsystem freeze hack
Message-ID: <20200929205011.GJ14422@dread.disaster.area>
References: <20200929141228.108688-1-bfoster@redhat.com>
 <20200929141228.108688-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929141228.108688-3-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=7-415B0cAAAA:8
        a=whRKckYn8ajBSlj6Os4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:12:27AM -0400, Brian Foster wrote:
> Implement a quick hack to abuse the superblock freeze mechanism to
> freeze the XFS transaction subsystem.
> 
> XXX: to be replaced

What was wrong with the per-cpu counter that I used in the prototype
I sent? Why re-invent the wheel?

Also, can we call this a pause/resume operation so it doesn't get
confused with filesystem freezing? Freezing as operation name is way
too overloaded already...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
