Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbfC2OrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:47:09 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
        <20190329142346.1677-3-bob.liu@oracle.com>
        <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
        <yq1ftr5rbq1.fsf@oracle.com>
        <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk>
Date: Fri, 29 Mar 2019 10:46:53 -0400
In-Reply-To: <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk> (Jens Axboe's
        message of "Fri, 29 Mar 2019 08:38:04 -0600")
Message-ID: <yq1bm1trb4y.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu


Jens,

> I didn't miss that, but it fixes nothing. That will unify the 40 bytes
> with 8 bytes, we're still growing the bio by a LOT. And we can't even
> nicely hide this behind some ifdef, sine distros enable everything and
> hence we're solving nothing by doing that.

We'll just need to handle it exactly like the integrity stuff. We only
allocate the extra bits when the underlying device indicates that it's
required and desired.

-- 
Martin K. Petersen	Oracle Linux Engineering
