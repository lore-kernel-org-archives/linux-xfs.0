Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdJPHpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 03:45:08 -0400
Date: Mon, 16 Oct 2017 00:45:04 -0700
From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171016074504.GA7316@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-2-jack@suse.cz>
 <20171013071203.GA9105@infradead.org>
 <1507996677.21357.1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507996677.21357.1.camel@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "luto@kernel.org" <luto@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "arnd@arndb.de" <arnd@arndb.de>

> How about the following incremental update? It allows ->mmap_validate()
> to be used as a full replacement for ->mmap() and it limits the error
> code freedom to a centralized mmap_status_errno() routine:

Nah - my earlier comment was simply misinformed because I didn't
read the whole patch and the _validate name mislead me.

So I think the current calling conventions are ok, I'd just like a
better name (mmap_flags maybe?) and avoid the need the file system
also has to implement ->mmap.
