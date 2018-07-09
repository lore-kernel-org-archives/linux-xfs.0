Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754317AbeGICIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 22:08:54 -0400
Subject: Re: [PATCH RFC 4/8] xfs: implement inline data read write code
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-5-git-send-email-shan.hai@oracle.com>
 <20180708154520.GB8625@infradead.org>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <84b33ebf-041a-643d-befb-bcc867b18b93@oracle.com>
Date: Mon, 9 Jul 2018 10:08:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180708154520.GB8625@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 2018年07月08日 23:45, Christoph Hellwig wrote:
> On Fri, Jul 06, 2018 at 11:12:25AM +0800, Shan Hai wrote:
>> Implement read/write functions for inline data access and use them
>> for buffered/DIO/DAX operations.
> Please use the iomap inline handling in this branch instead of
> implementing it in XFS:
>
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=iomap-4.19-merge

OK, I will base the patches on the iomap inline handling code.

> It seems like your code doesn't use the page cache for inline data
> at the moment, which means you'd want to always use the direct I/O
> version of the code as-is.

Yes, the read path uses direct I/O version while the write is not.

> Althought that makes me wonder how you handle memory mapped I/O, but
> I guess I'll find out later.

I will use page cache to handle the mmap case, thanks for the review.

Thanks
Shan Hai
