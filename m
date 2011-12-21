Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBLMQT3M072043 for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 16:26:29 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ViXPQkGtw7bGG1Lh for <xfs@oss.sgi.com>;
	Wed, 21 Dec 2011 14:26:27 -0800 (PST)
Date: Thu, 22 Dec 2011 09:26:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
Message-ID: <20111221222623.GF23662@dastard>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EF21DD2.3060004@univ-nantes.fr>
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
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Wed, Dec 21, 2011 at 06:56:34PM +0100, Yann Dupont wrote:
> Le 21/12/2011 16:10, Stan Hoeppner a =E9crit :
> =

> =

> >1.  What mailbox format are you using?  Is this a constant or variable?
> =

> Maildir++

Which is what?

> >2.  Is the Dovecot rev and config the same everywhere, before/after?
> Yes
> >3.  Are Dovecot instances using NFS to access the XFS volumes?
> NO. direct LVM volumes from SAN
> >4.  Is this a  Dovecot 2.x cluster with director and NFS storage?
> >
> NO. This is dovecot plain & simple.
> =

> When I go back to older kernels, the load go down. With newer
> kernel, all is working well too, but load (as reported by uptime) is
> higher.

Can you run a block trace on both kernels (for say five minutes)
when the load differential is showing up and provide that to us so
we can see how the IO patterns are differing?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
