Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53621 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdFOIWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 04:22:43 -0400
Date: Thu, 15 Jun 2017 01:22:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 12/20] fs: add a new fstype flag to indicate how
 writeback errors are tracked
Message-ID: <20170615082221.GA22809@infradead.org>
References: <20170612122316.13244-1-jlayton@redhat.com>
 <20170612122316.13244-15-jlayton@redhat.com>
 <20170612124513.GC18360@infradead.org>
 <1497349472.5762.1.camel@redhat.com>
 <20170614064731.GB3598@infradead.org>
 <1497461083.6752.7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497461083.6752.7.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Jun 14, 2017 at 01:24:43PM -0400, Jeff Layton wrote:
> In this smaller set, it's only really used for DAX.

DAX only is implemented by three filesystems, please just fix them
up in one go.

> sync_file_range: ->fsync isn't called directly there, and I think we
> probably want similar semantics to fsync() for it

sync_file_range is only supposed to sync data, so it should not call
->fsync.

> JBD2: will try to re-set the error after clearing it with
> filemap_fdatawait. That's problematic with the new infrastructure so we
> need some way to avoid it.

JBD2 only has two users, please fix them up in one go.
