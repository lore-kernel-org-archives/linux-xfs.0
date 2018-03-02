Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38217 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932197AbeCBWKX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 17:10:23 -0500
Date: Fri, 2 Mar 2018 23:10:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 00/12] vfio, dax: prevent long term filesystem-dax
        pins and other fixes
Message-ID: <20180302221020.GA30722@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, kvm@vger.kernel.org, Haozhong Zhang <haozhong.zhang@intel.com>, Jane Chu <jane.chu@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Gerd Rausch <gerd.rausch@oracle.com>, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-fsdevel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Theodore Ts'o <tytso@mit.edu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org

I really don't like these IS_DEVDAX and IS_FSDAX flags.  We should
stop pretending DAX is a global per-inode choice and get rid of these
magic flags entirely.  So please convert the instances inside the
various file systems to checking the file system mount options instead.

For the core ones we'll need to differentiate:

 - the checks in generic_file_read_iter and __generic_file_write_iter
   seem to not be needed anymore at all since we stopped abusing the
   direct I/O code for DAX, so they should probably be removed.
 - io_is_direct is a weird check and should probably just go away,
   as there is not point in always setting IOCB_DIRECT for DAX I/O
 - fadvise should either become a file op, or a flag on the inode that
   fadvice is supported instead of the nasty noop_backing_dev_info or
   DAX check.
 - Ditto for madvise
 - vma_is_dax should probably be replaced with a VMA flag.
 - thp_get_unmapped_area I don't really understand why we have a dax
   check there.
 - dax_mapping will be much harder to sort out.

But all these DAX flags certainly look like a major hodge podge to me.

