Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr770137.outbound.protection.outlook.com ([40.107.77.137]:6064
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729649AbfBMQE7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Feb 2019 11:04:59 -0500
Date: Wed, 13 Feb 2019 11:04:08 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [RFC PATCH v2 1/9] block: add nr_mirrors to request_queue
Message-ID: <20190213160408.GW23000@mit.edu>
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190213095044.29628-2-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190213095044.29628-2-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

On Wed, Feb 13, 2019 at 05:50:36PM +0800, Bob Liu wrote:
> @nr_mirrors is 1 by default which means only one copy, drivers e.g raid1 are
> responsible for setting the right value. The maximum value is
> BITS_PER_LONG which is 32 or 64. That should be big enough else retry lantency
> may be too high.

This is admittedly bike-shedding, so feel free to ignore, but...

In the case of Raid 6, "mirrors" will be a bit of a misnomer.  Would
"nr_recovery" be better?

Thanks for working on this!!  I would be interested in using this for
ext4 once it's available.

				- Ted
