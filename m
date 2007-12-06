Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Dec 2007 13:22:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB6LMSdS000420
	for <xfs@oss.sgi.com>; Thu, 6 Dec 2007 13:22:30 -0800
Date: Fri, 7 Dec 2007 08:22:25 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: assemble vs create an array.......
Message-ID: <20071206212225.GN115527101@sgi.com>
References: <474F869D.5040503@mpigani.org> <18255.41044.614676.410107@notabene.brown> <47501D7E.7000804@dgreaves.com> <475552D2.4000802@mpigani.org> <47568DE1.1050108@dgreaves.com> <4758129D.40600@mpigani.org> <475825C0.4070605@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475825C0.4070605@msgid.tls.msk.ru>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Dragos <dragos@mpigani.org>, David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Thu, Dec 06, 2007 at 07:39:28PM +0300, Michael Tokarev wrote:
> What to do is to give repairfs a try for each permutation,
> but again without letting it to actually fix anything.
> Just run it in read-only mode and see which combination
> of drives gives less errors, or no fatal errors (there
> may be several similar combinations, with the same order
> of drives but with different drive "missing").

Ugggh. 

> It's sad that xfs refuses mount when "structure needs
> cleaning" - the best way here is to actually mount it
> and see how it looks like, instead of trying repair
> tools. 

It self protection - if you try to write to a corrupted filesystem,
you'll only make the corruption worse. Mounting involves log
recovery, which writes to the filesystem....

> Is there some option to force-mount it still
> (in readonly mode, knowing it may OOPs kernel etc)?

Sure you can: mount -o ro,norecovery <dev> <mtpt>

But it you hit corruption it will still shut down on you. If
the machine oopses then that is a bug.

> thread prompted me to think.  If I can't force-mount it
> (or browse it using other ways) as I can almost always
> do with (somewhat?) broken ext[23] just to examine things,
> maybe I'm trying it before it's mature enough? ;)

Hehe ;)

For maximum uber-XFS-guru points, learn to browse your filesystem
with xfs_db. :P

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
