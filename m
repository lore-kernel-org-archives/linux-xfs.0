Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35295 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751235AbeC2Pki (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:40:38 -0400
Date: Thu, 29 Mar 2018 17:40:35 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 05/14] ext4, dax: introduce ext4_dax_aops
Message-ID: <20180329154035.lvsepjvt6vcplshw@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167305782.5268.13485258587227210521.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152167305782.5268.13485258587227210521.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, david@fromorbit.com, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 21-03-18 15:57:37, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Otherwise, direct-I/O
> triggers incorrect page cache assumptions and warnings.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good, just one nit below.

> @@ -3946,6 +3961,13 @@ static const struct address_space_operations ext4_da_aops = {
>  	.error_remove_page	= generic_error_remove_page,
>  };
>  
> +static const struct address_space_operations ext4_dax_aops = {
> +	.direct_IO		= ext4_direct_IO,

So ext4_direct_IO() for IS_DAX() files will just bail out. So could you
just provide ext4_dax_direct_IO() which will bail out and use it here? With
a similar comment as in xfs_vm_direct_IO() that open still needs this
method set... Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
