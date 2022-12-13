Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C8FC10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiLMTUl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbiLMTUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:20:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06796A1B5
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 11:20:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9905B61598
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 19:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D49C433EF;
        Tue, 13 Dec 2022 19:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670959237;
        bh=+Eqc3vRvU5Y6sjxVvZ7CcX411xCZulZnEVtYI2OMSyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DOGL80XOC+rM1JxWk82gzhci5kOMXuLxd0vUylc5KpE6rNqpvNIFbcOihu/9gQ/uz
         T/fABlFCsrDAs/Z2rMl5d+6HdAqEnzPtho+d5GUPMS9mK7ouJ8IxUgMULM/LT8LTIv
         AWG2lIXYb8ZzEUgWgytbRzEYFX4995WCgNxbA4Dxc677Bb2SOgb6i4w7YE30O05yyN
         P0BeUhMhf084BX/QgEKRik/6MVtmb5cjzGzMSxoYgHE6fJKqaJE7JGnIEBS98bYr/q
         ha+47TIoXlHpKWpx8voXRBsT7pdx23ij96XtipRk72WaV6jMSVMXVgD/xEkiII118b
         o0mFCe+/SVCRQ==
Date:   Tue, 13 Dec 2022 11:20:36 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Noah Misch <noah@leadboat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: After block device error, FICLONE and sync_file_range() make
 NULs, unlike read()
Message-ID: <Y5jQhDVkQiXD0OIS@magnolia>
References: <20221108172436.GA3613139@rfd.leadboat.com>
 <Y2vZk7Wg0V8SvwxW@magnolia>
 <20221110045452.GB3665013@rfd.leadboat.com>
 <Y3RVp74Qf58/Rh2y@magnolia>
 <20221120013412.GB4097405@rfd.leadboat.com>
 <Y4Vzk54RzjjEApOR@magnolia>
 <20221210074344.GA646514@rfd.leadboat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210074344.GA646514@rfd.leadboat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 09, 2022 at 11:43:44PM -0800, Noah Misch wrote:
> On Mon, Nov 28, 2022 at 06:50:59PM -0800, Darrick J. Wong wrote:
> > On Sat, Nov 19, 2022 at 05:34:12PM -0800, Noah Misch wrote:
> > > On Tue, Nov 15, 2022 at 07:14:47PM -0800, Darrick J. Wong wrote:
> > > > On Wed, Nov 09, 2022 at 08:54:52PM -0800, Noah Misch wrote:
> > > > > Subject line has my typo: s/sync_file_range/copy_file_range/
> 
> > > > Another dumb thing about how the pagecache tracks errors is that it sets
> > > > a single state bit for the whole mapping, which means that we can't
> > > > actually /tell/ userspace which part of their file is now busted.  We
> > > > can't even tell if userspace has successfully rewrite()d all the regions
> > > > where writeback failed, which leads me to...
> > > > 
> > > > Another another dumb thing about how the pagecache tracks errors is that
> > > > any fsync-lik operation will test_and_clear_bit the EIO state, which
> > > > means that if we find a past EIO, we'll clear that state and return the
> > > > EIO to userspace.
> > > > 
> > > > We /could/ change FICLONE to flush the dirty pagecache, sample the EIO
> > > > status *without* clearing it, and return EIO if it's set.  That's
> > > > probably the most unabsurd way to deal with this, but it's unsettling
> > > > that even cp ignores errno returns now.  The manpage for FICLONE doesn't
> > > > explicitly mention any fsync behaviors, so perhaps "flush and retain
> > > > EIO" is the right choice here.
> > > 
> > > That reminds me of
> > > https://postgr.es/m//20180427222842.in2e4mibx45zdth5@alap3.anarazel.de.  Its
> > > summary of a LSF/MM 2018 discussion mentioned NFS writeback errors detected
> > > and cleared at close(), which I find similar.  I might favor a uniform policy,
> > > one of:
> > > 
> > > a. Any syscall with a file descriptor argument might return EIO.  If it does,
> > >    it clears the EIO.
> > > b. Any syscall with a file descriptor argument might return EIO.  Only a
> > >    specific list of syscalls, having writeback-oriented names, clear EIO:
> > >    fsync(), syncfs(), [...].  Others report EIO without clearing it.
> > > 
> > > One argument for (b) is that, on EIO from FICLONE or copy_file_range(), the
> > > caller can't know whether the broken file is the source or the destination.  A
> > > cautious caller should assume both are broken.  What other considerations
> > > should influence the decision?
> > 
> > That's a very good point you've raised -- userspace can't associate an
> > EIO return value with either of the fds in use.  It can't even tell if
> > the filesystem itself hit some metadata error somewhere else (e.g.
> > refcount data), and that's the real reason why EIO got thrown back to
> > userspace.
> > 
> > On those grounds, I think FICLONE/FIEDEDUPE need to preserve the
> > AS_EIO/AS_ENOSPC state in the address_space so that actual fsync (or
> > syncfs, or any of the known 'persist me now' calls) can also return the
> > status.
> > 
> > I'll try to push that for 6.3.
> 
> That sounds good.  Thank you.  Please CC me on any threads you create for
> this, if not inconvenient.

Will do.

--D
