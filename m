Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1KLC7rY104900 for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 15:12:07 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E644D2EC1F0
	for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 13:14:48 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id S6zei36s3HBrlEyK for <xfs@oss.sgi.com>;
	Sun, 20 Feb 2011 13:14:48 -0800 (PST)
Message-ID: <4D618447.20101@sandeen.net>
Date: Sun, 20 Feb 2011 15:14:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: First 128KB of XFS partition is NULL.
References: <AANLkTindiB_D7shZKkrdkePM=xaAXCe1HAX5tPy87SCy@mail.gmail.com>
	<AANLkTi=YJVGXrY=Jy7p1_AdPnNKWqtmbdkTXy32QP3vt@mail.gmail.com>
In-Reply-To: <AANLkTi=YJVGXrY=Jy7p1_AdPnNKWqtmbdkTXy32QP3vt@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On 2/19/11 8:45 PM, Ajeet Yadav wrote:
> Testing team provides a very little information, but after checking
> all possiblity I cam to conclusion that he may have removed the USB
> during formating when mkfs.xfs just finished "Zero out the beginning
> of the device, to obliterate any old filesystem signatures out there"

That sounds plausible...

Just for reference, there are runtime checks to be sure we don't overwrite
block zero due to bad mappings; see "Access to block zero" message in
xfs_cmn_err_fsblock_zero() and xfs_bmap_search_extents()

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
