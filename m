Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1NK7bur146089 for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 14:07:37 -0600
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id cC9tNKonmB7VRDMp
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Feb 2012 12:07:35 -0800 (PST)
Received: by wgbdy1 with SMTP id dy1so1078354wgb.32
	for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 12:07:34 -0800 (PST)
Message-ID: <4F469C7F.9020208@gmail.com>
Date: Thu, 23 Feb 2012 21:07:27 +0100
From: kadafax@gmail.com
MIME-Version: 1.0
Subject: Re: XFS, empty files after a crash
References: <4F4387A7.2070009@gmail.com>
	<20291.50554.414722.399249@tree.ty.sabi.co.UK>
	<4F445E9F.5030003@sandeen.net> <4F4695B1.4060202@houseofnate.net>
In-Reply-To: <4F4695B1.4060202@houseofnate.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


> kfx, try getting the inode number of the file (via stat or ls -i) and 
> then doing something like this:
>
> xfs_db -r $DEV -c "inode $INO" -c "bmap" 


# xfs_db -r /dev/sdc1 -c "inode 114748" -c "bmap"
data offset 0 startblock 1881705728 (7/2657536) count 6460 flag 0

# xfs_db -r /dev/sdc1 -c "inode 114754" -c "bmap"
data offset 0 startblock 1077794560 (4/4052736) count 6582 flag 0


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
