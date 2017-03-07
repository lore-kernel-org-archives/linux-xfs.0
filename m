Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48083 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756456AbdCGWJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 17:09:18 -0500
Date: Tue, 7 Mar 2017 14:09:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: WARNING: CPU: 2 PID: 20539 at fs/iomap.c:954
 iomap_dio_rw+0x39a/0x3b0
Message-ID: <20170307220911.GA25288@infradead.org>
References: <1488922559.3877.6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1488922559.3877.6.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 07, 2017 at 04:35:59PM -0500, Jeff Layton wrote:
> I was doing an xfstests run on xfs with v4.11.0-rc1, and these two
> warnings popped. Looks like invalidate_inode_pages2_range failed? A
> small patch to print the error there showed that it was returning
> -EBUSY.
> 
> Pretty easy to reproduce by running xfstests generic/095 on a KVM guest
> running v4.11.0-rc1.

Can you try:

"[PATCH v2] iomap: invalidate page caches should be after iomap_dio_complete() in direct write"

which was sent to the XFS list last week and check if it fixes things
for you?
