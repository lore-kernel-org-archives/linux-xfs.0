Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA36tT43242929 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 01:55:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACF361CDD227
	for <xfs@oss.sgi.com>; Wed,  2 Nov 2011 23:55:28 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PHJCrHHco6G74ofu for <xfs@oss.sgi.com>;
	Wed, 02 Nov 2011 23:55:28 -0700 (PDT)
Date: Thu, 3 Nov 2011 02:55:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests 264: add a copy and reserve test
Message-ID: <20111103065525.GA6800@infradead.org>
References: <4EB20505.7070005@cn.fujitsu.com> <4EB205C7.6010906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EB205C7.6010906@cn.fujitsu.com>
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
To: WuBo <wu.bo@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 11:08:55AM +0800, WuBo wrote:
> This test is a stress test. It creates a set of threads for coping small files 
> into disk. I use a 2G disk for test, the ENOSPC arises usually but the disk is 
> not full under kenerl 3.0 with intel64.

It seems like you really want to use _scratch_mkfs_sized instead of the
btrfs-specific resize option and make the test generic.  Also we already
have used up these test numbers in the xfstests-dev repository, and I
will commit another batch of tests today.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
