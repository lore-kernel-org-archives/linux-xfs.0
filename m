Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45F057F37
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 13:56:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22A42304032
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 11:56:29 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2KHPkiDXhhtMu1MG for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 11:56:28 -0800 (PST)
Date: Mon, 18 Nov 2013 06:56:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfsprogs: suggest "-d" option for repair of RO mount
Message-ID: <20131117195614.GU6188@dastard>
References: <528261AD.50501@redhat.com>
	<20131113125921.GC24615@orion.maiolino.org>
	<52851CA9.8080903@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52851CA9.8080903@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Nov 14, 2013 at 12:55:37PM -0600, Eric Sandeen wrote:
> On 11/13/13, 6:59 AM, Carlos Maiolino wrote:
> > Hm, even in single user with a RO root filesystem, changing filesystem
> > on-disk filesystem structures without have them replied in memory looks
> > dangerous to me, you will keep data consistency since the fs is RO, but how
> > about memory? You might have a discrepancy between memory and disk metadata
> > contents causing in-memory only problems?
> > 
> 
> The possibility is already there; it's just a question of whether we
> suggest using it.  And my other patch suggests an immediate reboot
> when it's done, for just those reasons.

If you make the suggestion of using -d, then it should mention at
that point in time it's dangerous.

> A user needs some way to repair their root disk if they can't boot
> a rescue environment... and ext2/3/4 have been doing this since forever.
> 
> I know, none of the above are exactly arguments that its' safe... :)

Right, so let's make sure we don't give people any impression it is
safe :)

> >> +_("Unmount or use -d to repair a read-only mounted filesystem\n"));

_("Unmount or use the dangerous (-d) option to repair a read-only mounted filesystem\n"));

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
