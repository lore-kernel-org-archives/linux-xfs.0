Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n190WDcF205950 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 18:32:14 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57B4218F1ADE
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 16:31:36 -0800 (PST)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id pnvgtdy1zmyuYtFu for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 16:31:36 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch 0/4] attr: test/ improvements and integrate with make
Date: Mon, 9 Feb 2009 01:31:32 +0100
References: <20090108021947.404730068@ifup.org>
	<200902090000.00162.agruen@suse.de>
	<20090208233837.GA446@jenkins.ifup.org>
In-Reply-To: <20090208233837.GA446@jenkins.ifup.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902090131.33240.agruen@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brandon Philips <brandon@ifup.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Monday, 9 February 2009 0:38:37 Brandon Philips wrote:
> On 23:59 Sun 08 Feb 2009, Andreas Gr=FCnbacher wrote:
> > On Saturday 07 February 2009 10:10:33 Brandon Philips wrote:
> > I believe it's a good start; we probably want to merge the trees
> > eventually. The way how you have moved libmisc breaks the tarballs
> > though; I have fixed it.
>
> Thanks. But, what do you mean by break the tarballs?

Here's what I got after ./Makepkgs:

	$ tar tfz build/attr-2.4.43.src.tar.gz
	attr-2.4.43/...
	libmisc/...
	attr-2.4.43/...

> > Sorry for being slow. I will first add the other acked distro patches,
> > then look at your changes.
>
> Great. Can we set a precedent that as patches get merged an email gets
> sent to xfs@oss.sgi.com still? If not I will just rss2email the git
> tree.

I haven't managed to set that up, yet.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
