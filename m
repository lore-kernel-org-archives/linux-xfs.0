Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PDwPoU004366 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 08:58:26 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F3D8939D6
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 06:58:23 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id M6ze4SxfyuFXU6Ez
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 06:58:23 -0700 (PDT)
Message-ID: <4E2D767D.3020801@hardwarefreak.com>
Date: Mon, 25 Jul 2011 08:58:21 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 1 Gb Ethernet based HPC storage deployment plan
References: <CAOJJ1Zp821vD0JbGf5PuNGcW4VX4E_3SfcWYxVA4es2o0pyJXQ@mail.gmail.com>	<CAOJJ1ZpL89-3xrhJTQgO97AebSSgnmfyM+mah75XOWiyi-wHwQ@mail.gmail.com>	<20110723113027.162de009@galadriel.home>	<4E2BBC00.50902@hardwarefreak.com>
	<CAOJJ1Zod9BgFCOZkav3zYy3k2wR9ohiN0U0R0sr1QdW5CWzV6g@mail.gmail.com>
In-Reply-To: <CAOJJ1Zod9BgFCOZkav3zYy3k2wR9ohiN0U0R0sr1QdW5CWzV6g@mail.gmail.com>
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
To: Lee Eric <openlinuxsource@gmail.com>
Cc: xfs@oss.sgi.com

On 7/25/2011 6:52 AM, Lee Eric wrote:
> Thanks mates. So the typical storage solution for the small size
> cluster may use IP SAN as I know before. Yes, I can export the data by
> using NFS directly without iSCSI/AoE but is there any good point to
> use XFS? I just know XFS is better for parallelized read/write
> operations in local disks.
> 
> By the way, is there any good advantage to use XFS as the underlying
> local filesystem for cluster/distributed/parallel filesystem?

Narrow down your candidate list of distributed filesystems and read the
documentation for each of them.  I'd guess that each one of them has a
recommendation of some sort for the local storage node filesystem and
the reasoning behind the recommendation.  Given the manner in which most
of them derive their parallel performance, the local filesystem is
likely not critical.

You mentioned an IP SAN.  Have you looked at GFS2 and OCFS?  You haven't
mentioned a workload.  We could better serve you if you described the
workload.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
