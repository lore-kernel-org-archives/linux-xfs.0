Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1171094AbdDXPAZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2017 11:00:25 -0400
Date: Mon, 24 Apr 2017 08:00:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC xfstests PATCH] xfstests: add a writeback error handling
 test
Message-ID: <20170424150019.GA3288@infradead.org>
References: <20170424134551.10301-1-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170424134551.10301-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

On Mon, Apr 24, 2017 at 09:45:51AM -0400, Jeff Layton wrote:
> With the patch series above, ext4 now passes. xfs and btrfs end up in
> r/o mode after the test. xfs returns -EIO at that point though, and
> btrfs returns -EROFS. What behavior we actually want there, I'm not
> certain. We might be able to mitigate that by putting the journals on a
> separate device?

This looks like XFS shut down because of a permanent write error from
dm-error.  Which seems like the expected behavior.
