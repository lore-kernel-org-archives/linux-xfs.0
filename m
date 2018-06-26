Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751901AbeFZSs2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 14:48:28 -0400
Date: Tue, 26 Jun 2018 14:48:25 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/3] Fix DM DAX handling
Message-ID: <20180626184824.GA7114@redhat.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Jun 26 2018 at  1:59pm -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> This series fixes a few issues that I found with DM's handling of DAX
> devices.  Here are some of the issues I found:
> 
>  * We can create a dm-stripe or dm-linear device which is made up of an
>    fsdax PMEM namespace and a raw PMEM namespace but which can hold a
>    filesystem mounted with the -o dax mount option.  DAX operations to
>    the raw PMEM namespace part lack struct page and can fail in
>    interesting/unexpected ways when doing things like fork(), examining
>    memory with gdb, etc.
> 
>  * We can create a dm-stripe or dm-linear device which is made up of an
>    fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
>    mounted with the -o dax mount option.  All I/O to this filesystem
>    will fail.
> 
> ---
> 
> Changes since v2:
>   * Only set QUEUE_FLAG_DAX for fsdax mode PMEM namespaces. (Mike)
>   * Check for QUEUE_FLAG_DAX in __bdev_dax_supported(). (Mike)
>   * Get rid of DM_TYPE_DAX_BIO_BASED reworks. (Mike)
>   * Dropped the first 2 prep patches of v2 since they were merged for
>     v4.18-rc1.  (Thanks, Darrick!)
> 
> ---
> 
> Mike, can you take this series through your tree?
> 
> Personally I think this should be treated as a bug fix and merged in the
> v4.18-rc* series.

I'd be fine with staging it for 4.18.  Only question is whether others
are fine with the dax patch (and me being the one to get it to Linus)?

I already replied to the 3rd patch with some feedback for v4 (but I can
also take care of those changes if I'm the one to stage these changes).

Maybe if Dan and/or others could provide their review for both the dax
and pmem patches?  If I can get review on those I'll get the series
staged for Linus to pull this week.

Thanks,
Mike
