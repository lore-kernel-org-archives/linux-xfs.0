Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36429 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932604AbdCJFCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 00:02:10 -0500
Date: Thu, 9 Mar 2017 21:01:56 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: statx manpage
Message-ID: <20170310050156.GA11794@zzz>
References: <20170307225533.GA1403@zzz>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <17957.1488966060@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17957.1488966060@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 08, 2017 at 09:41:00AM +0000, David Howells wrote:
> > 
> > This example is confusing because chmod() doesn't change st_uid, and chown()
> > doesn't ordinarily change st_mode.
> 
> Doesn't chown() clear the S_ISUID and S_ISGID flags?
> 

It can, but it's not a straightforward example.

> 
> No, it's not a bug, exactly.  It's a design decision.  It might be worth
> adding an AT_STAT_LOCK flag to synchronise against attribute setting, but it
> will cost you something in terms of performance - and even then, over a
> network filesystem it might not achieve anything.
> 

Well, regardless of whether people want to fix it or not, I do think it's a bug.
Currently even the update of a timestamp is non-atomic, since that involves
updating both tv_sec and tv_nsec.  Therefore, stat() might return the new tv_sec
along with the old tv_nsec, or vice versa.  This can cause some very strange
behavior, such as two successively observed timestamps going backwards in time.

I expect that historically people haven't complained enough for this to be
worthwhile to fix.  But in theory I think it could be fixed with little
performance loss by protecting all the stat data with a sequence count, similar
to how reads of i_size are made atomic on 32-bit platforms by using
i_size_seqcount.

> 
> Good point.  Should I reject AT_EMPTY_PATH, AT_NO_AUTOMOUNT and
> AT_SYMLINK_NOFOLLOW if pathname is NULL, I wonder?
> 

It could be argued either way, but I was thinking those particular flags should
just be ignored, as they have known meanings but simply aren't relevant.  It
could also cause confusion for

	statx(dfd, "", AT_EMPTY_PATH, 0, buffer)

to succeed but for

	statx(dfd, NULL, AT_EMPTY_PATH, 0, buffer)

to fail (for example).

- Eric
