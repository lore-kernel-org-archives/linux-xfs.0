Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EF3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 15:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 640CD60F11
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 15:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239025AbhJFP4M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 11:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhJFP4M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Oct 2021 11:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D70E60F11
        for <linux-xfs@vger.kernel.org>; Wed,  6 Oct 2021 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535660;
        bh=3/A9BrsYbQe2RjNp9EkvlY9CktwgGnHvx8xC+jlb08I=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=P7nkxNsU6OHOyGUISEsIOTDyY0A5374PxZs8PTdyscc/qkOZQErmDYU6t86rxkaK9
         3V1VpwolRY/KmFh4f1wHzaDX0vparbUdbcLEUmED0qB1JxQdZKX4bU85OElgjevxY4
         SEupooaW3Atqm6SXowEA5nbIeN8ec9xnuEnCQ50esvoPvA73ygfSuLmZl3S2ZCsWTs
         bhzui3UfLS6Aj5HZoT8OkCqyH6Pzfx6Euw5URf8cZ2cE6zpu+fgXxSyNyRW/nGbRwh
         2x/Irhup0jUOFH2ljvzIKx4utiNNLmMJ6O7Qht8VN7wJ39ji2ZKuzYlzGWY2pAkWnH
         3zgQJowCy7G+Q==
Date:   Wed, 6 Oct 2021 08:54:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Prevent mmap command to map beyond EOF
Message-ID: <20211006155419.GI24307@magnolia>
References: <20211004141140.53607-1-cmaiolino@redhat.com>
 <20211005223653.GG24307@magnolia>
 <20211006113400.lcwukggcqwkrftkz@andromeda.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006113400.lcwukggcqwkrftkz@andromeda.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 06, 2021 at 01:34:00PM +0200, Carlos Maiolino wrote:
> On Tue, Oct 05, 2021 at 03:36:53PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 04, 2021 at 04:11:40PM +0200, Carlos Maiolino wrote:
> > > Attempting to access a mmapp'ed region that does not correspond to the
> > > file results in a SIGBUS, so prevent xfs_io to even attempt to mmap() a
> > > region beyond EOF.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > > 
> > > There is a caveat about this patch though. It is possible to mmap() a
> > > non-existent file region, extent the file to go beyond such region, and run
> > > operations in this mmapped region without such operations triggering a SIGBUS
> > > (excluding the file corruption factor here :). So, I'm not quite sure if it
> > > would be ok to check for this in mmap_f() as this patch does, or create a helper
> > > to check for such condition, and use it on the other operations (mread_f,
> > > mwrite_f, etc). What you folks think?
> > 
> > What's the motivation for checking this in userspace?  Programs are
> > allowed to set up this (admittedly minimally functional) configuration,
> > or even set it up after the mmap by truncating the file.
> 
> My biggest motivation was actually seeing xfs_io crashing due a sigbus
> while running generic/172 and generic/173. And personally, I'd rather see an
> error message like "attempt to mmap/mwrite beyond EOF" than seeing it crash.
> Also, as you mentioned, programs are allowed to set up such kind of
> configuration (IIUC what you mean, mixing mmap, extend, truncate, etc), so, I
> believe such userspace programs should also ensure they are not attempting to
> write to invalid memory.

This patch would /also/ prevent us from writing an fstest to check that
a process /does/ get SIGBUS when writing to a mapping beyond EOF.  Huh,
we don't have a test for that...

Also, where does generic/173 write to a mapping beyond EOF?  It sets up
a file of blksz*nr_blks bytes, clones it, fills the fs to full, and then
writes that number of bytes to the mmap region to trigger SIGBUS when
the COW fails due to ENOSPC.

--D

> > OTOH if your goal is to write a test to check the SIGBUS functionality,
> > you could install a sigbus handler to report the signal to stderr, which
> > would avoid bash writing junk about the sigbus to the terminal.
> 
> No, I'm just trying to avoid xfs_io crashing if we point it to invalid memory :)
> 
> Cheers.
> 
> > 
> > --D
> > 
> > > 
> > >  io/mmap.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/io/mmap.c b/io/mmap.c
> > > index 9816cf68..77c5f2b6 100644
> > > --- a/io/mmap.c
> > > +++ b/io/mmap.c
> > > @@ -242,6 +242,13 @@ mmap_f(
> > >  		return 0;
> > >  	}
> > >  
> > > +	/* Check if we are mmapping beyond EOF */
> > > +	if ((offset + length) > filesize()) {
> > > +		printf(_("Attempting to mmap() beyond EOF\n"));
> > > +		exitcode = 1;
> > > +		return 0;
> > > +	}
> > > +
> > >  	/*
> > >  	 * mmap and munmap memory area of length2 region is helpful to
> > >  	 * make a region of extendible free memory. It's generally used
> > > -- 
> > > 2.31.1
> > > 
> > 
> 
> -- 
> Carlos
> 
