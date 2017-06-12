Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdFLMnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2017 08:43:04 -0400
Date: Mon, 12 Jun 2017 05:42:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 15/20] fs: have call_fsync call filemap_report_wb_err
 if FS_WB_ERRSEQ is set
Message-ID: <20170612124224.GA18360@infradead.org>
References: <20170612122316.13244-1-jlayton@redhat.com>
 <20170612122316.13244-20-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170612122316.13244-20-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Jun 12, 2017 at 08:23:11AM -0400, Jeff Layton wrote:
> Allow filesystems to opt-in to a final check of wb_err if FS_WB_ERRSEQ
> is set. Technically, we could just plumb these calls into all of the
> fsync operations, but I think this means less code, changes and churn.

Please add it to every fs, that is a consistent with how we handle
everything else related to writeback.

Oh, and please kill this idiotic call_fsync helper while you're at it.
