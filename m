Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9A1C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 01:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiESBif (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 21:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiESBie (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 21:38:34 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90FF466CB2
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:38:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D5786534590;
        Thu, 19 May 2022 11:38:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrV7X-00Dfj9-Lv; Thu, 19 May 2022 11:38:31 +1000
Date:   Thu, 19 May 2022 11:38:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: don't leak the retained da state when doing a
 leaf to node conversion
Message-ID: <20220519013831.GX1098723@dread.disaster.area>
References: <165290007585.1646028.11376304341026166988.stgit@magnolia>
 <165290008743.1646028.12364052366051039965.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290008743.1646028.12364052366051039965.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62859f98
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=AZ6yqByyfInqmaRJMS8A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:54:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a setxattr operation finds an xattr structure in leaf format, adding
> the attr can fail due to lack of space and hence requires an upgrade to
> node format.  After this happens, we'll roll the transaction and
> re-enter the state machine, at which time we need to perform a second
> lookup of the attribute name to find its new location.  This lookup
> attaches a new da state structure to the xfs_attr_item but doesn't free
> the old one (from the leaf lookup) and leaks it.  Fix that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
