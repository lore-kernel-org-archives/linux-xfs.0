Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:41050 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeABVvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 16:51:50 -0500
Received: by mail-oi0-f67.google.com with SMTP id t78so34084573oie.8
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2018 13:51:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180102214450.GU5858@dastard>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102214450.GU5858@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jan 2018 13:51:49 -0800
Message-ID: <CAPcyv4iaSnWFd6qt52+TQ_k9Kwf1pXLq8GMHdtd-Hg_mvN6rvg@mail.gmail.com>
Subject: Re: [PATCH v4 08/18] tools/testing/nvdimm: add 'bio_delay' mechanism
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Tue, Jan 2, 2018 at 1:44 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Dec 23, 2017 at 04:56:43PM -0800, Dan Williams wrote:
>> In support of testing truncate colliding with dma add a mechanism that
>> delays the completion of block I/O requests by a programmable number of
>> seconds. This allows a truncate operation to be issued while page
>> references are held for direct-I/O.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Why not put this in the generic bio layer code and then write a
> generic fstest to exercise this truncate vs direct IO completion
> race condition on all types of storage and filesystems?
>
> i.e. if it sits in a nvdimm test suite, it's never going to be run
> by filesystem developers....

I do want to get it into xfstests eventually. I picked the nvdimm
infrastructure for expediency of getting the fix developed. Also, I
consider the collision in the non-dax case a solved problem since the
core mm will keep the page out of circulation indefinitely.
