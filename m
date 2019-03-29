Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbfC2Oek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:34:40 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
        <20190329142346.1677-3-bob.liu@oracle.com>
        <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
Date: Fri, 29 Mar 2019 10:34:14 -0400
In-Reply-To: <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk> (Jens Axboe's
        message of "Fri, 29 Mar 2019 08:28:23 -0600")
Message-ID: <yq1ftr5rbq1.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu


Jens,

> I told you this for the initial posting, and the objection still
> stands.  Adding 40 bytes to struct bio is a no-go.
>
> So that's a big NAK on that series.

I think you missed Bob's comment that this will go in the existing
bio_integrity field. I believe the main purpose of the series is to
solicit feedback on the callback approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
