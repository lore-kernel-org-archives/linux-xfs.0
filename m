Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49774 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdKUCQL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 21:16:11 -0500
Subject: Re: [PATCH] xfs: abstract out dev_t conversions
References: <20171120093356.16355-1-hch@lst.de>
 <20171121014832.GA2135@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6f6b1348-6329-a539-09e8-9a29fb3bf227@sandeen.net>
Date: Mon, 20 Nov 2017 20:16:09 -0600
MIME-Version: 1.0
In-Reply-To: <20171121014832.GA2135@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>



On 11/20/17 7:48 PM, Darrick J. Wong wrote:
> On Mon, Nov 20, 2017 at 10:33:56AM +0100, Christoph Hellwig wrote:
>> And move them to xfs_linux.h so that xfsprogs can stub them out more
>> easily.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, but I want Eric to have a quick look at this because he's the
> stuckee on this one. :P
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm probably slow but I'm seeing neither big problems nor big solutions
from this patch; IOWS - fine by me?  :)

-Eric
