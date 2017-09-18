Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27760 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdIRS7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 14:59:50 -0400
Date: Mon, 18 Sep 2017 11:59:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 4/4] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170918185937.GO6540@magnolia>
References: <20170914140619.29826-1-agruenba@redhat.com>
 <20170914211519.aieumj734uazwlmj@thunk.org>
 <CAHc6FU6X29Pr6gA+d0L3WuoCY1XwNjQ9aTYUuAp84-O-ff_xGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU6X29Pr6gA+d0L3WuoCY1XwNjQ9aTYUuAp84-O-ff_xGQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Mon, Sep 18, 2017 at 07:52:32PM +0200, Andreas Gruenbacher wrote:
> On Thu, Sep 14, 2017 at 11:15 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Thu, Sep 14, 2017 at 04:06:19PM +0200, Andreas Gruenbacher wrote:
> >> From: Christoph Hellwig <hch@lst.de>
> >>
> >> Here we go, after another round of xfstests.
> >>
> >> The next question, since it touches vfs infrastructure, is which tree
> >> this patch queue should be merged through.  Al?
> >
> > Discussions with Darrick before he went on vacation/honeymoon was that
> > up until now changes to fs/iomap.c had been going through XFS, but
> > since these changes didn't affect XFS, and the rest of the patch
> > series touches ext4 and ext4 functionality, that he was OK with
> > running this patch series through the ext4 tree.
> 
> That sure works for me.

Me too.

(Back from vacation, weeding his way through 2400 emails...)

--D

> 
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
