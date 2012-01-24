Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHkZCv059278 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:46:35 -0600
Date: Tue, 24 Jan 2012 12:46:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
Message-ID: <20120124174612.GC9853@infradead.org>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
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
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, yrl.pp-manager.tt@hitachi.com, Christoph Hellwig <hch@lst.de>

On Mon, Jan 23, 2012 at 12:45:14PM +0900, Mitsuo Hayasaka wrote:
> Hi,
> 
> This patch series changes available ranges of softlimit and
> hardlimit in quota check, as follows.
> 
> (1) Consider new reservation for quota check
>     The disk block reservation checks if (current usage + new
>     reservation) reach the quota limit although the inode reservation
>     does not use the new reservation for quota check. It should
>     consider it, as well. This is mandatory for (2).

Can you send a testcase that reproduces issues with the old behaviour?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
