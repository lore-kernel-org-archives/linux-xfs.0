Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50410 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdJRG7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 02:59:42 -0400
Date: Tue, 17 Oct 2017 23:59:38 -0700
From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171018065938.GA15310@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-2-jack@suse.cz>
 <20171013071203.GA9105@infradead.org>
 <1507996677.21357.1.camel@intel.com>
 <20171016074504.GA7316@infradead.org>
 <20171017115047.GD24136@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171017115047.GD24136@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "hch@infradead.org" <hch@infradead.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "luto@kernel.org" <luto@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "arnd@arndb.de" <arnd@arndb.de>

On Tue, Oct 17, 2017 at 01:50:47PM +0200, Jan Kara wrote:
> OK, I can do that. But I had just realized that if MAP_DIRECT isn't going
> to end up using mmap(2) interface but something else (and I'm not sure
> where discussions on this matter ended), we don't need flags argument for
> ->mmap at all. MAP_SYNC uses a VMA flag anyway and thus it is fine with the
> current ->mmap interface. We still need some opt-in mechanism for
> MAP_SHARED_VALIDATE though (probably supported mmap flags as Dan had in one
> version of his patch). Thoughts on which way to go for now?

Yes, I'd much prefer the mmap_flags in file_operations.  The other
option would be a new FMODE_* flag which is what Al did for various
other optional features, but I generally thing that is a confusing
interface.
