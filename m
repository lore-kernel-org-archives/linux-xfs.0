Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56352C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10D7164EE4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZEYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:24:12 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60529 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhBZEYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 23:24:11 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C8FCD4EC789;
        Fri, 26 Feb 2021 15:23:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFUf0-004jBp-Re; Fri, 26 Feb 2021 15:23:26 +1100
Date:   Fri, 26 Feb 2021 15:23:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: embed the xlog_op_header in the unmount record
Message-ID: <20210226042326.GV4662@dread.disaster.area>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-5-david@fromorbit.com>
 <20210226025727.GO7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226025727.GO7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=jyTUhv0JJRFv05d8aE0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 06:57:27PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 24, 2021 at 05:34:50PM +1100, Dave Chinner wrote:
> > Subject: xfs: embed the xlog_op_header in the unmount record
> 
> Uh... isn't this embedding the xlog op header in the *commit* record?
> 
> (Just saying for my own lazy purposes because my scripts choke badly
> when a patchset has multiple patches with the same subject...)

Uh, yes. That's what I get for copy-pasta of the commit headers ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
