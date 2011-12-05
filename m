Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB58u8Ne123752 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 02:56:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3402999F315
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 00:56:07 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NvEP4uiv02Yc5ncx for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 00:56:07 -0800 (PST)
Date: Mon, 5 Dec 2011 03:56:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: case NO.263 execute failure in xfstests-dev
Message-ID: <20111205085607.GA11094@infradead.org>
References: <4EDC62B5.8030901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EDC62B5.8030901@cn.fujitsu.com>
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
To: ?????? <songrenchun@cn.fujitsu.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Dec 05, 2011 at 02:20:37PM +0800, ?????? wrote:
> Hi:
> 
>     When testing case 263 in xfstests, it always fails.
>     It seems a bug of mmap in some case, and i do not know
>     how to solve it. Can you help me?

Yes, there seems to be an issue with mmap vs O_DIRECT coherency.  I have
not looked into it in detail yet, 263 was just split from the rest of the
fsx tests to isolate this test.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
