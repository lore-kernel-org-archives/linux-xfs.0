Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42741 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757005AbdELIMo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 04:12:44 -0400
Date: Fri, 12 May 2017 10:12:42 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] generic/285: Add more SEEK_HOLE tests
Message-ID: <20170512081242.GA31470@quack2.suse.cz>
References: <20170511164809.29739-1-jack@suse.cz>
 <20170512080443.GN7250@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512080443.GN7250@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Jan Kara <jack@suse.cz>, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri 12-05-17 16:04:43, Eryu Guan wrote:
> On Thu, May 11, 2017 at 06:48:09PM +0200, Jan Kara wrote:
> > Add tests for bugs found in ext4 & xfs SEEK_HOLE implementations
> > fixed by following patches:
> > 
> > xfs: Fix missed holes in SEEK_HOLE implementation
> > ext4: Fix SEEK_HOLE
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> This will cause ext4 and xfs start to fail with current linus tree and
> appear as a new regression. So we usually don't add new tests to
> existing cases.
> 
> But seek_sanity_test.c deals with different SEEK_DATA/HOLE implentations
> nicely, which would be a bit tricky to do in a new test by shell, and it
> has all the infrastructures for new tests like this. So I think I'd
> prefer merging this patch as is, and document the false regression alert
> in release announce email.

Yeah, I agree regressing a test is not ideal but at least from the full
output it would be visible that the new testcases are those that failed and
at that point it is same as if a new test was failing.

> I'm including this patch in release testing now, please shout if ext4
> and/or xfs developers have different thoughts, there'll be around two
> days before new release :)

Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
