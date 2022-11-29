Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E013EC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 02:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiK2CvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 21:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiK2CvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 21:51:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01EB40918
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 18:51:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6671DCE114C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 02:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88791C433D6;
        Tue, 29 Nov 2022 02:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669690259;
        bh=zBuxxwwq1uQn3WfAzWz6e9iyVes7mSZSX2c8//Kd/KM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lw4co8rEykbU5iLwtX5PIJ58DLnYfCj72W5bmDqCWg8+jA/e3WrMkV8kDG5woT0Aw
         nTAROUUz3bYQbKBTlS4CLncXSQwHOHwE2rUbStBzqoDxl7lra4yUJ4VdyGR8sX+9th
         jdZNcMOUG8L9FN5Wb/IljPZBp9DyKpaxqlwkvVddhkalNjwCSSXuP16rPr0Ejxqhgk
         l1kE1suP3h/SnKvM4riqNIrU4utm4rSU2B/w+VcuNwDrKMXv82ZEOY9H2D+OtAxMP/
         Aqq5Qz8Jx2xg+mSIUcaansLSXDMxXPiEKIeJ2BHgTWbYeQl9asbrkiz25n6bujxDL2
         sYS+OQxl38GKg==
Date:   Mon, 28 Nov 2022 18:50:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Noah Misch <noah@leadboat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: After block device error, FICLONE and sync_file_range() make
 NULs, unlike read()
Message-ID: <Y4Vzk54RzjjEApOR@magnolia>
References: <20221108172436.GA3613139@rfd.leadboat.com>
 <Y2vZk7Wg0V8SvwxW@magnolia>
 <20221110045452.GB3665013@rfd.leadboat.com>
 <Y3RVp74Qf58/Rh2y@magnolia>
 <20221120013412.GB4097405@rfd.leadboat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221120013412.GB4097405@rfd.leadboat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 19, 2022 at 05:34:12PM -0800, Noah Misch wrote:
> On Tue, Nov 15, 2022 at 07:14:47PM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 09, 2022 at 08:54:52PM -0800, Noah Misch wrote:
> > > Subject line has my typo: s/sync_file_range/copy_file_range/
> > > 
> > > On Wed, Nov 09, 2022 at 08:47:15AM -0800, Darrick J. Wong wrote:
> > > > On Tue, Nov 08, 2022 at 09:24:36AM -0800, Noah Misch wrote:
> 
> > > > So I guess the question now is, what do we do about it?  The pagecache
> > > > maintainers have never been receptive to redirtying pages after a
> 
> For other readers, here are some references on that:
> https://www.kernel.org/doc/Documentation/filesystems/vfs.txt section "Handling errors during writeback"
> https://lwn.net/Articles/752105/ gives rationale
> 
> > > > writeback failure; cp should really pass that EIO out to userspace
> > > > instead of silently eating it; and maaaybe FICLONE should detect EIOs
> > > > recorded in the file's pagecache and return that, but it won't fix the
> > > 
> > > I'd favor having both FICLONE and copy_file_range() "detect EIOs recorded in
> > > the file's pagecache and return that".  That way, they never silently make a
> > > bad clone when read() could have provided the bytes constituting a good clone.
> > 
> > So would I, but the longstanding behavior of FICLONE is that it's an
> > implied fsync, so it's *vital* that calling programs do not drop the EIO
> > on the floor like cp does.
> 
> Having thought about that more, I agree.  While read() gave the intended file
> contents in my example, there's no guarantee the pages weren't already
> evicted.  If the user wants to trust read(), the user can opt to retry with
> --reflink=never.  "cp" shouldn't make that choice on the user's behalf.  "cp"
> can still fallback to copy_file_range() or read() after EBADF, EINVAL,
> EOPNOTSUPP, ETXTBSY, and EXDEV.  I don't know which is better, "halt on EIO
> only" or "halt on all errno except the five known-okay ones".

Yeah, that's also unclear, since one could argue that after failed
writeback, userspace might actually *want* the kernel to splice the
pagecache for the busted file into a new file on another filesystem.

> > Another dumb thing about how the pagecache tracks errors is that it sets
> > a single state bit for the whole mapping, which means that we can't
> > actually /tell/ userspace which part of their file is now busted.  We
> > can't even tell if userspace has successfully rewrite()d all the regions
> > where writeback failed, which leads me to...
> > 
> > Another another dumb thing about how the pagecache tracks errors is that
> > any fsync-lik operation will test_and_clear_bit the EIO state, which
> > means that if we find a past EIO, we'll clear that state and return the
> > EIO to userspace.
> > 
> > We /could/ change FICLONE to flush the dirty pagecache, sample the EIO
> > status *without* clearing it, and return EIO if it's set.  That's
> > probably the most unabsurd way to deal with this, but it's unsettling
> > that even cp ignores errno returns now.  The manpage for FICLONE doesn't
> > explicitly mention any fsync behaviors, so perhaps "flush and retain
> > EIO" is the right choice here.
> 
> That reminds me of
> https://postgr.es/m//20180427222842.in2e4mibx45zdth5@alap3.anarazel.de.  Its
> summary of a LSF/MM 2018 discussion mentioned NFS writeback errors detected
> and cleared at close(), which I find similar.  I might favor a uniform policy,
> one of:
> 
> a. Any syscall with a file descriptor argument might return EIO.  If it does,
>    it clears the EIO.
> b. Any syscall with a file descriptor argument might return EIO.  Only a
>    specific list of syscalls, having writeback-oriented names, clear EIO:
>    fsync(), syncfs(), [...].  Others report EIO without clearing it.
> 
> One argument for (b) is that, on EIO from FICLONE or copy_file_range(), the
> caller can't know whether the broken file is the source or the destination.  A
> cautious caller should assume both are broken.  What other considerations
> should influence the decision?

That's a very good point you've raised -- userspace can't associate an
EIO return value with either of the fds in use.  It can't even tell if
the filesystem itself hit some metadata error somewhere else (e.g.
refcount data), and that's the real reason why EIO got thrown back to
userspace.

On those grounds, I think FICLONE/FIEDEDUPE need to preserve the
AS_EIO/AS_ENOSPC state in the address_space so that actual fsync (or
syncfs, or any of the known 'persist me now' calls) can also return the
status.

I'll try to push that for 6.3.

--D

> > > > underlying problem, which is that the cache thinks its clean after an
> > > > EIO, and the pagecache forgets about recorded EIOs after reporting them
> > > > via fsync/syncfs.
> > > 
> > > True.
