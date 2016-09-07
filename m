Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36977 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbcIGWru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2016 18:47:50 -0400
Date: Thu, 8 Sep 2016 08:47:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/279: filter scsi debug device correctly
Message-ID: <20160907224747.GH22388@dastard>
References: <1473053427-15498-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473053427-15498-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org

On Mon, Sep 05, 2016 at 01:30:27PM +0800, Eryu Guan wrote:
> This test assumes scsi debug device is "/dev/sd." when doing the
> filter, but that isn't always true, I've seen failure like
> 
>   -mkfs with opts: DEVICE
>   +mkfs with opts: DEVICEl

Yeah, I can see how that would occur when you have enough scsi
devices to go to multiple device characters (e.g. /dev/sdal).

> So use $SCSI_DEBUG_DEV to match the correct scsi debug device name.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
