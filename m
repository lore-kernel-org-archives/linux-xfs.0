Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AD5Knu093472 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:05:21 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9CAACBC16C
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 06:12:51 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[83.64.48.195]) by cuda.sgi.com with ESMTP id Emzf6XPuMpb0KKLk
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 06:12:51 -0700 (PDT)
Message-ID: <4A2FAFA0.9020408@dermichi.com>
Date: Wed, 10 Jun 2009 15:05:36 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfs_growfs doesn't grow on 2TB raid
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>	<00ee01c9e9c5$4cf36b20$e6da4160$@monnerie@is.it-management.at>
	<BAY108-W43AAADA49E758366E8F23AF3450@phx.gbl>
In-Reply-To: <BAY108-W43AAADA49E758366E8F23AF3450@phx.gbl>
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
To: jack the ripper <evil_metalpeet@hotmail.com>
Cc: xfs@oss.sgi.com

> Can you confirm that I need GPT for my software raid?
You don't need GPT for software RAID unless one of your disks is >2TB. For example I am running a 3TB XFS file system directly on /dev/md0. Have you done a reboot, maybe the new size has not really been applied? Never tried it with LUKS/cryptsetup though, maybe it won't to above 2GB.

# df -h /dev/md0
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              2.8T  1.5T  1.4T  53% /san1

hth Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
