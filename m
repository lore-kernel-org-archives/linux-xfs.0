Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANCT52a206860 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 06:29:05 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D79E413E538C
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 04:30:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	u21aC0M98ZHXvoKy for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 04:30:41 -0800 (PST)
Date: Tue, 23 Nov 2010 23:30:37 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: XFS performance oddity
Message-ID: <20101123123037.GA4851@amd>
References: <20101123122449.GA4812@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101123122449.GA4812@amd>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Tue, Nov 23, 2010 at 11:24:49PM +1100, Nick Piggin wrote:
> Hi,
> 
> Running parallel fs_mark (0 size inodes, fsync on close) on a ramdisk
> ends up with XFS in funny patterns.
> 
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
> id wa
> 24  1   6576 166396    252 393676  132  140 16900 80666 21308 104333  1 84 14  1
> 21  0   6712 433856    256 387080  100  224  9152 53487 13677 53732  0 55 45  0
>  2  0   7068 463496    248 389100    0  364  2940 17896 4485 26122  0 33 65  2
>  1  0   7068 464340    248 388928    0    0     0     0   66  207  0  0 100  0
>  0  0   7068 464340    248 388928    0    0     0     0   79  200  0  0 100  0
>  0  0   7068 464544    248 388928    0    0     0     0   65  199  0  0 100  0
>  1  0   7068 464748    248 388928    0    0     0     0   79  201  0  0 100  0
>  0  0   7068 465064    248 388928    0    0     0     0   66  202  0  0 100  0
>  0  0   7068 465312    248 388928    0    0     0     0   80  200  0  0 100  0
>  0  0   7068 465500    248 388928    0    0     0     0   65  199  0  0 100  0
>  0  0   7068 465500    248 388928    0    0     0     0   80  202  0  0 100  0
>  1  0   7068 465500    248 388928    0    0     0     0   66  203  0  0 100  0
>  0  0   7068 465500    248 388928    0    0     0     0   79  200  0  0 100  0
> 23  0   7068 460332    248 388800    0    0  1416  8896 1981 7142  0  1 99  0
>  6  0   6968 360248    248 403736   56    0 15568 95171 19438 110825  1 79 21  0
> 23  0   6904 248736    248 419704  392    0 17412 118270 20208 111396  1 82 17  0
>  9  0   6884 266116    248 435904  128    0 14956 79756 18554 118020  1 76 23  0
>  0  0   6848 219640    248 445760  212    0  9932 51572 12622 76491  0 60 40  0
> 
> Got a dump of sleeping tasks. Any ideas?

Oh, this is with a lot of kernel debug options, including xfs debugging
turned on. So it might not be an interesting performance measurement.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
