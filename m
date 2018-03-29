Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35793 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751935AbeC2Po5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:44:57 -0400
Date: Thu, 29 Mar 2018 17:44:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 06/14] ext2, dax: introduce ext2_dax_aops
Message-ID: <20180329154455.rq4dcvtplgciv3xm@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167306296.5268.6656046711107190095.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152167306296.5268.6656046711107190095.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, kbuild test robot <lkp@intel.com>, david@fromorbit.com, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz

On Wed 21-03-18 15:57:43, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Otherwise, direct-I/O
> triggers incorrect page cache assumptions and warnings.
> 
> Cc: Jan Kara <jack@suse.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks for the cleanup in the patch when setting inode ops. The patch looks
good except the same comment applies as for ext4 - please provide
ext2_dax_direct_IO() which will just bail and use it in ext2_dax_aops.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
