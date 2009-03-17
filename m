Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2H47SEU133379 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 23:07:49 -0500
Message-Id: <6.0.0.20.2.20090317102134.06e60b30@172.19.0.2>
Date: Tue, 17 Mar 2009 13:03:08 +0900
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] XFS: Pagecache usage optimization on XFS
In-Reply-To: <20090316091606.GA1720@infradead.org>
References: <6.0.0.20.2.20090304114824.06985898@172.19.0.2>
	<20090316091606.GA1720@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com


At 18:16 09/03/16, Christoph Hellwig wrote:
>This looks like it should work.  did you run XFSQA on a small blocksize
>filesystem with this applied?

Hi.
I did XFSQA test on XFS partition with this patch applied.

arch:ia64
pagesize:16K
blocksize:2K

The result of XFSQA test 001~ 202 except 182 was OK. 
It was discussed about the failure of test 182 as follows.
http://marc.info/?l=linux-fsdevel&m=122535673232638&w=2
Subject:    do_sync() and XFSQA test 182 failures....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
