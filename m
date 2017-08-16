Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33940 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbdHPXmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 19:42:11 -0400
Received: by mail-yw0-f169.google.com with SMTP id s143so31981996ywg.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 16:42:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Aug 2017 16:42:08 -0700
Message-ID: <CAPcyv4h64RKGWQ7Mgw7KpZVc32hm4zprryjpZKwGS171ATh+VA@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] MAP_DIRECT and block-map-atomic files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Wed, Aug 16, 2017 at 12:44 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Changes since v4 [1]:
> * Drop the new vma ->fs_flags field, it can be replaced by just checking
>   ->vm_ops locally in the filesystem. This approach also allows
>   non-MAP_DIRECT vmas to be vma_merge() capable since vmas with
>   vm_ops->close() disable vma merging. (Jan)
>
> * Drop the new ->fmmap() operation, instead convert all ->mmap()
>   implementations tree-wide to take an extra 'map_flags' parameter.
>   (Jan)
>
> * Drop the cute (MAP_SHARED|MAP_PRIVATE) hack/mechanism to add new
>   validated flags mmap(2) and instead just define a new mmap syscall
>   variant (sys_mmap_pgoff_strict). (Andy)
>
> * Fix the fact that MAP_PRIVATE|MAP_DIRECT would silently fallback to
>   MAP_SHARED (addressed by the new syscall). (Kirill)
>
> * Require CAP_LINUX_IMMUTABLE for MAP_DIRECT to close any unforeseen
>   denial of service for unmanaged + unprivileged MAP_DIRECT usage.
>   (Kirill)
>
> * Switch MAP_DIRECT fault failures to SIGBUS (Kirill)
>
> * Add an fcntl mechanism to allow an unprivileged process to use
>   MAP_DIRECT on an fd setup by a privileged process.
>
> * Rework the MAP_DIRECT description to allow for future hardware where
>   it may not be required to software-pin the file offset to physical
>   address relationship.
>
> Given the tree-wide touches in this revision the patchset is starting to
> feel more like -mm material than strictly xfs.
>
> [1]: https://lkml.org/lkml/2017/8/15/39

For easier testing / evaluation of these patches I went ahead and
rebased them to v4.13-rc5, fixed up 0-day reports from the ->mmap()
conversion, and published a for-4.14/map-direct branch here:

    https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=for-4.14/map-direct
