Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DFEC7F54
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 19:25:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC16BAC001
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 17:25:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3BAKuGUpqwkhT5GY for <xfs@oss.sgi.com>;
	Sun, 28 Jun 2015 17:25:03 -0700 (PDT)
Date: Mon, 29 Jun 2015 10:24:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Q: xfs_db: invalid numrecs (*) in bmapbtd block
Message-ID: <20150629002449.GD7943@dastard>
References: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
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
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Jun 28, 2015 at 09:44:20PM +0300, Timofey Titovets wrote:
> Good time of day list,
> i do regular check fragmentation on my servers and xfs_db show strange erros:
> 
> # xfs_db -c frag -r /dev/sdc1
> invalid numrecs (51914) in bmapbtd block

That's expected behaviour if you are running that on a mounted
filesystem. I'm assuming this is the case because you are telling
xfs_db to run in read only mode...

Why? Because an actively modified filesystem is only coherent on
disk when you consider all the modifications staged in the journal,
and xfs_db ignores the journal. Hence what it reads of disk is not
coherent and hence is not guaranteed valid.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
