Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:45574 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754288AbdIRPvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:51:32 -0400
Received: by mail-io0-f175.google.com with SMTP id g32so3196948ioj.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 08:51:32 -0700 (PDT)
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
 fs/iomap.c:993
References: <1505746565.6990.18.camel@abdul.in.ibm.com>
 <20170918152706.GA11482@lst.de>
 <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
 <20170918153947.GA12635@lst.de> <20170918154328.GA32076@ZenIV.linux.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <955c9c41-1941-5cf4-751c-14a3efa9d0ce@kernel.dk>
Date: Mon, 18 Sep 2017 09:51:29 -0600
MIME-Version: 1.0
In-Reply-To: <20170918154328.GA32076@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On 09/18/2017 09:43 AM, Al Viro wrote:
> On Mon, Sep 18, 2017 at 05:39:47PM +0200, Christoph Hellwig wrote:
>> On Mon, Sep 18, 2017 at 09:28:55AM -0600, Jens Axboe wrote:
>>> If it's expected, why don't we kill the WARN_ON_ONCE()? I get it all
>>> the time running xfstests as well.
>>
>> Dave insisted on it to decourage users/applications from mixing
>> mmap and direct I/O.
>>
>> In many ways a tracepoint might be the better way to diagnose these.
> 
> sysctl suppressing those two, perhaps?

I'd rather just make it a trace point, but don't care too much.

The code doesn't even have a comment as to why that WARN_ON() is
there or expected. Seems pretty sloppy to me, not a great way
to "discourage" users to mix mmap/dio.

-- 
Jens Axboe

