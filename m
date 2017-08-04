Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36775 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbdHDXnv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2017 19:43:51 -0400
Received: by mail-vk0-f45.google.com with SMTP id u133so11063487vke.3
        for <linux-xfs@vger.kernel.org>; Fri, 04 Aug 2017 16:43:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804233140.GF21024@dastard>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181369754.32119.7390149918955188408.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170804233140.GF21024@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 16:43:50 -0700
Message-ID: <CAPcyv4iHjLag-YRO3kgHMzED1vpLh28Lo+JZULAeRtiq8QGP+g@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Fri, Aug 4, 2017 at 4:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Aug 03, 2017 at 07:28:17PM -0700, Dan Williams wrote:
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index fe0f8f7f4bb7..46d8eb9e19fc 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1393,6 +1393,107 @@ xfs_zero_file_space(
>>
>>  }
>>
>> +/* Return 1 if hole detected, 0 if not, and < 0 if fail to determine */
>> +STATIC int
>> +xfs_file_has_holes(
>> +     struct xfs_inode        *ip)
>> +{
>
> Why do we need this function?
>
> We've just run xfs_alloc_file_space() across the entire range we
> are sealing, so we've already guaranteed that it won't have holes
> in it.

I'm sure this is due to my ignorance of the scope of XFS_IOLOCK_EXCL
vs XFS_ILOCK_EXCL. I had assumed that since we drop and retake
XFS_ILOCK_EXCL that we need to re-validate the block map before
setting S_IOMAP_IMMUTABLE.
