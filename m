Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56460 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdGLJUY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 05:20:24 -0400
Date: Wed, 12 Jul 2017 11:20:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 2/3] iomap: Switch from blkno to physical offset
Message-ID: <20170712092023.GB8251@lst.de>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com> <1499462881-4238-3-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499462881-4238-3-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Maybe diskaddr or just addr instead of physical which sounds a little
confusing?

Also how well was this tested?  With all the calculation I'm a little
worried about overflows, so a full xfstests run including sub-page
blocksize and DAX really is in order here.

> +#define IOMAP_F_INLINE	0x40	/* data mixed with metadata */

data inline in the inode?
