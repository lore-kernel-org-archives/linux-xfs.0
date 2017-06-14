Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58323 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdFNGr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2017 02:47:57 -0400
Date: Tue, 13 Jun 2017 23:47:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 12/20] fs: add a new fstype flag to indicate how
 writeback errors are tracked
Message-ID: <20170614064731.GB3598@infradead.org>
References: <20170612122316.13244-1-jlayton@redhat.com>
 <20170612122316.13244-15-jlayton@redhat.com>
 <20170612124513.GC18360@infradead.org>
 <1497349472.5762.1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497349472.5762.1.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Jun 13, 2017 at 06:24:32AM -0400, Jeff Layton wrote:
> That's definitely what I want for the endgame here. My plan was to add
> this flag for now, and then eventually reverse it (or drop it) once all
> or most filesystems are converted.
> 
> We can do it that way from the get-go if you like. It'll mean tossing in
>  a patch add this flag to all filesystems that have an fsync operation
> and that use the pagecache, and then gradually remove it from them as we
> convert them.
> 
> Which method do you prefer?

Please do it from the get-go.  Or in fact figure out if we can get
away without it entirely.  Moving the error reporting into ->fsync
should help greatly with that, so what's missing after that?
