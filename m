Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 568307F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 17:02:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E277304059
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 15:02:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1sH6rADPll5x4P28 for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 15:02:17 -0700 (PDT)
Date: Fri, 9 May 2014 08:02:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Remove xfs_check for 3.2.0?
Message-ID: <20140508220214.GF26353@dastard>
References: <536BCF95.201@sandeen.net> <20140508203936.GV5421@dastard>
	<536BEBD9.4060604@sandeen.net>
	<20140508230410.02b19431@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140508230410.02b19431@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 08, 2014 at 11:04:10PM +0200, Emmanuel Florac wrote:
> Le Thu, 08 May 2014 15:40:57 -0500 vous =E9criviez:
> =

> > *shrug* ok.  Let a thousand "hey my xfs_check OOM'd" emails
> > blossom! :)
> > =

> > FWIW, I did not have time to work on that prefetch bug yet today.  :(
> > =

> =

> Why not replace it by a script that simply states that it's useless and
> to run xfs_repair -n instead? It has been completely useless for the
> best part of the past ten years... This way you don't remove it but
> you'll sort of fix it :)

xfs_check is already just a script that wraps xfs_db.

However, there's all the man page updates, all the external
documentation needs to be updated, etc. IOWs, it's not just a case
of a simply patching out the xfs_check script....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
