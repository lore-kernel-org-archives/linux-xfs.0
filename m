Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CDMUCU039715 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 08:22:30 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C6AAC03BF1
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 06:23:58 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 7epNRdUVNabzU8Ks for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 06:23:58 -0700 (PDT)
Message-ID: <4AD32DED.4050402@sandeen.net>
Date: Mon, 12 Oct 2009 08:23:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown
References: <CEBA5E865263FA4D8848D53D92E6A9AE0412EC23@DAKLAK.cybersoft-vn.com>
In-Reply-To: <CEBA5E865263FA4D8848D53D92E6A9AE0412EC23@DAKLAK.cybersoft-vn.com>
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
To: Hieu Le Trung <hieult@Cybersoft-VN.com>
Cc: xfs@oss.sgi.com

Hieu Le Trung wrote:
> Hi,
> 
> What may cause metadata becomes bad? I got xfs_force_shutdown with 0x2
> parameter.

Software bugs or hardware problems.  If you provide the actual kernel 
message we can offer more info on what xfs saw and why it shut down.

> How can I analyze the metadata dump file?

the metadump file is just the metadata skeleton of the filesystem; you 
can mount it, repair it, point xfs_db at it to debug it, etc.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
