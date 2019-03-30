Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730388AbfC3BoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 21:44:12 -0400
Subject: Re: [PATCH v3 1/3] block: introduce submit_bio_verify()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
        <20190329142346.1677-2-bob.liu@oracle.com>
        <0FA09E34-400A-473D-9F3A-3014F79B2A82@dilger.ca>
Date: Fri, 29 Mar 2019 21:43:48 -0400
In-Reply-To: <0FA09E34-400A-473D-9F3A-3014F79B2A82@dilger.ca> (Andreas
        Dilger's message of "Fri, 29 Mar 2019 16:22:18 -0600")
Message-ID: <yq1muldp25n.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Martin Petersen <martin.petersen@oracle.com>, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, axboe@kernel.dk, tytso@mit.edu


Andreas,

> How does this interact (if at all) with bio_integrity_verify() code?
> Does it mean if e.g. XFS is on storage with T10-PI that only one or
> the other can be used,

Yes. Although if your storage is sophisticated enough to be T10 PI
capable, you are probably using redundancy inside the array and
therefore not MD.

But I think there are other problems with the callback approach. See my
impending email.

-- 
Martin K. Petersen	Oracle Linux Engineering
