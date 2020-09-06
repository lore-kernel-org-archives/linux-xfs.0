Return-Path: <SRS0=Ptmy=CP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C66C433E2
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Sep 2020 21:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F36D20838
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Sep 2020 21:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIFVxv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Sep 2020 17:53:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39709 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726292AbgIFVxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Sep 2020 17:53:50 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 98C378248A0;
        Mon,  7 Sep 2020 07:53:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kF2bc-0006pD-0M; Mon, 07 Sep 2020 07:53:48 +1000
Date:   Mon, 7 Sep 2020 07:53:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
Message-ID: <20200906215347.GM12131@dread.disaster.area>
References: <20200903142839.72710-4-cmaiolino@redhat.com>
 <20200903161724.85328-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903161724.85328-1-cmaiolino@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=mQMKOM5orIrDlVyos-UA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 06:17:24PM +0200, Carlos Maiolino wrote:
> nameval is a variable-size array, so, define it as it, and remove all
> the -1 magic number subtractions
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 
> 	V2:
> 	 - Drop wrong change to XFS_ATTR_SF_ENTSIZE_MAX
> 	V3:
> 	- Use XFS_ATTR_SF_ENTSIZE_BYNAME in xfs_attr_shortform_allfit()
> 	- Remove int casting and fix spacing on
> 	  XFS_ATTR_SF_ENTSIZE_BYNAME
> 	V4:
> 	- Fix indentation on xfs_attr_shortform_allfit()
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 9 +++------
>  fs/xfs/libxfs/xfs_attr_sf.h   | 4 ++--
>  fs/xfs/libxfs/xfs_da_format.h | 2 +-
>  3 files changed, 6 insertions(+), 9 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
