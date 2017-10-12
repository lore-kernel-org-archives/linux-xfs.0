Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:47950 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbdJLBSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:18:55 -0400
Received: by mail-oi0-f51.google.com with SMTP id h200so6068653oib.4
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 18:18:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011224331.GB3666@dastard>
References: <20171011200603.27442-1-jack@suse.cz> <CAPcyv4g6tjyUy_zxVVze+C+xZiT89qa1GiSoVjhH3G-6r3eXDA@mail.gmail.com>
 <20171011224331.GB3666@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 18:18:54 -0700
Message-ID: <CAPcyv4iv7Tr2NPjWZbuq-4yTmrKpNikxnVWdt9PfZUp5JvF43w@mail.gmail.com>
Subject: Re: [PATCH 0/19 v3] dax, ext4, xfs: Synchronous page faults
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 3:43 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 11, 2017 at 02:18:06PM -0700, Dan Williams wrote:
>> On Wed, Oct 11, 2017 at 1:05 PM, Jan Kara <jack@suse.cz> wrote:
>> > Anyway, here are the patches and AFAICT the series is pretty much complete
>> > so we can start thinking how to merge this. Changes to ext4 / XFS are pretty
>> > minimal so either tree is fine I guess. Comments are welcome.
>>
>> I'd like to propose taking this through the nvdimm tree. Some of these
>> changes make the MAP_DIRECT support for ext4 easier, so I'd like to
>> rebase that support on top and carry both.
>
> This functionality needs to be exercised and stressed by fstests
> in some way before it gets merged.

Yes, and man page updates for mmap(2).
