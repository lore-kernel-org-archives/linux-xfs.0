Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o64MovHX091917 for <xfs@oss.sgi.com>; Sun, 4 Jul 2010 17:50:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFD23118920B
	for <xfs@oss.sgi.com>; Sun,  4 Jul 2010 15:59:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	37lNzGb0GP6tyLsC for <xfs@oss.sgi.com>;
	Sun, 04 Jul 2010 15:59:02 -0700 (PDT)
Date: Mon, 5 Jul 2010 08:53:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
Message-ID: <20100704225341.GY24712@dastard>
References: <4C26A51F.8020909@tlinx.org> <201007011025.04391@zmi.at>
	<20100702024235.GX24712@dastard> <201007020821.51753@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007020821.51753@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Jul 02, 2010 at 08:21:51AM +0200, Michael Monnerie wrote:
> On Freitag, 2. Juli 2010 Dave Chinner wrote:
> > So it's the rsync daemon on saturn that is doing all the IO?
> 
> Yes.
>  
> > > I rsynced today 3 times, twice with the openSUSE kernel and once
> > > with 2.6.34, no problem. Sorry (or maybe "lucky me"?).
> > >
> > > > > 852c268f-cf1a-11de-b09b-806e6f6e6963.vhd* ??????????? ? ?    ?
> > > > >       ?            ? 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd
> > > >
> > > > On the source machine, can you get a list of the xattrs on the
> > > > inode?
> > >
> > > How would I do that? "getfattr" on that file gives no return, does
> > > that mean it doesn't have anything to say? I never do that things,
> > > so there shouldn't be any attributes set.
> > 
> > "getfattr -d"
> 
> Sorry, doesn't work:
> 
> # getfattr -d 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd
> getfattr: 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd: Structure needs 
> cleaning

I meant run it on an uncorrupted version of the file, but I don't
think that information is needed now...

> > The first character of the name is bad, everything after that -
> > including the attribute value - is identical to that on other
> > inodes.  What this implies is that we've overwritten the start of
> > the attribute fork with something, and that looks exactly like the
> > swap extents problems that we've fixed recently....
> > >
> > > Yes, xfs_fsdr was running. Disabled it now, and compiled and
> > > changed to kernel 2.6.34 now. Hope that's OK ;-)
> > 
> > Ok, so we have identified a potential cause. Either disabling fsr or
> > upgrading to 2.6.34 should be sufficient to avoid the problem. If no
> > problem show up now you are on 2.6.34, then I'd switch fsr back on
> > and see if they show up again...
> 
> So far, so good. I'm on 2.6.34 now. Is there any chance for a fixed 
> version of xfs_repair, so that I can either get rid of the 4 broken 
> files (i.e. delete them), or repair the filesystem? ATM, xfs_repair 
> asserts on this filesystem.

What version of xfs_repair? v3.1.2 does not assert fail here on the
metadump image you posted, but it does take 3 runs to fix up all the
problems with the busted inodes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
