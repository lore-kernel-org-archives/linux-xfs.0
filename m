Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OEkCbP157913 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 09:46:12 -0500
Received: from vwp1161.webpack.hosteurope.de (vwp1161.webpack.hosteurope.de
	[87.230.104.173]) by cuda.sgi.com with ESMTP id
	oIFq7oh1yVIbb8mz for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 07:47:28 -0700 (PDT)
Message-ID: <5060727D.4000009@blafoo.org>
Date: Mon, 24 Sep 2012 16:47:25 +0200
From: Volker <mail@blafoo.org>
MIME-Version: 1.0
Subject: Re: OOM on quotacheck (again?)
References: <5059D2B4.8010300@blafoo.org> <20120919205924.GC31501@dastard>
	<505AE2A1.5060703@blafoo.org> <20120924132113.GL20960@dastard>
In-Reply-To: <20120924132113.GL20960@dastard>
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
Cc: xfs@oss.sgi.com

Hi,

>> Could you slightly elaborate on that or give me a link or two which
>> explain the matter?
> 
> The kernel segment is limited to 960MB of RAM on ia32 bit machines
> unless you build with special config options that allow for up to
> 3GB of kernel memory. The trade off is that you've only got 4GB of
> RAM in teh process address space, so by default you have 3GB of RAM
> for each process (i.e. 960MB/3GB kernel/user split). If you change
> that to a 3GB/1GB split, you'll have problems with applications
> that are memory hogs running out of memory.

Interesting!

> As to the memory used by the inode cache, inodes tend to use between
> 1-1.5k of RAM each. Hence for a 960MB kernel segment, you *might* be
> able to cache 500,000 inodes if you don't cache anything else.
> Typically it will be 25-30% of that number (200-300MB of RAM in
> caching inodes during filesystem traversal). Seeing as you have
> millions of inodes, that's way more than you can cache in available
> kernel memory... 

Great! That answered all my questions! Thanks a lot!

3.6.0-rc6-x64 ist currently running fine on 6 machines.

-volker

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
