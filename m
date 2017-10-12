Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40200 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdJLBVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:21:41 -0400
Date: Thu, 12 Oct 2017 02:21:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v9 2/6] fs, mm: pass fd to ->mmap_validate()
Message-ID: <20171012012131.GD21978@ZenIV.linux.org.uk>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923838.9144.15727770472447035032.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150776923838.9144.15727770472447035032.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Wed, Oct 11, 2017 at 05:47:18PM -0700, Dan Williams wrote:
> The MAP_DIRECT mechanism for mmap intends to use a file lease to prevent
> block map changes while the file is mapped. It requires the fd to setup
> an fasync_struct for signalling lease break events to the lease holder.

*UGH*

That looks like one hell of a bad API.  You are not even guaranteed that
descriptor will remain be still open by the time you pass it down to your
helper, nevermind the moment when event actually happens...
