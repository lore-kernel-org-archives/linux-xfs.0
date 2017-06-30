Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32902 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbdF3Rhm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Jun 2017 13:37:42 -0400
Date: Fri, 30 Jun 2017 19:37:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170630173740.GB11420@lst.de>
References: <20170629135420.21357-1-hch@lst.de> <20170629135420.21357-6-hch@lst.de> <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Jun 30, 2017 at 01:51:10PM +0200, Andreas Gruenbacher wrote:
> Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
> to be added back for consistency between reading i_size and walking
> the file extents.

At least for XFS we never had such a consistency as we never took
the iolock (aka i_rwsem).
