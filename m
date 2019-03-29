Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51616 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbfC2OmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:42:10 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-3-bob.liu@oracle.com>
 <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk> <yq1ftr5rbq1.fsf@oracle.com>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <c3c942f4-8006-37fe-5996-458526c51254@oracle.com>
Date: Fri, 29 Mar 2019 22:41:37 +0800
MIME-Version: 1.0
In-Reply-To: <yq1ftr5rbq1.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On 3/29/19 10:34 PM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> I told you this for the initial posting, and the objection still
>> stands.  Adding 40 bytes to struct bio is a no-go.
>>
>> So that's a big NAK on that series.
> 
> I think you missed Bob's comment that this will go in the existing
> bio_integrity field. I believe the main purpose of the series is to
> solicit feedback on the callback approach.
> 

Yes, indeed!
