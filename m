Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:37548 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdIKPh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 11:37:59 -0400
Received: by mail-io0-f175.google.com with SMTP id j141so28652625ioj.4
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2017 08:37:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170911151610.GA5014@linux.intel.com>
References: <20170908152805.GA16646@linux.intel.com> <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170911151610.GA5014@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Sep 2017 08:37:58 -0700
Message-ID: <CAPcyv4gGpAW7kUCgqSoNCPkFZVYzTVQi3C4x6AFm2KHvFrZSfw@mail.gmail.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Mon, Sep 11, 2017 at 8:16 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Sep 08, 2017 at 03:21:53PM -0600, Ross Zwisler wrote:
>> This adds a regression test for the following kernel patch:
>>
>>   xfs: always use DAX if mount option is used
>>
>> This test will also pass with kernel v4.14-rc1 and beyond because the XFS
>> DAX I/O mount option has been disabled (but not removed), so the
>> "chattr -x" to turn off DAX doesn't actually do anything.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Suggested-by: Christoph Hellwig <hch@infradead.org>
>
> <>
>
>> +# disable tracing, clear the existing trace buffer and turn on dax tracepoints
>> +echo 0 > /sys/kernel/debug/tracing/tracing_on
>> +echo > /sys/kernel/debug/tracing/trace
>> +echo 1 > /sys/kernel/debug/tracing/events/fs_dax/enable
>
> I think I can do a better job of:
>
> a) detecting whether debugfs is present, and if not just bail the test as not
> run
>
> b) recording the current state of the debugfs (tracing_on, fs_dax/enable),
> doing what I need to do, then restoring the previous state.
>
> Before I work on a v2, though, I'd love to get feedback on whether or not
> using tracepoints is okay in fstests.

I think it is more straightforward to use "perf record -e fs_dax
$test". Then you know the events are filtered to your test pid and you
don't need to worry about managing the trace interface.
