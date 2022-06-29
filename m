Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F47C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 04:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiF2EPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 00:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiF2EPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 00:15:53 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDC932EB;
        Tue, 28 Jun 2022 21:15:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4A6BB5ED0C7;
        Wed, 29 Jun 2022 14:15:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6P7D-00CKlQ-VK; Wed, 29 Jun 2022 14:15:47 +1000
Date:   Wed, 29 Jun 2022 14:15:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/9] xfs/070: filter new superblock verifier messages
Message-ID: <20220629041547.GO1098723@dread.disaster.area>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768886.1045534.3177166462110135738.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644768886.1045534.3177166462110135738.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bbd1f7
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=m0gk1XkFkLXUBxkiEX0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:21:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In Linux 5.19, the superblock verifier logging changed to elaborate on
> what was wrong.  Fix the xfs_repair filtering function to accomodate
> this development.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/repair |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/common/repair b/common/repair
> index 463ef9db..398e9904 100644
> --- a/common/repair
> +++ b/common/repair
> @@ -29,6 +29,7 @@ _filter_repair()
>  # for sb
>  /- agno = / && next;	# remove each AG line (variable number)
>  s/(pointer to) (\d+)/\1 INO/;
> +s/Superblock has bad magic number.*/bad magic number/;
>  # Changed inode output in 5.5.0
>  s/sb root inode value /sb root inode /;
>  s/realtime bitmap inode value /realtime bitmap inode /;

Didn't I already fix that in commit 4c76d0ba ("xfs/070: filter the
bad sb magic number error")?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
