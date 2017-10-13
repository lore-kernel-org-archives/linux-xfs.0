Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18636 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753539AbdJMUGn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 16:06:43 -0400
Date: Fri, 13 Oct 2017 14:06:36 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 14/19] dax: Implement dax_finish_sync_fault()
Message-ID: <20171013200636.GC29081@linux.intel.com>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-15-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-15-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 10:05:58PM +0200, Jan Kara wrote:
> Implement a function that filesystems can call to finish handling of
> synchronous page faults. It takes care of syncing appropriare file range
						    appropriate
> and insertion of page table entry.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
