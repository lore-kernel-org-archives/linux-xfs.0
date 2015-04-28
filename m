Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF8E67F37
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 15:54:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB1038F808E
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 13:54:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	aC8CKPUJtSpuPxD7 for <xfs@oss.sgi.com>;
	Tue, 28 Apr 2015 13:54:09 -0700 (PDT)
Date: Wed, 29 Apr 2015 06:53:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question: are the metadata crc elements ready for general use?
Message-ID: <20150428205345.GY21261@dastard>
References: <553FDFE0.7050800@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <553FDFE0.7050800@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 28, 2015 at 03:30:40PM -0400, Joe Landman wrote:
> I ask as I see this in the 3.2.2 mkfs.xfs command.  The default is
> to leave them off from what I can see on an mkfs.xfs.

Yes, and we've been discussing whether they should be made the
default in the upcoming 3.2.3 release or wait for 3.3.  IIRC, the
latest SLES release already defaults to using CRCs by default.

> root@unison:~/xfsprogs# mkfs.xfs /dev/sda
> meta-data=/dev/sda               isize=256    agcount=55,
> agsize=268435455 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=14627632640, imaxpct=1
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> But they are there, and I am curious as to the developers/users
> thoughts.  Will they break things (nfs, CIFS/samba)?

I enable them on all my systems, and almost all of my testing is
done with "-m crc=1,finobt=1" options set. The don't affect
applications at all - CRCs are completely transparent to userspace
so applications don't even know the filesystem is using them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
