Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU7a5fQ014258 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 01:36:05 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1B5D51544
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:36:05 -0800 (PST)
Received: from parsec.stupidest.org (splinter.f00f.org [216.75.21.205]) by
	cuda.sgi.com with ESMTP id RR9idyjG3kdgbn7q for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 23:36:05 -0800 (PST)
Date: Mon, 29 Dec 2008 11:03:29 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27 and 2.6.28
Message-ID: <20081229190329.GA17289@puku.stupidest.org>
References: <200812291920.34123.Martin@Lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200812291920.34123.Martin@Lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@Lichtvoll.de>
Cc: xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 07:20:33PM +0100, Martin Steigerwald wrote:

> But I had a hard crash this time while shutting down the system
> regularily and the KDE addressbook, KDE settings, additional sidebar
> all was lost due to truncated files. This was without barriers but
> also without write cache.

I've seen this but not for a very long time.

It used be be (perhaps still is) that KDE updates configurations with
open O_TRUNC & rewrite.

This means there is a window when you can lose data.


I suggested that they should open temp, write, fsync then rename (some
time ago) and I recall seeing some changes in CVS the next day to do
that, but i think that was with ktmpfile or something only).

The other thing is XFS has a much smaller window now than it used to
on the open w/ truncate case, I think now writeout begins as soon as
the file is closed.


Older versions of firefox did this with bookmarks too, so you would
get cases there were you lost data.  Now it uses sqlite as a store
which is much more sane in it's write patterns.

> Do you have any idea on how to help to get down to the cause of this
> - without risking precious data?

ball-peen hammer?

> Did anyone else see this? Does anyone use XFS on laptops and had
> recent power losses or crashes?

I use XFS on laptops, have done for years and don't typically see
this.

> I expect to loose the changes for a dirtied file thats in the page
> cache.

Right.

> But I do not expect to loose the current (old) file on disk in that
> case, unless the crash happens when its actually written out at that
> time.

But you do, when it opens the old file and truncates it, that event is
logged and at which point the file is zero-length containing nothing.

The data hits the disk later on and the size is updated

If you lose power before then, you get zero length files.

> Actually I am considering to switch to ext3/4.

If it is what i explained above, you can still this this though it's
much harder.

Basically, developers shouldn't rewrite critical data in place.

(didn't Jim Gray say something like "Update in Place is a Poison
Apple"?)

> Is there interest in digging this?

Check how KDE writes out configuration files, strace might be easier
than figuring it out from the code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
