Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:46917 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbdJKXCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 19:02:19 -0400
Received: by mail-oi0-f43.google.com with SMTP id n82so5716073oig.3
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 16:02:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011200603.27442-20-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-20-jack@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 16:02:18 -0700
Message-ID: <CAPcyv4jhtkyzdLmUKVZDPsZ-MFZ20+SMUcgMXg2V2e0xZACg4g@mail.gmail.com>
Subject: Re: [PATCH 19/19] xfs: Add support for MAP_SYNC flag
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
> Now when everything is prepared, add support in xfs to accept MAP_SYNC
> as an mmap(2) flag.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c    |  1 +
>  fs/xfs/xfs_file.c | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f013cda84b3d..6b597cc6b29d 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -26,6 +26,7 @@
>  #include <linux/quotaops.h>
>  #include <linux/pagevec.h>
>  #include <linux/uio.h>
> +#include <linux/mman.h>

I assume you wanted this change earlier in the series.
