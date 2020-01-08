Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BCEC33CA1
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 21:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 406E220705
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 21:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgAHVvY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 16:51:24 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34028 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726390AbgAHVvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 16:51:24 -0500
Received: from dread.disaster.area (pa49-180-68-255.pa.nsw.optusnet.com.au [49.180.68.255])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2593F3A8398;
        Thu,  9 Jan 2020 08:51:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ipJEW-0005xS-Ri; Thu, 09 Jan 2020 08:51:20 +1100
Date:   Thu, 9 Jan 2020 08:51:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make struct xfs_buf_log_format have a
 consistent size
Message-ID: <20200108215120.GG23128@dread.disaster.area>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845710512.84011.14528616369807048509.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845710512.84011.14528616369807048509.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=sbdTpStuSq8iNQE8viVliQ==:117 a=sbdTpStuSq8iNQE8viVliQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=7lLPb1Qor35v-PoGTg4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 08:18:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
> end of struct xfs_buf_log_format.  This makes the size consistent so
> that we can check it in xfs_ondisk.h, and will be needed once we start
> logging attribute values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |    9 +++++----
>  fs/xfs/xfs_ondisk.h            |    1 +
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 8ef31d71a9c7..5d8eb8978c33 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -462,11 +462,12 @@ static inline uint xfs_log_dinode_size(int version)
>  #define	XFS_BLF_GDQUOT_BUF	(1<<4)
>  
>  /*
> - * This is the structure used to lay out a buf log item in the
> - * log.  The data map describes which 128 byte chunks of the buffer
> - * have been logged.
> + * This is the structure used to lay out a buf log item in the log.  The data
> + * map describes which 128 byte chunks of the buffer have been logged.  Note
> + * that XFS_BLF_DATAMAP_SIZE is an odd number so that the structure size will
> + * be consistent between 32-bit and 64-bit platforms.
>   */
> -#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
> +#define XFS_BLF_DATAMAP_SIZE	(1 + ((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD))

Shouldn't this do something like:

#define __XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
#define XFS_BLF_DATAMAP_SIZE	(__XFS_BLF_DATAMAP_SIZE + (__XFS_BLF_DATAMAP_SIZE & 1))

or use an appropriate round up macro so that if we change the log
chunk size or the max block size, it still evaluates correctly for
all platforms?

/me has prototype patches around somewhere that change
XFS_BLF_CHUNK...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
