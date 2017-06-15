Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35759 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdFOKmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 06:42:17 -0400
Received: by mail-qt0-f170.google.com with SMTP id w1so14597717qtg.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2017 03:42:16 -0700 (PDT)
Message-ID: <1497523332.4556.1.camel@redhat.com>
Subject: Re: [PATCH v6 12/20] fs: add a new fstype flag to indicate how
 writeback errors are tracked
From: Jeff Layton <jlayton@redhat.com>
Date: Thu, 15 Jun 2017 06:42:12 -0400
In-Reply-To: <20170615082221.GA22809@infradead.org>
References: <20170612122316.13244-1-jlayton@redhat.com>
         <20170612122316.13244-15-jlayton@redhat.com>
         <20170612124513.GC18360@infradead.org> <1497349472.5762.1.camel@redhat.com>
         <20170614064731.GB3598@infradead.org> <1497461083.6752.7.camel@redhat.com>
         <20170615082221.GA22809@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Thu, 2017-06-15 at 01:22 -0700, Christoph Hellwig wrote:
> On Wed, Jun 14, 2017 at 01:24:43PM -0400, Jeff Layton wrote:
> > In this smaller set, it's only really used for DAX.
> 
> DAX only is implemented by three filesystems, please just fix them
> up in one go.
> 

Ok.

> > sync_file_range: ->fsync isn't called directly there, and I think we
> > probably want similar semantics to fsync() for it
> 
> sync_file_range is only supposed to sync data, so it should not call
> ->fsync.
> 

Correct.

But if there is a data writeback error, should we report an error on all
open fds at that time (like we will for fsync)?

I think we probably do want to do that, but like you say...there is no
file op for sync_file_range. It'll need some way to figure out what sort
of error tracking is in play.

> > JBD2: will try to re-set the error after clearing it with
> > filemap_fdatawait. That's problematic with the new infrastructure so we
> > need some way to avoid it.
> 
> JBD2 only has two users, please fix them up in one go.

I came up with a fix yesterday that makes the flag unnecessary there.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
