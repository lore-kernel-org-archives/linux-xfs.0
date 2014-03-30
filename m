Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C957129DFE
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 18:46:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B72DF304039
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 16:46:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Q6zQuZBsylzIYXrn for <xfs@oss.sgi.com>;
	Sun, 30 Mar 2014 16:46:26 -0700 (PDT)
Date: Mon, 31 Mar 2014 10:46:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs help question
Message-ID: <20140330234623.GC16336@dastard>
References: <6997ecc6ee5c7096ded12e8ad3d77d12@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6997ecc6ee5c7096ded12e8ad3d77d12@zbfmail.de>
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
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Sun, Mar 30, 2014 at 09:12:20AM +0200, Marko Weber|8000 wrote:
> 
> hello again me ;-),
> i thought best place to ask this is here.
> i read the faq alot last days but have still questions:
> 
> i got a server now with 4 Disks,
> i plan to do an raid5 with linux soft raid.
> On the server is planed to store 'larger' from 1GB up to 60GB.
> 
> what would be best settings when formatting with xfs?
> is it better to use '-b size=4096' or the '512'?
> should i manipulate the '-i size=' to 2048? or use the default?

Use the defaults.  The defaults on md/dm raid will do the right
things to configure the filesystem and handle crash safety properly.

Unless you have experience with XFS and the storage stack and know
exactly what you *need to do*, tweaking knobs will only cause bad
things to happen to you and your data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
