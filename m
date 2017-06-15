Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44013 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdFOO5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 10:57:42 -0400
Date: Thu, 15 Jun 2017 07:57:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 12/20] fs: add a new fstype flag to indicate how
 writeback errors are tracked
Message-ID: <20170615145724.GB14028@infradead.org>
References: <20170612122316.13244-1-jlayton@redhat.com>
 <20170612122316.13244-15-jlayton@redhat.com>
 <20170612124513.GC18360@infradead.org>
 <1497349472.5762.1.camel@redhat.com>
 <20170614064731.GB3598@infradead.org>
 <1497461083.6752.7.camel@redhat.com>
 <20170615082221.GA22809@infradead.org>
 <1497523332.4556.1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497523332.4556.1.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Thu, Jun 15, 2017 at 06:42:12AM -0400, Jeff Layton wrote:
> Correct.
> 
> But if there is a data writeback error, should we report an error on all
> open fds at that time (like we will for fsync)?

We should in theory, but I don't see how to properly do it.  In addition
sync_file_range just can't be used for data integrity to start with, so
I don't think it's worth it.  At some point we should add a proper
fsync_range syscall, though.

