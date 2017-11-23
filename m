Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49411 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbdKWLfY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 06:35:24 -0500
Subject: Re: [PATCH] xfs: Don't trim extents for fiemap
References: <1511424369-28740-1-git-send-email-nborisov@suse.com>
 <20171123081504.GB24556@infradead.org>
 <480e7347-fac1-12c0-f64b-f95d40f49366@suse.com>
 <20171123083019.GA20221@infradead.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <01f6e885-d320-420c-c3dd-d8cc2c9c4d09@suse.com>
Date: Thu, 23 Nov 2017 13:35:22 +0200
MIME-Version: 1.0
In-Reply-To: <20171123083019.GA20221@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com, darrick.wong@oracle.com



On 23.11.2017 10:30, Christoph Hellwig wrote:
> On Thu, Nov 23, 2017 at 10:28:39AM +0200, Nikolay Borisov wrote:
>> What you are saying is that iomap currently always trims the returned
>> range from the underlying filesystem so doing trimming in the fs is
>> redundant and I can just pass XFS_BMAPI_ENTIRE indiscriminately ?
> 
> I think so.  But the theory needs proper valiation first, so please
> do a full test run with that change.
> 

Right, so no new failures introduced by always passing XFS_BMAP_ENTIRE
so I will resend the patch.
