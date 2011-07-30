Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6U9wFFp120444 for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 04:58:15 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 156511854483
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 02:58:13 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id 1JvGfZ0vEEhu5dLA for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2011 02:58:13 -0700 (PDT)
Date: Sat, 30 Jul 2011 05:58:13 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <alpine.DEB.2.02.1107291820560.25432@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1107300553300.10141@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
	<alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
	<20110727193937.GA5354@infradead.org>
	<alpine.DEB.2.02.1107271540100.1451@p34.internal.lan>
	<20110727194722.GA9345@infradead.org>
	<1311799021.25645.41.camel@lade.trondhjem.org>
	<1311800051.25645.43.camel@lade.trondhjem.org>
	<1311800195.25645.45.camel@lade.trondhjem.org>
	<alpine.DEB.2.02.1107271723500.25432@p34.internal.lan>
	<alpine.DEB.2.02.1107271844100.25432@p34.internal.lan>
	<1311886137.27285.2.camel@lade.trondhjem.org>
	<4E331D86.7060801@netapp.com>
	<alpine.DEB.2.02.1107291656340.25432@p34.internal.lan>
	<1311977016.16078.10.camel@lade.trondhjem.org>
	<alpine.DEB.2.02.1107291820560.25432@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Bryan Schumaker <bjschuma@netapp.com>



On Fri, 29 Jul 2011, Justin Piszcz wrote:

> 
> 
> On Fri, 29 Jul 2011, Trond Myklebust wrote:
> 
> > On Fri, 2011-07-29 at 16:59 -0400, Justin Piszcz wrote:
> >> On Fri, 29 Jul 2011, Bryan Schumaker wrote:
> >>
> >>> How does this look for printing out more information when a cookie loop is detected?  Is there anything else that should be printed out?  My patch applies on top of Trond's from yesterday.
> >>
> >>
> >> Hi,
> >>
> >> This fails against 2.6.38:
> >>
> >> patching file fs/nfs/dir.c
> >> Hunk #1 FAILED at 134.
> >> Hunk #2 FAILED at 173.
> >> Hunk #3 FAILED at 323.
> >> Hunk #4 FAILED at 336.
> >> Hunk #5 FAILED at 349.
> >> Hunk #6 succeeded at 320 (offset -48 lines).
> >> Hunk #7 FAILED at 741.
> >> Hunk #8 succeeded at 716 (offset -59 lines).
> >> Hunk #9 succeeded at 749 (offset -59 lines).
> >> Hunk #10 succeeded at 763 (offset -59 lines).
> >> 6 out of 10 hunks FAILED -- saving rejects to file fs/nfs/dir.c.rej
> >> patching file include/linux/nfs_fs.h
> >> Hunk #1 FAILED at 99.
> >> 1 out of 1 hunk FAILED -- saving rejects to file include/linux/nfs_fs.h.rej
> >> atom:/usr/src/linux#
> >>
> >> And the 3.0 kernel is broken for my wireless adapter:
> >> http://www.gossamer-threads.com/lists/linux/kernel/1411576
> >>
> >> If you can make a combined patch for 2.6.38 I can try it, 2.6.39+ have a
> >> horrible driver (rt2800usb) and 1 person emailed me as well stating the
> >> same thing off-list (they stick with the manufacturer's driver or the *sta
> >> one).
> >
> > I don't understand. The readdir loop detection code was first merged
> > upstream in 2.6.39. 2.6.38 doesn't report any loops...
> 
> Hi,
> 
> Sorry--(my error) this is meant for the client, patched & will e-mail when 
> it happens again.
> 
> # patch -p1 < /home/jpiszcz/patch1
> patching file fs/nfs/dir.c
> patching file include/linux/nfs_fs.h
> 
> # patch -p1 < /home/jpiszcz/patch2
> patching file fs/nfs/dir.c
> 
> (recompile->reboot->waiting for next error)
> 
> Justin.

So I have been running Linux 2.6.37-(.. 3.0 recently) since Jan of this year on these new hosts and I have never had so much as a kernel OOPS, with these 
patches, there were several kernel lockups/problems but the nfs/loop did 
not show up.

I've went back to the previous (non-patched) kernel, is there a less invasive
patch?

http://home.comcast.net/~jpiszcz/20110730/kernel-error.txt

Justin.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
