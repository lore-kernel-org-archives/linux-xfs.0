Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p98DICJ8050216 for <xfs@oss.sgi.com>; Sat, 8 Oct 2011 08:18:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9321F1B92B8
	for <xfs@oss.sgi.com>; Sat,  8 Oct 2011 06:18:11 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	y9vAh9vC7wGz39Cr for <xfs@oss.sgi.com>;
	Sat, 08 Oct 2011 06:18:11 -0700 (PDT)
Date: Sat, 8 Oct 2011 09:18:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111008131809.GB25855@infradead.org>
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<4E8F0385.7060906@birkenwald.de> <20111007231410.GG3159@dastard>
	<4E90422E.3060805@birkenwald.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E90422E.3060805@birkenwald.de>
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
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: xfs@oss.sgi.com

On Sat, Oct 08, 2011 at 02:29:34PM +0200, Bernhard Schmidt wrote:
> Can I avoid XFS giving ENOSPC due to inode shortage even in worst
> case situations? I would be fine preallocating 1 GB for inode
> storage if that would fix the problem. ext4 with bytes-per-inode =
> blocksize does this fine.

It's a bit of a hack, but you can do that fairly easily by:

 - mounting the filesystem with the ikeep option
 - creating the numbers of inodes you need (use a worst case allocation)
   before starting the workload

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
