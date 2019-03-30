Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49842 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730001AbfC3CRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 22:17:45 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
        <20190329142346.1677-3-bob.liu@oracle.com>
        <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
        <yq1ftr5rbq1.fsf@oracle.com>
        <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk>
        <yq1bm1trb4y.fsf@oracle.com>
        <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk>
        <yq17echrax1.fsf@oracle.com>
        <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
        <c9adb48c-7b6e-2017-9480-aa2342b3523b@oracle.com>
        <7599b239-46f4-9799-a87a-3ca3891d4a08@kernel.dk>
Date: Fri, 29 Mar 2019 22:17:22 -0400
In-Reply-To: <7599b239-46f4-9799-a87a-3ca3891d4a08@kernel.dk> (Jens Axboe's
        message of "Fri, 29 Mar 2019 09:03:47 -0600")
Message-ID: <yq1imw1p0lp.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Bob Liu <bob.liu@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu


Jens,

> You will not need a callback in the bio, you will just have a private
> end_io function for that particular bio that does the verification.

The saving grace for the integrity stuff is that once all the child bios
complete, we no longer care about their completion context and we have
the parent bio submitted by the filesystem we can use to verify the PI
against.

For the redundant copy use case, however, I am guessing that the
filesystem folks would want the same thing. I.e. verify the structure of
the data received once the parent bio completes. However, at that point
all the slicing and dicing completion state is lost. And thus there is
no way to know that the failure was due to mirror B two layers down the
stack. Nor is there any way to retry the I/O without having recorded a
completion breadcrumb trail for every child bio.

The other approach is the callback where each stacking layer--which
knows about redundancy--can do verification of a bio upon completion.
However, that suffers from another headache in that the I/O can get
arbitrarily sliced and diced in units of 512 bytes. And thus the
filesystem verification function would have to be able to verify an
arbitrary multiple of 512 bytes at any 512-byte offset inside a
submitted bio. That would work, but I don't think that's the pony the
filesystem were wishing for?

-- 
Martin K. Petersen	Oracle Linux Engineering
