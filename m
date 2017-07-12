Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56445 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbdGLJRO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 05:17:14 -0400
Date: Wed, 12 Jul 2017 11:17:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 1/3] ext4: Add missing locking around
        iomap_seek_{hole,data}
Message-ID: <20170712091712.GA8251@lst.de>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com> <1499462881-4238-2-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499462881-4238-2-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Jul 07, 2017 at 11:27:59PM +0200, Andreas Gruenbacher wrote:
> Add back the inode locking that "ext4: Switch to iomap for SEEK_HOLE /
> SEEK_DATA" blew away.  We can use inode_lock_shared instead of
> inode_lock instead, though.

should be folded into that patch.
