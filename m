Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38770 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbeCBWVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 17:21:41 -0500
Received: by mail-oi0-f51.google.com with SMTP id 123so8154892oig.5
        for <linux-xfs@vger.kernel.org>; Fri, 02 Mar 2018 14:21:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180302221020.GA30722@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180302221020.GA30722@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Mar 2018 14:21:40 -0800
Message-ID: <CAPcyv4gKyvkHY_qQTYvd8wrLpaXXciJyWZY+9T7Q_Eg-Zuxpgw@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] vfio, dax: prevent long term filesystem-dax pins
 and other fixes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, KVM list <kvm@vger.kernel.org>, Haozhong Zhang <haozhong.zhang@intel.com>, Jane Chu <jane.chu@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Gerd Rausch <gerd.rausch@oracle.com>, stable <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Mar 2, 2018 at 2:10 PM, Christoph Hellwig <hch@lst.de> wrote:
> I really don't like these IS_DEVDAX and IS_FSDAX flags.  We should
> stop pretending DAX is a global per-inode choice and get rid of these
> magic flags entirely.  So please convert the instances inside the
> various file systems to checking the file system mount options instead.
>
> For the core ones we'll need to differentiate:
>
>  - the checks in generic_file_read_iter and __generic_file_write_iter
>    seem to not be needed anymore at all since we stopped abusing the
>    direct I/O code for DAX, so they should probably be removed.
>  - io_is_direct is a weird check and should probably just go away,
>    as there is not point in always setting IOCB_DIRECT for DAX I/O
>  - fadvise should either become a file op, or a flag on the inode that
>    fadvice is supported instead of the nasty noop_backing_dev_info or
>    DAX check.
>  - Ditto for madvise
>  - vma_is_dax should probably be replaced with a VMA flag.
>  - thp_get_unmapped_area I don't really understand why we have a dax
>    check there.
>  - dax_mapping will be much harder to sort out.
>
> But all these DAX flags certainly look like a major hodge podge to me.

They are indeed a hodge-podge. The problem is that the current
IS_DAX() is broken. So I'd like to propose fixing IS_DAX() with
IS_FSDAX() + IS_DEVDAX() for 4.16-rc4 and queue up these wider reworks
you propose for the next merge window.

Acceptable?
