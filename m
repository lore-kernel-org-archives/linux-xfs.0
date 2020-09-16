Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BFBC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 00:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E980A21D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 00:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgIPAHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:07:35 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57485 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbgIPAHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 20:07:23 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D5E9F826956;
        Wed, 16 Sep 2020 10:07:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kIKyj-0005cM-7I; Wed, 16 Sep 2020 10:07:17 +1000
Date:   Wed, 16 Sep 2020 10:07:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <20200916000717.GY12131@dread.disaster.area>
References: <20200911164311.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911164311.GU7955@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=eXebqsI1vn0drh84A-wA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 09:43:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The V4 filesystem format contains known weaknesses in the on-disk format
> that make metadata verification diffiult.  In addition, the format will
> does not support dates past 2038 and will not be upgraded to do so.
> Therefore, we should start the process of retiring the old format to
> close off attack surfaces and to encourage users to migrate onto V5.
> 
> Therefore, make XFS V4 support a configurable option.  For the first
> period it will be default Y in case some distributors want to withdraw
> support early; for the second period it will be default N so that anyone
> who wishes to continue support can do so; and after that, support will
> be removed from the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: be a little more helpful about old xfsprogs and warn more loudly
> about deprecation
> v2: define what is a V4 filesystem, update the administrator guide
> ---
>  Documentation/admin-guide/xfs.rst |   23 +++++++++++++++++++++++
>  fs/xfs/Kconfig                    |   24 ++++++++++++++++++++++++
>  fs/xfs/xfs_super.c                |   13 +++++++++++++
>  3 files changed, 60 insertions(+)

I agree with the overall policy direction and that we should be
warning v4 filesystem users as early as possible.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
