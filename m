Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:20195 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754172AbcK1VhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 16:37:13 -0500
Date: Tue, 29 Nov 2016 08:37:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: New package locations of xfsprogs vs. xfsdump
Message-ID: <20161128213709.GC28177@dastard>
References: <583C5CDC.6050009@applied-asynchrony.com>
 <a588c917-945f-30ab-59f6-946a31b96e19@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a588c917-945f-30ab-59f6-946a31b96e19@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org

On Mon, Nov 28, 2016 at 12:00:12PM -0600, Eric Sandeen wrote:
> On 11/28/16 10:35 AM, Holger Hoffstätte wrote:
> > Hi,
> > 
> > I just bumped my xfsprogs on Gentoo to 4.8.0 to use the new download location
> > at kernel.org and noticed that xfsdump is still at sgi.com, even though it has
> > an empty directory at https://www.kernel.org/pub/linux/utils/fs/xfs/xfsdump/.
> > 
> > Is xfsdump supposed to be there as well or has that migration just not
> > happened yet? Just asking for packaging reasons.
> 
> It's just that there hasn't been a release since the move.  New versions
> should land on kernel.org.
> 
> I think Dave was looking into rebuilding and re-releasing old versions
> onto kernel.org, but I'm not sure if that has progressed.

No, I haven't made progress on that. Let me see if I've got the
original release tarballs for recent xfsdump releases still around
on my build machine. If I have, then I'll be able to resign and
upload them, otherwise I'll have to spend the time to regenerate
them.

In the mean time, just pull the git tree and set the head to the
release tag, and it will give you the same result...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
