Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:49269 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbdIWSXV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Sep 2017 14:23:21 -0400
Received: by mail-wm0-f51.google.com with SMTP id r74so10623677wme.4
        for <linux-xfs@vger.kernel.org>; Sat, 23 Sep 2017 11:23:20 -0700 (PDT)
Subject: Re: io_submit() blocks for writes for substantial amount of time
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <20170919145827.GA21523@infradead.org>
 <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
 <20170919173955.GB8139@dhcp-41-131.bos.redhat.com>
 <ba7a108e-733e-419d-9839-545bc04e0caf@scylladb.com>
 <20170920105021.GA16036@bfoster.bfoster>
 <8b7b0822-9d57-4fc9-d55f-b0f94d8a5cbd@scylladb.com>
 <20170920144936.GA12638@infradead.org>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <55454c5a-dc27-64e3-2bfd-d257c924dbc4@scylladb.com>
Date: Sat, 23 Sep 2017 21:23:16 +0300
MIME-Version: 1.0
In-Reply-To: <20170920144936.GA12638@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-aio@kvack.org



On 09/20/2017 05:49 PM, Christoph Hellwig wrote:
> On Wed, Sep 20, 2017 at 02:11:49PM +0300, Avi Kivity wrote:
>> I think it's still preferable to avoid a workqueue and its non-deterministic
>> latencies and context switches if we can prove that a particular iocb will
>> not require a synchronous operation. If that can be done then 4.13 nowait
>> aio also works - the user provides the workqueue equivalent. The only
>> problem is if we can't prove in advance that an iocb will require blocking.
> The code is generally pessimistic and bails out rather too often.
> The only issue not solved is memory allocation, at the moment we could
> still block on them so this will need some more work.  For XFS direct
> I/O the only memory allocations in that path should be the bios.

I think we can ignore blocking on memory allocation. It affects all 
system calls and even just regular user memory access - if you're 
starved for memory you're likely to have text and data pages swapped 
out. An application that wants aio should be prepared to avoid starving 
the kernel for memory.

>
>>   1. Short writes - just ignore the tail of a too-large iovec. May cause
>> buggy applications to fail, so probably not a good idea.
> We could still do it the same way we did RWF_NOWAIT - require an
> explicit opt-in for what should be the defalt behavior because we
> change the historic behavior.

Yes.

