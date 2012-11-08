Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8L0mQQ022712 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 15:00:48 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WwQo5jMDnQvPj8Bu for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 13:02:46 -0800 (PST)
Date: Fri, 9 Nov 2012 08:02:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
Message-ID: <20121108210210.GP6434@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
	<CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
	<CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Aaron Goulding <aarongldng@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 08, 2012 at 07:16:06AM -0800, Aaron Goulding wrote:
> Well I found an error in my bgrep. I was searching for XFSB but in the
> wrong order. Once fixed, I get almost 19,000 results, but I note most of

That seems like way too many to be filesystem metadata hits. I woul
dhave expected the same number of hits as there are AGs in the
filesytem. What you want is the XFSB string in the first 4
bytes of a sector, with the next sector having XAGF as the first
four bytes....


> those results happen within one section on the drive. I've attached the
> first 1MB from that point (4398047346688 bytes in) and I will grab the
> other results as 1K blocks.

I'm not going to look at 19000 potential hits. Narrow it down to
likely candidates first whithe the sector location filter...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
