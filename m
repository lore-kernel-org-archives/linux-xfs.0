Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:44006 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbdJKCMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 22:12:25 -0400
Received: by mail-oi0-f51.google.com with SMTP id c77so663598oig.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 19:12:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011004631.GX3666@dastard>
References: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150764695771.16882.9179160793491582514.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171011004631.GX3666@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Oct 2017 19:12:23 -0700
Message-ID: <CAPcyv4jK9-otfgtyoq_9i+jDzdzYpBRTk0s5UqM8zMOMC09CXw@mail.gmail.com>
Subject: Re: [PATCH v8 04/14] xfs: prepare xfs_break_layouts() for reuse with MAP_DIRECT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, iommu@lists.linux-foundation.org, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Tue, Oct 10, 2017 at 5:46 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Oct 10, 2017 at 07:49:17AM -0700, Dan Williams wrote:
>> Move xfs_break_layouts() to its own compilation unit so that it can be
>> used for both pnfs layouts and MAP_DIRECT mappings.
> .....
>> diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
>> index b587cb99b2b7..4135b2482697 100644
>> --- a/fs/xfs/xfs_pnfs.h
>> +++ b/fs/xfs/xfs_pnfs.h
>> @@ -1,19 +1,13 @@
>>  #ifndef _XFS_PNFS_H
>>  #define _XFS_PNFS_H 1
>>
>> +#include "xfs_layout.h"
>> +
>
> I missed this the first time through - we try not to put includes
> in header files, and instead make sure each C file has all the
> includes they require. Can you move this to all the C files that
> need layouts and remove the include of the xfs_pnfs.h include from
> them?

Sure, will do.
