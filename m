Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41014 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751735AbdINVP1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 17:15:27 -0400
Date: Thu, 14 Sep 2017 17:15:19 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 4/4] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170914211519.aieumj734uazwlmj@thunk.org>
References: <20170914140619.29826-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170914140619.29826-1-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 14, 2017 at 04:06:19PM +0200, Andreas Gruenbacher wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Here we go, after another round of xfstests.
> 
> The next question, since it touches vfs infrastructure, is which tree
> this patch queue should be merged through.  Al?

Discussions with Darrick before he went on vacation/honeymoon was that
up until now changes to fs/iomap.c had been going through XFS, but
since these changes didn't affect XFS, and the rest of the patch
series touches ext4 and ext4 functionality, that he was OK with
running this patch series through the ext4 tree.  I'm OK as well, so
unless Al has any objections?

				- Ted
