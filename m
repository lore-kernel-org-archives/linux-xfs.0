Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr690092.outbound.protection.outlook.com ([40.107.69.92]:12640
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389053AbfBRR5D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Feb 2019 12:57:03 -0500
Date: Mon, 18 Feb 2019 12:56:51 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [RFC PATCH v2 1/9] block: add nr_mirrors to request_queue
Message-ID: <20190218175651.GA5210@mit.edu>
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190213095044.29628-2-bob.liu@oracle.com>
 <20190213160408.GW23000@mit.edu>
 <56d2dc78-01f8-9991-9199-372fe864d9f0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <56d2dc78-01f8-9991-9199-372fe864d9f0@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

On Thu, Feb 14, 2019 at 01:57:20PM +0800, Bob Liu wrote:
> 
> Now the initial/default value is 1 indicating only one copy of data.
> Would nr_copy be more accurate?
>

Well, it's at least shorter; the problem is that it's not really
another "copy" of the data, it's just that it can simply be different
(multiple) ways of reconstructing the data.  I suppose we could say
that it's a virtual copy.

In any case, I can't think of a better term, so nr_copy is probably as
good as any.

Cheers,

					- Ted
					
