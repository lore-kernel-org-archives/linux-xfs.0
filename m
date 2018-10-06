Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbeJFRqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:46:50 -0400
Date: Sat, 6 Oct 2018 03:44:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/15] vfs: pass operation flags to {clone,
 dedupe}_file_range implementations
Message-ID: <20181006104402.GG25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870034158.29072.8943691140742142494.stgit@magnolia>
 <CAOQ4uxhDhyx-SnyJ5mmsKMvvb883reCWgvyNbABKyC4-SO+1EA@mail.gmail.com>
 <20181005175008.GY19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005175008.GY19324@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 05, 2018 at 10:50:08AM -0700, Darrick J. Wong wrote:
> > That's cool. But you know what's going to be the next step, right?
> > Merging the 3 file operation interfaces into a single one.
> > copy_file_range() already has the flags arg for future extensions
> > and as you wrote somewhere, clone is really an optimized copy.
> > ovl_copyfile() already does that internally.
> > 
> > So the only take away for this patch series, please use constant
> > names COPYRANGE_* and also explicitly define:
> > 
> > /* Operation is actually clone, not copy. */
> > #define COPYRANGE_CLONE      (1 << 2)
> > /* Operation is actually dedupe, not copy. */
> > #define COPYRANGE_DEDUPE      (1 << 3)
> 
> Yeah, I was too tired to try to throw that one on top of the flaming
> garbage pile.  But I guess since I have a bunch more work to do to the
> previous patch I might as well do that...

I'm not totally sold on just merging everything, but I very much despise
what is done in this patch, as it creates a completely confusing
interface.
