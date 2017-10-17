Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55859 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755133AbdJQLut (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Oct 2017 07:50:49 -0400
Date: Tue, 17 Oct 2017 13:50:47 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171017115047.GD24136@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-2-jack@suse.cz>
 <20171013071203.GA9105@infradead.org>
 <1507996677.21357.1.camel@intel.com>
 <20171016074504.GA7316@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016074504.GA7316@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "hch@infradead.org" <hch@infradead.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "jack@suse.cz" <jack@suse.cz>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "luto@kernel.org" <luto@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "arnd@arndb.de" <arnd@arndb.de>

On Mon 16-10-17 00:45:04, Christoph Hellwig wrote:
> > How about the following incremental update? It allows ->mmap_validate()
> > to be used as a full replacement for ->mmap() and it limits the error
> > code freedom to a centralized mmap_status_errno() routine:
> 
> Nah - my earlier comment was simply misinformed because I didn't
> read the whole patch and the _validate name mislead me.
> 
> So I think the current calling conventions are ok, I'd just like a
> better name (mmap_flags maybe?) and avoid the need the file system
> also has to implement ->mmap.

OK, I can do that. But I had just realized that if MAP_DIRECT isn't going
to end up using mmap(2) interface but something else (and I'm not sure
where discussions on this matter ended), we don't need flags argument for
->mmap at all. MAP_SYNC uses a VMA flag anyway and thus it is fine with the
current ->mmap interface. We still need some opt-in mechanism for
MAP_SHARED_VALIDATE though (probably supported mmap flags as Dan had in one
version of his patch). Thoughts on which way to go for now?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
