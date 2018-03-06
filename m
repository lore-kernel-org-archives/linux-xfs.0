Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753065AbeCFUtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 15:49:11 -0500
Date: Tue, 6 Mar 2018 12:49:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/16] xfs_db: add a superblock info command
Message-ID: <20180306204904.GJ18989@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993165958.22223.10507415725288169958.stgit@magnolia>
 <20edb4dd-80c4-76e6-d63d-09c6553b5c29@sandeen.net>
 <777384a3-90de-4715-21fc-a3f7b45387d8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <777384a3-90de-4715-21fc-a3f7b45387d8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org

On Tue, Mar 06, 2018 at 01:34:42PM -0600, Eric Sandeen wrote:
> 
> 
> On 3/6/18 1:32 PM, Eric Sandeen wrote:
> > On 3/1/18 1:14 PM, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> Add an 'info' command to pretty-print the superblock geometry.
> > I'm on the fence about this; xfs_db generally just dumps representations
> > of individual disk structures.  This seems like a bit of an expansion of
> > its charter.  What is the use case for this?  Convince me that it's good
> > to add this code?

I occasionally (well ok pretty much every time) wish that when I'm
debugging an umountable filesystem w/ xfs_db I could just have it spit
out the familiar xfs_info output to figure out which features of the
user-visible features are enabled.

For xfstests there have been a few times where I'm writing some test and
it would be helpful to be able to figure out if the formatted image has
some feature enabled without having to mount the filesystem, and
wouldn't it be nice if we could reuse the same code that turns mkfs
output into environment variables?

That's a pretty minor use case though since I've so far always found a
way to code around the lack of it. :P  My primary itch is the debugging
case.

> > 
> > Thanks,
> > -Eric
> > 
> 
> Sorry - of course later patches make xfs_info work offline, but still,
> I'd like to see some rationale for why we need that capability.  I'm all
> for the code reduction of the common printing routine but what's the big
> picture rational for teaching all these other tools to print mkfs-like output?

Growing the filesystem falls under the umbrella of space management, so
in the long run (like after I finish putting online repair in) I intend
to make growfs a part of xfs_spaceman, and then the xfs_growfs command
becomes a wrapper around that.  Looking forward towards Dave's subvolume
thingy, I think it makes sense to be able to manage subvolumes entirely
via spaceman commands.

--D

> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
