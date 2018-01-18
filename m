Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756342AbeAROYq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:24:46 -0500
Date: Thu, 18 Jan 2018 15:22:34 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v6 85/99] btrfs: Remove unused spinlock
Message-ID: <20180118142234.GK13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180117202203.19756-1-willy@infradead.org>
 <20180117202203.19756-86-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180117202203.19756-86-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

On Wed, Jan 17, 2018 at 12:21:49PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> The reada_lock in struct btrfs_device was only initialised, and not
> actually used.  That's good because there's another lock also called
> reada_lock in the btrfs_fs_info that was quite heavily used.  Remove
> this one.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

I'll pick this one now, thanks.
