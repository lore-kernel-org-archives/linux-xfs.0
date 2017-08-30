Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbdH3Paw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 11:30:52 -0400
Date: Wed, 30 Aug 2017 17:30:48 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170830153048.pslde7hv5rp5zibw@rh_laptop>
References: <20170825151445.ycf5xomoxvebgaez@thunk.org>
 <20170825154032.GA1827@infradead.org>
 <20170825233358.GC17782@dastard>
 <20170828073853.GA23262@infradead.org>
 <20170828101014.GD17782@dastard>
 <20170829154922.GA24592@quack2.suse.cz>
 <20170829225717.GG10621@dastard>
 <20170830100059.GC28354@quack2.suse.cz>
 <20170830123450.GA14976@infradead.org>
 <20170830150019.cwrnum6zmrieqhdp@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830150019.cwrnum6zmrieqhdp@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 11:00:19AM -0400, Theodore Ts'o wrote:
> Bringing this discussion back to the "ext4: introduce per-inode DAX
> flag" patch, it sounds to me that I should _not_ apply this patch
> until we figure out to fix this for reals.  Does this sound fair?
> 
> If we think it's completely unfixable, then maybe XFS should consider
> (temporarily) withdrawing the per-file DAX support before there is a
> userspace and you have to support it forever, but that's between the
> NVM/dax and XFS folks to figure out.
> 
> 					- Ted

Hi Ted,

I agree, this still has some issues even for ext4. Let's see what we can
do about that and I'll revisit it later.

Thanks!
-Lukas
