Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1997129E08
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 21:04:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D18E78F8039
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 19:04:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id czFsYMwTfTzk0adU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Mar 2016 19:04:48 -0800 (PST)
Date: Mon, 7 Mar 2016 11:04:44 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs/259: disable CRC if testing with 512 bytes block size
Message-ID: <20160307030444.GA11419@eguan.usersys.redhat.com>
References: <1456937518-20505-1-git-send-email-eguan@redhat.com>
	<20160305204517.GA10065@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305204517.GA10065@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Sat, Mar 05, 2016 at 12:45:17PM -0800, Christoph Hellwig wrote:
> This will force crcs off for all the blocksizes.  We should
> either always skip 512 bytes, or disable crcs only for the 512 byte
> inode size case.  The first seems either, but the second would give
> better test coverage.

Thanks for the review! I think the test itself has already disabled crc
for 512 block size fs, and this patch disables crc only if the TEST_DEV
has no crc, so it just fixes a corner case in this crc detecting, and
doesn't reduce the test coverage.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
