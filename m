Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51586 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752412AbdHRWG1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:06:27 -0400
Date: Fri, 18 Aug 2017 16:06:25 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 03/13] dax: Factor out getting of pfn out of iomap
Message-ID: <20170818220625.GB32627@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-4-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 17, 2017 at 06:08:05PM +0200, Jan Kara wrote:
> Factor out code to get pfn out of iomap that is shared between PTE and
> PMD fault path.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Yep, this looks correct to me.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
