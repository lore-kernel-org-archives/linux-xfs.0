Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QCNHcc141886 for <xfs@oss.sgi.com>; Tue, 26 May 2009 07:23:17 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9F808F8039
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 05:23:27 -0700 (PDT)
Message-Id: <B5F3DA2A-EC30-4C28-9D94-18098D5BC43E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A184EC4.1050007@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] fix overflow in xfs_growfs_data_private
Date: Tue, 26 May 2009 07:23:26 -0500
References: <4A184EC4.1050007@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Richard Ems <Richard.Ems@cape-horn-eng.com>, xfs-oss <xfs@oss.sgi.com>


On May 23, 2009, at 2:30 PM, Eric Sandeen wrote:

> In the case where growing a filesystem would leave the last AG
> too small, the fixup code has an overflow in the calculation
> of the new size with one fewer ag, because "nagcount" is a 32
> bit number.  If the new filesystem has > 2^32 blocks in it
> this causes a problem resulting in an EINVAL return from growfs:
>
> # xfs_io -f -c "truncate 19998630180864" fsfile
> # mkfs.xfs -f -bsize=4096 -dagsize=76288719b,size=3905982455b fsfile
> # mount -o loop fsfile mnt/
> # xfs_growfs mnt/

Is it really 'mnt/', not '/mnt'?

>
> meta-data=/dev/loop0             isize=256    agcount=52,
> agsize=76288719 blks
>         =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=3905982455,  
> imaxpct=5
>         =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>         =                       sectsz=512   sunit=0 blks, lazy- 
> count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
>
> Reported-by: richard.ems@cape-horn-eng.com
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Nice find and the neat fix, Eric.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
