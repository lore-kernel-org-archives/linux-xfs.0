Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4EHAFq006731 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 08:17:10 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C992169574F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 06:17:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id 1FnzrhodoUTQHSCv for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 06:17:08 -0800 (PST)
Date: Thu, 4 Dec 2008 09:17:04 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
In-Reply-To: <20081204142015.GQ6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
	<20081204100050.GN6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
	<20081204142015.GQ6703@one.firstfloor.org>
MIME-Version: 1.0
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, xfs@oss.sgi.com

On Thu, 4 Dec 2008, Andi Kleen wrote:

> > the 1st write request ends with success
> > the 2nd write request ends with -EOPNOTSUPP
> > the 3rd write request ends with success
> > 
> > --- when you first see -EOPNOTSUPP, you have already corrupted filesystem 
> > (the 3rd write passed while the filesystem expected that it would be 
> 
> There's no passing of requests during pvmove. It's a really strong
> barrier.

You start pvmove. The filesystem doesn't know about pvmove.

The next time filesystem does somethig, it submits these 3 requests and 
the 2nd fill unexpectedly fail.

So the fact that pvmove drains the request queue won't help you.

> > finished after the 2nd write) and you are in an interrupt context, where 
> > you can't reissue -EOPNOTSUPP request. So what do you want to do?
> 
> The barrier aware file systems I know of just resubmit synchronously when 
> a barrier fails.

... and produce structure corruption for certain period in time, because 
the writes meant to be ordered are submitted unordered.

Mikulas

> -Andi
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
