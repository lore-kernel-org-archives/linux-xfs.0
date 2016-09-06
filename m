Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED7AB7CA7
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 18:34:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63835AC003
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 16:34:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2Nd4mfXBGYACXSBh for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2016 16:34:20 -0700 (PDT)
Date: Wed, 7 Sep 2016 09:34:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
Message-ID: <20160906233418.GM30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
	<58974432.234567.1473198839605.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <58974432.234567.1473198839605.JavaMail.zimbra@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 05:53:59PM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > Fundamentally a splice infrastructure problem. If we let splice race
> > with hole punch and other fallocate() based extent manipulations to
> > avoid this lockdep warning, we allow potential for read or write to
> > regions of the file that have been freed. We can live with having
> > lockdep complain about this potential deadlock as it is unlikely to
> > ever occur in practice. The other option is simply not an acceptible
> > solution....
> The problem with living with having this lockdep complain that
> it seems once this lockdep happens, it will prevent other complains from
> showing up. For example, I have to apply the commit dc3a04d to fix an early
> rcu lockdep first during the bisecting.

Not my problem.

My primary responsibility is to maintain the filesystem integrity
and data safety for the hundreds of thousands (millions?) of XFS
users: it's their data, and I will always err on the side of safety
and integrity. As such I really don't care if there's collateral
damage to developer debug tools - user data integrity requirements
always come first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
