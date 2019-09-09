Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0604C4740C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 23:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67F121670
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 23:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbfIIXgV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 19:36:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58301 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730067AbfIIXgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Sep 2019 19:36:21 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C658143CF9C;
        Tue, 10 Sep 2019 09:36:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i7TCj-0006Kv-BB; Tue, 10 Sep 2019 09:36:17 +1000
Date:   Tue, 10 Sep 2019 09:36:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] libfrog: share scrub headers
Message-ID: <20190909233617.GG16973@dread.disaster.area>
References: <156774080205.2643094.9791648860536208060.stgit@magnolia>
 <156774081444.2643094.5994336399369294046.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774081444.2643094.5994336399369294046.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:33:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_io and xfs_scrub have nearly identical structures to describe scrub
> types.  Combine them into a single header file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/scrub.c       |   89 ++++++++++------------------------
>  libfrog/Makefile |    2 +
>  libfrog/scrub.c  |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  libfrog/scrub.h  |   29 +++++++++++
>  scrub/scrub.c    |  141 +++++++++++++++---------------------------------------
>  5 files changed, 238 insertions(+), 163 deletions(-)
>  create mode 100644 libfrog/scrub.c
>  create mode 100644 libfrog/scrub.h

Looks fine. Not sure we needed all the xfrog prefixes, but getting
this into common code is still a win.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
