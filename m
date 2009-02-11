Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BDZilg131119 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 07:35:45 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73D6A1918F07
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 05:35:07 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id sjM0AmnZkBoBaUhJ for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2009 05:35:07 -0800 (PST)
Message-ID: <4992D3B7.7060101@sandeen.net>
Date: Wed, 11 Feb 2009 07:33:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: why does mkfs.xfs complain here?
References: <200902111310.53762@zmi.at>
In-Reply-To: <200902111310.53762@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> # mkfs.xfs -f -L ws1phptmp -b size=4096 -d su=65536,sw=4,agcount=4 -i attr=2 -l lazy-count=1,su=65536 /dev/sdf1
> log stripe unit specified, using v2 logs
> Allocation group size (65262) is not a multiple of the stripe unit (16)
>
> Why is above error generated at all? Shouldn't mkfs.xfs handle that 
> situation and change agsize automatically? 

Well, you constrained it fairly well. But I suppose this is a bug.

> If I then do:
> 
> # mkfs.xfs -f -L ws1phptmp -b size=4096 -d su=64k,sw=4,agsize=65262b -i attr=2 -l lazy-count=1,su=65536 /dev/sdf1
> log stripe unit specified, using v2 logs
> agsize rounded to 65264, swidth = 64
> meta-data=/dev/sdf1              isize=256    agcount=4, agsize=65264 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=261048, imaxpct=25
>          =                       sunit=16     swidth=64 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> So no problem using agsize instead agcount, where agcount complained
> about group size = 65262, which I then used without problem?

and then it chose 65264 instead.

all this is a little messy in mkfs.xfs, I suppose you've found a bug....

-Eric

> mfg zmi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
