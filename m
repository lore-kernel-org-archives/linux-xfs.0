Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34824 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdF3Qp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 12:45:58 -0400
Received: by mail-qt0-f174.google.com with SMTP id 22so8543915qtw.2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2017 09:45:57 -0700 (PDT)
Message-ID: <1498841154.4689.1.camel@redhat.com>
Subject: Re: [PATCH v8 17/18] xfs: minimal conversion to errseq_t writeback
 error reporting
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 30 Jun 2017 12:45:54 -0400
In-Reply-To: <20170629141235.GB17251@infradead.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
         <20170629131954.28733-18-jlayton@kernel.org>
         <20170629141235.GB17251@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, jlayton@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Thu, 2017-06-29 at 07:12 -0700, Christoph Hellwig wrote:
> Nice and simple, this looks great!
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks! I think this turned out to be a lot cleaner too.

For filesystems that use filemap_write_and_wait_range today this now
becomes a pretty straight conversion to file_write_and_wait_range -- one
liner patches for the most part.

I've started rolling patches to do that, but now I'm wondering...

Should I aim to do that with an individual patch for each fs, or is it
better to do a swath of them all at once in a single patch here?
-- 
Jeff Layton <jlayton@redhat.com>
