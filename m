Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p598DX3t160248 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 03:13:33 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 848BC4AE33A
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 01:13:32 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id SNG7xumTbXIfrqYo
	for <xfs@oss.sgi.com>; Thu, 09 Jun 2011 01:13:32 -0700 (PDT)
Message-ID: <4DF080AC.2090507@hardwarefreak.com>
Date: Thu, 09 Jun 2011 03:13:32 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Defragging XFS File Systems
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
	<BANLkTikBSL8-eTAbF7a94ckLuZNyWCM=Eg@mail.gmail.com>
	<4DEFE2E6.9010206@hardwarefreak.com> <201106090749.37745@zmi.at>
In-Reply-To: <201106090749.37745@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Kenneth Emerson <kenneth.emerson@gmail.com>, xfs@oss.sgi.com

On 6/9/2011 12:49 AM, Michael Monnerie wrote:
> On Mittwoch, 8. Juni 2011 Kenneth wrote:
>>> After that, I will make
>>> a cron job to run on a regular basis to keep the volume from
>>> getting so fragmented again.
> 
> How will you do that? Running xfs_fsr on a regular basis is *not* 
> recommended, as it will age your filesystem and defrag free space. In 
> the beginning, and as long as your filesystem is maybe 50% full it will 
> be fine, but there's a point where it starts to get worse - much worse. 
> Just run a recent kernel, it has all the naughty stuff to help keep the 
> performance high.

When *is* running xfs_fsr recommended?

I scheduled it twice a week some time ago due to a filesystem containing
active mbox files.  I did so because they became so heavily fragmented
in short order, especially those swallowing copious amounts of list
mail.  Before cron'ing xfs_fsr I was seeing mbox files with over 1000
fragmented extents, and increasing MUA latency as the files became more
fragmented.  The filesystem is currently 90% free.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
