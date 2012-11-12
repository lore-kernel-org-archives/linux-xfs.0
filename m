Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAC92pg0210286 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 03:02:51 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8gQPc4CxbS5VYzxv for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 01:04:52 -0800 (PST)
Date: Mon, 12 Nov 2012 20:04:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slow performance after ~4.5TB
Message-ID: <20121112090448.GS24575@dastard>
References: <50A0AFD5.2020607@iv.lt>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A0AFD5.2020607@iv.lt>
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
To: Linas Jankauskas <linas.j@iv.lt>
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2012 at 10:14:13AM +0200, Linas Jankauskas wrote:
> Hello,
> 
> we have 30 backup servers with 20TB backup partition each.
> While server is new and empty rsync is compying data prety fast, but
> when it reaches about 4.5TB write operation become very slow (about 10
> times slower).
> 
> I have attached cpu and disk graphs.
> 
> As you can see first week, while server was empty, rsync was using "user"
> cpu and data copying was fast. Later rsync started to use "system" cpu
> and data copying became much slower. Same situation is on all our backup
> servers. Before we had used smaller partition with ext4 and we had no
> problems.
> 
> Most time rsync is spending on ftruncate:
> 
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  99.99   18.362863      165431       111           ftruncate
>   0.00    0.000712           3       224       112 open
>   0.00    0.000195           1       257           write
>   0.00    0.000171           1       250           read
>   0.00    0.000075           1       112           lchown
>   0.00    0.000039           0       112           lstat
>   0.00    0.000028           0       112           close
>   0.00    0.000021           0       112           chmod
>   0.00    0.000011           0       396           select
>   0.00    0.000000           0       112           utimes
> ------ ----------- ----------- --------- --------- ----------------
> 100.00   18.364115                  1798       112 total

Never seen that before. More info needed. Start here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

And we can go from there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
