Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4E9B2R005045 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 08:09:14 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70C101BEF682
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 06:09:09 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id Xu52A9uZYDg5OA2V for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 06:09:09 -0800 (PST)
Date: Thu, 4 Dec 2008 15:20:15 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081204142015.GQ6703@one.firstfloor.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
	<20081204100050.GN6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

> the 1st write request ends with success
> the 2nd write request ends with -EOPNOTSUPP
> the 3rd write request ends with success
> 
> --- when you first see -EOPNOTSUPP, you have already corrupted filesystem 
> (the 3rd write passed while the filesystem expected that it would be 

There's no passing of requests during pvmove. It's a really strong
barrier.

> finished after the 2nd write) and you are in an interrupt context, where 
> you can't reissue -EOPNOTSUPP request. So what do you want to do?

The barrier aware file systems I know of just resubmit synchronously when 
a barrier fails.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
