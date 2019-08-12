Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLT1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:27:07 -0400
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 00/18] Delayed Attributes
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190812081954.GA9484@infradead.org>
Message-ID: <1d0ff885-53a7-e29d-dda8-17017399aab5@oracle.com>
Date: Mon, 12 Aug 2019 12:26:54 -0700
MIME-Version: 1.0
In-Reply-To: <20190812081954.GA9484@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 1:19 AM, Christoph Hellwig wrote:
> Btw, this seems like the right series to also look into our problem
> that large attributes are not updated transactionally.  We just do
> a synchronous write (xfs_bwrite) for them but don't include them
> in the transaction.  With the deferred operations and rolled
> transactions that should be fairly easy to fix.
> 
Ah, alrighty then.  I will add that into the cover letter next time as
another possible use case for it.  :-)

Thx!
Allison
