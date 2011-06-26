Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5Q29Nxb165126
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 21:09:23 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 384A71764C97
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 19:09:21 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CdNrBJsRv1mfWrZg
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 19:09:21 -0700 (PDT)
Message-ID: <4E0694CC.8050003@hardwarefreak.com>
Date: Sat, 25 Jun 2011 21:09:16 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br>
In-Reply-To: <4E063BC6.9000801@task.com.br>
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
To: Marcus Pereira <marcus@task.com.br>
Cc: linux-xfs@oss.sgi.com

On 6/25/2011 2:49 PM, Marcus Pereira wrote:
> I have an issue when creating xfs volume using large agcounts on raid
> volumes.

Yes, you do have an issue, but not the one you think.

> /dev/md0 is a 4 disks raid 0 array:
> 
> ----------------------------------------
> # mkfs.xfs -V
> mkfs.xfs version 3.1.4
> 
> # mkfs.xfs -d agcount=1872 -b size=4096 /dev/md0 -f

mkfs.xfs queries mdraid for its parameters and creates close to the
optimal number of AGs, sets the stripe width, etc, all automatically.
The default number of AGs for striped mdraid devices is 16 IIRC, and
even that is probably a tad too high for a 4 spindle stripe.  Four or
eight AGs would probably be better here, depending on your workload,
which you did not state.  Please state your target workload.

At 1872 you have 117 times the number of default AGs.  The two main
downsides to doing this are:

1. Abysmal performance due to excessive head seeking on an epic scale
2. Premature drive failure due to head actuator failure

Now, the above assumes your "4 disks" are mechanical drives.  If these
are actually SSDs then the hardware won't suffer failures, but
performance will likely be far less than optimal.

Why are you attempting to create an insane number of allocation groups?
 What benefit do you expect to gain from doing so?

Regardless of your answer, the correct answer is that such high AG
counts only have downsides, and zero upside.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
