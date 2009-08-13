Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7D3GcK1248043 for <xfs@oss.sgi.com>; Wed, 12 Aug 2009 22:16:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59856149FBE3
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2009 20:17:14 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id QctMYnZTMoAZOgyz for
	<xfs@oss.sgi.com>; Wed, 12 Aug 2009 20:17:14 -0700 (PDT)
Message-ID: <4A838598.4000608@sandeen.net>
Date: Wed, 12 Aug 2009 22:16:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: free space of root partition decreases unaccountably by some
	1024	blocks on every umount+linux shutdown
References: <200908121955.07682.edvx1@systemanalysen.net>
In-Reply-To: <200908121955.07682.edvx1@systemanalysen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

Roland Eggner wrote:
> History which lead to actual problem
> ------------------------------------
> On July 4th I switched from kernel 2.6.29.5 to 2.6.29.6.
> =

> On July 18th I noticed the first time this unaccountable decrease of free=
 space of my root partition /dev/hda7:
> For at least several boot-shutdown-cycles it has decreased on every cycle=
 by some 1020 =85 1030 blocks from originally above 100 MB to 96 MB.
> Expected change at most =B11 block.  Neither xfs_check nor xfs_repair -dn=
 could detect any flaws.

Maybe I missed it in the email, but how have you ruled out the
possibility that files are simply growing, thereby using the space?

Have you compared

# ls -laR /

and/or

# du -hcx /

between a couple of boots?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
