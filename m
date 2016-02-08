Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7FAF7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 12:31:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43F49AC003
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 10:31:30 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id IAv8Ku4ga4L2pNle for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 10:31:29 -0800 (PST)
Date: Mon, 8 Feb 2016 11:31:12 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] dax: move writeback calls into the filesystems
Message-ID: <20160208183112.GF2343@linux.intel.com>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454829553-29499-3-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jT=yAb2_yLfMGqV1SdbQwoWQj7joroeJGAJAcjsMY_oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jT=yAb2_yLfMGqV1SdbQwoWQj7joroeJGAJAcjsMY_oQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, jmoyer <jmoyer@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Feb 07, 2016 at 11:13:51AM -0800, Dan Williams wrote:
> The proposal: make applications explicitly request DAX semantics with
> a new MAP_DAX flag and fail if DAX is unavailable.  Document that a
> successful MAP_DAX request mandates that the application assumes
> responsibility for cpu cache management.  

> Require that all applications that mmap the file agree on MAP_DAX.

I think this proposal could run into issues with aliasing.  For example, say
you have two threads accessing the same region, and one wants to use DAX and
the other wants to use the page cache.  What happens?

If we satisfy both requests, we end up with one user reading and writing to
the page cache, while the other is reading and writing directly to the media.
They can't see each other's changes, and you get data corruption.

If we satisfy the request of whoever asked first, sort of lock the inode into
that mode, and then return an error to the second thread because they are
asking for the other mode, we have now introduced a new weird failure case
where mmaps can randomly fail based on the behavior of other applications.
I think this is where you were going with the last line quoted above, but I
don't understand how it would work in an acceptable way.

It seems like we have to have the decision about whether or not to use DAX
made in the same way for all users of the inode so that we don't run into
these types of conflicts.

> This also solves
> the future problem of DAX support on virtually tagged cache
> architectures where it is difficult for the kernel to know what alias
> addresses need flushing.
> 
> [1]: https://github.com/pmem/nvml

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
