Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D8CC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 22:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB4D0206EB
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 22:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHYWlr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:41:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53341 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgHYWlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 18:41:47 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 33E3A8233CE;
        Wed, 26 Aug 2020 08:41:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAhdQ-0000X5-Fm; Wed, 26 Aug 2020 08:41:44 +1000
Date:   Wed, 26 Aug 2020 08:41:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <20200825224144.GS12131@dread.disaster.area>
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=9fyAema9bXBvwAnuQNcA:9 a=MhcgDuqDX5QtXdhj:21 a=U7NfGzJuHbRGv60s:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 03:25:29PM -0500, Eric Sandeen wrote:
> The boundary test for the fixed-offset parts of xfs_attr_sf_entry
> in xfs_attr_shortform_verify is off by one.  endp is the address
> just past the end of the valid data; to check the last byte of
> a structure at offset of size "size" we must subtract one.
> (i.e. for an object at offset 10, size 4, last byte is 13 not 14).
> 
> This can be shown by:
> 
> # touch file
> # setfattr -n root.a file
> 
> and subsequent verifications will fail when it's reread from disk.
> 
> This only matters for a last attribute which has a single-byte name
> and no value, otherwise the combination of namelen & valuelen will
> push endp out and this test won't fail.
> 
> Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8623c815164a..a0cf22f0c904 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1037,7 +1037,7 @@ xfs_attr_shortform_verify(
>  		 * Check the fixed-offset parts of the structure are
>  		 * within the data buffer.
>  		 */
> -		if (((char *)sfep + sizeof(*sfep)) >= endp)
> +		if (((char *)sfep + sizeof(*sfep)-1) >= endp)

whitespace? And a comment explaining the magic "- 1" would be nice.

Did you audit the code for other occurrences of this same problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
