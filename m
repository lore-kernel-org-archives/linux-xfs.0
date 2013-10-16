Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 65A227F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 10:05:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58B908F804B
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:05:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id U2o27lYjNZcVv2bW for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 08:05:00 -0700 (PDT)
Message-ID: <525EAB1C.6020504@sandeen.net>
Date: Wed, 16 Oct 2013 10:05:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS - configuration for multi-thread high-speed streams
References: <C08036CF9E2BAC498EFDA29CB9BDF25B34B9D1E06D@dc-ex1.power.com>
In-Reply-To: <C08036CF9E2BAC498EFDA29CB9BDF25B34B9D1E06D@dc-ex1.power.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Jensen <Mike.Jensen@dothill.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 10/15/13 3:45 PM, Mike Jensen wrote:
> Hi Group - 1^st time post, looks like just use the email address I have s=
een from other posts
> =

> If the setup/info/questions below are not suitable for this list, is ther=
e another xfs list available for these??
> =


User questions are appropriate here, but since this is a Red Hat distro ker=
nel, not upstream, it's probably better to engage Red Hat for information o=
n optimal tuning of something like this.

-Eric

> =

> Thanks
> =

> mike
> =

>  =

> =

> Configuration =96
> =

>  =

> =

> -          RH 6.4 on HP G8 server w/16GB mem (could add a lot more)
> =

> -          12Gb SAS connections (2) to storage
> =

> -          Storage
> =

> -          96 LFF HDD=92s (4TB 7K NLSAS) presently organized as 8 x 10+2 =
R6 raidsets
> =

> -          8 volumes mapped to host ports (MPIO engaged)
> =

> -          Mdadm used to stripe (/dev/dm*) LUNs into a single md device (=
approx. 300+TB file system space)
> =

> -          Mkfs.xfs used to lay down file system
> =

> -           =

> =

> -          Workload
> =

> -          Application creates file of specified length in dir of mount p=
oint, IO=92s then issued to file(s), each file receives 1 stream of IO
> =

> -          1 x high speed stream 1000MB/s Seq W (IO=92s arrive as 512KB -=
=3D> 4MB frame would be 8 x 512KB IO=92s)
> =

> -          2 x med-speed streams 200MB/s Seq W =93
> =

> -          30-50 low speed streams 10MB/s Seq W =93
> =

>  =

> =

> Objectives/Questions =96
> =

>  =

> =

> -          Would like to optimize xfs/mount parameters to make maximal us=
e of storage assets
> =

> -          Thinking of using 15K HDD R1 set for log files =96 would this =
get all/most of metadata or just a subset?  Right now seeing metadata write=
s arriving with data writes and want to peel them off the 7K HDD=92s
> =

> -          Would using sub-directories for each file ensure that each sub=
dir/file would be in it=92s own alloc group? And that would keep the stream=
ing data in a separate AG =96 could help the storage more efficiently desta=
ge the writes from cache to disk
> =

>  =

> =

> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
