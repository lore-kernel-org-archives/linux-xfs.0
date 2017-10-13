Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64499 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752877AbdJMT0y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 15:26:54 -0400
Date: Fri, 13 Oct 2017 13:26:53 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 11/19] dax: Allow tuning whether
 dax_insert_mapping_entry() dirties entry
Message-ID: <20171013192653.GA29081@linux.intel.com>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-12-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-12-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 10:05:55PM +0200, Jan Kara wrote:
> Currently we dirty radix tree entry whenever dax_insert_mapping_entry()
> gets called for a write fault. With synchronous page faults we would
> like to insert clean radix tree entry and dirty it only once we call
> fdatasync() and update page tables to same some unnecessary cache
> flushing. Add 'dirty' argument to dax_insert_mapping_entry() for that.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
