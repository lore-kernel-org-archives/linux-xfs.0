Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44844 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbeCVW6b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 18:58:31 -0400
Subject: Re: [PATCH 1/2] workqueue: add missing pthreads header
From: Eric Sandeen <sandeen@sandeen.net>
References: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
 <20180316053016.GB1757@magnolia> <20180316060846.imxc42urbsb222sn@tarshish>
 <f0d6ee15-70d8-57c1-2b68-1d6b69f309ff@sandeen.net>
Message-ID: <ab844cf6-6a77-1703-4a9b-8411bfd6acfa@sandeen.net>
Date: Thu, 22 Mar 2018 17:58:29 -0500
MIME-Version: 1.0
In-Reply-To: <f0d6ee15-70d8-57c1-2b68-1d6b69f309ff@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Baruch Siach <baruch@tkos.co.il>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/22/18 5:05 PM, Eric Sandeen wrote:
> On 3/16/18 1:08 AM, Baruch Siach wrote:

...

>>> Our convention within xfsprogs sources (I think) is for most header
>>> files to avoid having headers include other headers.  Would you mind
>>> adding this include to read_verify.c instead?
>>
>> I don't mind. But requiring every user of workqueue.h to remember to have 
>> pthread.h before, is error prone IMO.
>>
>>> (That said, you probably ought to wait for the maintainer (Eric) to
>>> weigh in on this before you do any more work.)
> 
> Sorry for the late reply.
> 
> Eh, I think I'm inclined to just take this as-is, I don't see a downside to it.

Actually now I'm on the fence, half of scrub already includes pthread.h directly :/

How many C files would need to include pthread.h to get the build going?

And, um, how can we get ourselves out of this "break musl, rinse, repeat" cycle?

-Eric
