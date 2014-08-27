Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 522037F3F
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 18:08:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E32ACAC001
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 16:08:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YVZz4CpEKEn7VNyg for <xfs@oss.sgi.com>;
	Wed, 27 Aug 2014 16:07:35 -0700 (PDT)
Date: Thu, 28 Aug 2014 09:07:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount options question
Message-ID: <20140827230732.GN20518@dastard>
References: <3dc9caf6f9b415f6e4c0ebac1f1626d3@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3dc9caf6f9b415f6e4c0ebac1f1626d3@zbfmail.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Wed, Aug 27, 2014 at 12:14:21PM +0200, Marko Weber|8000 wrote:
> =

> sorry dave and all other,
> =

> can you guys recommend me the most stable / best mount options for
> my new server with ssd=B4s and XFS filesystem?
> =

> at moment i would set:  defaults,nobarrier,discard,logbsize=3D256k,noikeep
> or is just "default" the best solution and xfs detect itself whats best.
> =

> can you guide me a bit?
> =

> as eleavtor i set elevator=3Dnoop
> =

> i setup disks with linux softraid raid1. On top of the raid is LVM
> (for some data partations).
> =

> =

> would be nice to hear some tipps from you

Unless you have specific requirements or have the knowledge to
understand how the different options affect behaviour, then just use
the defaults.

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.=
3Csomething.3E

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
