Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51599 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754420AbeC2SJ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 14:09:28 -0400
Date: Thu, 29 Mar 2018 20:09:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 05/14] ext4, dax: introduce ext4_dax_aops
Message-ID: <20180329180927.GA16055@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com> <152167305782.5268.13485258587227210521.stgit@dwillia2-desk3.amr.corp.intel.com> <20180329154035.lvsepjvt6vcplshw@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180329154035.lvsepjvt6vcplshw@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, david@fromorbit.com, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 29, 2018 at 05:40:35PM +0200, Jan Kara wrote:
> So ext4_direct_IO() for IS_DAX() files will just bail out. So could you
> just provide ext4_dax_direct_IO() which will bail out and use it here? With
> a similar comment as in xfs_vm_direct_IO() that open still needs this
> method set... Thanks!

In fact a common noop_direct_IO might make sense.
