Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9EEB17F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 07:31:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A366AC007
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 05:31:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SSw1fr7Xjcowx0ZP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 05 Sep 2014 05:31:02 -0700 (PDT)
Date: Fri, 5 Sep 2014 08:30:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
Message-ID: <20140905123058.GA29710@bfoster.bfoster>
References: <540986B1.4080306@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540986B1.4080306@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Sep 05, 2014 at 11:47:29AM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> i have a backup system running 20TB of storage having 350 million files.
> This was working fine for month.
> 
> But now the free space is so heavily fragmented that i only see the
> kworker with 4x 100% CPU and write speed beeing very slow. 15TB of the
> 20TB are in use.
> 
> Overall files are 350 Million - all in different directories. Max 5000
> per dir.
> 
> Kernel is 3.10.53 and mount options are:
> noatime,nodiratime,attr2,inode64,logbufs=8,logbsize=256k,noquota
> 
> # xfs_db -r -c freesp /dev/sda1
>    from      to extents  blocks    pct
>       1       1 29484138 29484138   2,16
>       2       3 16930134 39834672   2,92
>       4       7 16169985 87877159   6,45
>       8      15 78202543 999838327  73,41
>      16      31 3562456 83746085   6,15
>      32      63 2370812 102124143   7,50
>      64     127  280885 18929867   1,39
>     256     511       2     827   0,00
>     512    1023      65   35092   0,00
>    2048    4095       2    6561   0,00
>   16384   32767       1   23951   0,00
> 
> Is there anything i can optimize? Or is it just a bad idea to do this
> with XFS? Any other options? Maybe rsync options like --inplace /
> --no-whole-file?
> 

It's probably a good idea to include more information about your fs:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

... as well as what your typical workflow/dataset is for this fs. It
seems like you have relatively small files (15TB used across 350m files
is around 46k per file), yes? If so, I wonder if something like the
following commit introduced in 3.12 would help:

133eeb17 xfs: don't use speculative prealloc for small files

Brian

> Greets,
> Stefan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
