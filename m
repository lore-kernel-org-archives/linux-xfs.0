Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:35017 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdFTRor (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 13:44:47 -0400
Received: by mail-qt0-f174.google.com with SMTP id f92so314116qtb.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2017 10:44:46 -0700 (PDT)
Message-ID: <1497980684.4555.16.camel@redhat.com>
Subject: Re: [PATCH v7 16/22] block: convert to errseq_t based writeback
 error tracking
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 20 Jun 2017 13:44:44 -0400
In-Reply-To: <20170620123544.GC19781@infradead.org>
References: <20170616193427.13955-1-jlayton@redhat.com>
         <20170616193427.13955-17-jlayton@redhat.com>
         <20170620123544.GC19781@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Tue, 2017-06-20 at 05:35 -0700, Christoph Hellwig wrote:
> >  	error = filemap_write_and_wait_range(filp->f_mapping, start, end);
> >  	if (error)
> > -		return error;
> > +		goto out;
> >  
> >  	/*
> >  	 * There is no need to serialise calls to blkdev_issue_flush with
> > @@ -640,6 +640,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
> >  	if (error == -EOPNOTSUPP)
> >  		error = 0;
> >  
> > +out:
> > +	wberr = filemap_report_wb_err(filp);
> > +	if (!error)
> > +		error = wberr;
> 
> Just curious: what's the reason filemap_write_and_wait_range couldn't
> query for the error using filemap_report_wb_err internally?

In order to query for errors with errseq_t, you need a previously-
sampled point from which to check. When you call
filemap_write_and_wait_range though you don't have a struct file and so
no previously-sampled value.

-- 
Jeff Layton <jlayton@redhat.com>
