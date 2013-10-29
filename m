Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C2687F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 14:56:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2493D8F8052
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 12:56:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cWAsLDQJocklEUgd for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 12:56:04 -0700 (PDT)
Date: Wed, 30 Oct 2013 06:55:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS real-time allocator
Message-ID: <20131029195531.GA6188@dastard>
References: <CAD+1EGMos6SgyKDAKc8LHajUMbd9acZ9ghKCG=ksKZnhTxawDw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD+1EGMos6SgyKDAKc8LHajUMbd9acZ9ghKCG=ksKZnhTxawDw@mail.gmail.com>
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
To: harryxiyou <harryxiyou@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 29, 2013 at 10:35:06PM +0800, harryxiyou wrote:
> Hi all,
> 
> I have created a real-time partition as follows.
> 
> root@node2:~# mkfs.xfs -f -r rtdev=/dev/sda3 /dev/sda4
> 
> meta-data=/dev/sda4              isize=256    agcount=4, agsize=56122440 blks
> 
>          =                       sectsz=512   attr=2, projid32bit=0
> 
> data     =                       bsize=4096   blocks=224489757, imaxpct=25
> 
>          =                       sunit=0      swidth=0 blks
> 
> naming   =version 2              bsize=4096   ascii-ci=0
> 
> log      =internal log           bsize=4096   blocks=109614, version=2
> 
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> 
> realtime =/dev/sda3              extsz=4096   blocks=14865657,
> rtextents=14865657
> 
> 
> I wonder how to use its real-time feature. And I should call some interfaces
> supported by XFS in the user/kernel-space, right?

$ man xfsctl

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
