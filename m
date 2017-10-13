Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54561 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbdJMH2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 03:28:25 -0400
Date: Fri, 13 Oct 2017 00:28:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/19] xfs: Add support for MAP_SYNC flag
Message-ID: <20171013072824.GH9105@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-20-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-20-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

Should be merged go into the previous patch.

Also I just noticed how I misread ->mmap_validate in the first patch - it
doesn't just validate the mmap arguments but also replaces ->mmap
itself.

Which means that a) the name for it is very confusing, and b) we should
at very least have it fully replace ->mmap for file systems that
implement it, that is ext4 and xfs should not have to implement both
but just the new one.
