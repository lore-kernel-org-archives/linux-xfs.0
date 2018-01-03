Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751007AbeACUhw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jan 2018 15:37:52 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v4 08/18] tools/testing/nvdimm: add 'bio_delay' mechanism
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
        <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
        <20180102214450.GU5858@dastard>
        <CAPcyv4iaSnWFd6qt52+TQ_k9Kwf1pXLq8GMHdtd-Hg_mvN6rvg@mail.gmail.com>
        <20180103154613.GL4911@quack2.suse.cz>
Date: Wed, 03 Jan 2018 15:37:50 -0500
In-Reply-To: <20180103154613.GL4911@quack2.suse.cz> (Jan Kara's message of
        "Wed, 3 Jan 2018 16:46:13 +0100")
Message-ID: <x49fu7mel0h.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

Jan Kara <jack@suse.cz> writes:

> On Tue 02-01-18 13:51:49, Dan Williams wrote:
>> On Tue, Jan 2, 2018 at 1:44 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Dec 23, 2017 at 04:56:43PM -0800, Dan Williams wrote:
>> >> In support of testing truncate colliding with dma add a mechanism that
>> >> delays the completion of block I/O requests by a programmable number of
>> >> seconds. This allows a truncate operation to be issued while page
>> >> references are held for direct-I/O.
>> >>
>> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> >
>> > Why not put this in the generic bio layer code and then write a
>> > generic fstest to exercise this truncate vs direct IO completion
>> > race condition on all types of storage and filesystems?
>> >
>> > i.e. if it sits in a nvdimm test suite, it's never going to be run
>> > by filesystem developers....
>> 
>> I do want to get it into xfstests eventually. I picked the nvdimm
>> infrastructure for expediency of getting the fix developed. Also, I
>> consider the collision in the non-dax case a solved problem since the
>> core mm will keep the page out of circulation indefinitely.
>
> Yes, but there are different races that could happen even for regular page
> cache pages. So I also think it would be worthwhile to have this inside the
> block layer possibly as part of the generic fault-injection framework which
> is already there for fail_make_request. That already supports various
> filtering, frequency, and other options that could be useful.

Or consider extending the dm-delay target (which delays the queuing of
bios) to support delaying the completions.  I'm not sure I'm a fan of
sticking all sorts of debug code into the generic I/O submission path.

Cheers,
Jeff
