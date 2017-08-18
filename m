Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:12369 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751807AbdHRWKd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:10:33 -0400
Date: Fri, 18 Aug 2017 16:10:32 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 06/13] dax: Inline dax_insert_mapping() into the callsite
Message-ID: <20170818221032.GE32627@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-7-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-7-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 17, 2017 at 06:08:08PM +0200, Jan Kara wrote:
> dax_insert_mapping() has only one callsite and we will need to further
> fine tune what it does for synchronous faults. Just inline it into the
> callsite so that we don't have to pass awkward bools around.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
