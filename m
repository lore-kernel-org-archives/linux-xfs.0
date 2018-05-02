Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750939AbeEBUJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 16:09:59 -0400
Date: Wed, 2 May 2018 13:09:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/3 v3] iomap: Use FUA for O_DSYNC DIO writes
Message-ID: <20180502200951.GB4127@magnolia>
References: <20180502053807.13846-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502053807.13846-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On Wed, May 02, 2018 at 03:38:04PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> Version 3 of the FUA for O-DSYNC patchset. This version fixes bugs
> found in the previous version. Functionality is otherwise the same
> as described in the first version:
> 
> https://marc.info/?l=linux-xfs&m=152213446528167&w=2

Will test the whole series, consider this a tentative:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Version 3:
> 
> - fixed O_SYNC behaviour as noticed by Jan Kara
> - fixed use after free on IO completion due
>   iomap_dio_complete_work() simplification added in version 2. Found
>   by KASAN when running xfstests.
> 
> Version 2:
> - Fixed comment typos in first patch
> - simplified iomap_dio_complete_work()
> - changed IOMAP_DIO_WRITE_SYNC to IOMAP_DIO_NEED_SYNC
> - split blk_queue_fua() into it's own patch
> - fixed formatting issue in last patch
> - update bio->io_opf directly rather than use bio_set_op_attrs()
> - Updated comment to mention we try to use FUA optimistically.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
