Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2BfKdm251483 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 05:41:21 -0600
Received: from mail-px0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CE5215A5244
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 03:41:51 -0800 (PST)
Received: from mail-px0-f174.google.com (mail-px0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	HuY5Woy9nb8mfLNX for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2009 03:41:51 -0800 (PST)
Received: by pxi4 with SMTP id 4so67453pxi.4
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2009 03:41:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B163B20.6030808@syseleven.de>
References: <4B163B20.6030808@syseleven.de>
Date: Wed, 2 Dec 2009 17:11:50 +0530
Message-ID: <921ca19c0912020341p1b8f5a95pb48882158540f8b6@mail.gmail.com>
Subject: Re: Performance problem with multiple parallel rm -rf's
From: Sujit K M <sjt.kar@gmail.com>
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
To: Jens Rosenboom <j.rosenboom@syseleven.de>
Cc: xfs@oss.sgi.com

This I think is not dependent on XFS. Most File systems tend to give bad
performance when multiple rm -rf is being run. I think the Linux(XFS or any) are
object based and tend to lock on the filesystem, but donot have any
exact knowledge
of the Level at which it is being held.

Thanks,
Sujit

On Wed, Dec 2, 2009 at 3:32 PM, Jens Rosenboom <j.rosenboom@syseleven.de> wrote:
> On a large 13TB XFS volume that is being used for backups, I am seeing bad
> performance if multiple "rm -rf" processes are running in parallel. The
> backups are being done with rsnapshot and the first operation it does is
> removing the oldest snapshot. A single rsnapshot does this in reasonable
> time, but if four jobs are started at the same time, all their rm processes
> run for hours without making much progress.
>
> This seems to be related to the planned optimizations in
>
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead
>
> Are there any other tuning options I might try? I'm already using
> "noatime,nodiratime,nobarrier,logbufs=8,logbsize=256k" as mount options and
> did enable lazy_counters for the fs.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
