Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6OE3dIn119507 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 09:03:39 -0500
Message-ID: <500EAB38.5080702@sgi.com>
Date: Tue, 24 Jul 2012 09:03:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC] xfs: wait for the write of the superblock on unmount
References: <20120717215957.855744999@tinguelysgi.com>
	<20120718220003.396849822@tinguelysgi.com>
	<20120724135758.GA6564@infradead.org>
In-Reply-To: <20120724135758.GA6564@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/24/12 08:57, Christoph Hellwig wrote:
> On Wed, Jul 18, 2012 at 12:33:58PM -0500, tinguely@sgi.com wrote:
>> Sorry, I have been distracted away from this regression. This was previously
>> titled "xfs: synchronously write the superblock on unmount".
>>
>> xfs_wait_buftarg() does not wait for the completion of the write of the
>> uncached superblock. This write can race with the shutdown of the log and
>> causes a panic if the write does not win the race.
>>
>> The log write of the superblock is important for possible recovery, but a
>> second syncronous write of the same superblock seems redundant. Would just
>> waiting for the iodone() of the log write before tearing down the log be
>> enough?
>
> This doesn't look beautiful, but I suspect there's no good way around
> it.  Can you add your explanation from the reply on why xfs_buf_iowait
> does not work here to the comment above the lock/unlock pair?
>
> With that:
>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Thank-you. I will repost with the same xfs_buf_lock() entry to 
xfs_quiesce_attr().

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
