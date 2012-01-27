Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0R6LCu4114782 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 00:21:12 -0600
Message-ID: <4F22424E.8070407@hitachi.com>
Date: Fri, 27 Jan 2012 15:21:02 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
	<20120124174612.GC9853@infradead.org>
In-Reply-To: <20120124174612.GC9853@infradead.org>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

Hi Christoph,

(2012/01/25 2:46), Christoph Hellwig wrote:
> On Mon, Jan 23, 2012 at 12:45:14PM +0900, Mitsuo Hayasaka wrote:
>> Hi,
>>
>> This patch series changes available ranges of softlimit and
>> hardlimit in quota check, as follows.
>>
>> (1) Consider new reservation for quota check
>>     The disk block reservation checks if (current usage + new
>>     reservation) reach the quota limit although the inode reservation
>>     does not use the new reservation for quota check. It should
>>     consider it, as well. This is mandatory for (2).
> 
> Can you send a testcase that reproduces issues with the old behaviour?
> 

Regarding (1) related to inode reservation, current xfs works well
because inode is reserved one by one if required.

For example, when an new inode tries to be reserved in xfs_trans_dqresv(),
it checks quota as follows.

if (ninos > 0) {	// ninos: # of new inodes expected to be allocated.
	if (cur_usage >= limit)
		goto error;

	cur_usage += ninos;
}

It checks only current usage, but this code works well since the caller
always set the argument ninos to 1 or 0 in current xfs. So, inode can be
used up to the limits due to the one by one reservation.

To make it more general, this check should be the same way as the new
block quota check introduced in the PATCH 2/3 where the disk block can
be used up to the block quota limits.

So, this part is a kind of cleanup patch. I'm going to split the part
into another patch, and to send a new patch series.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
