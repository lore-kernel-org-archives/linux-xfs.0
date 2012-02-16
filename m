Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GIpfr4011779 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 12:51:41 -0600
Date: Thu, 16 Feb 2012 12:51:47 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 03/12] xfs: remove xfs_trans_unlocked_item
Message-ID: <20120216185147.GS7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.885467482@bombadil.infradead.org>
	<4F1D6F24.6050509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F1D6F24.6050509@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 08:31:00AM -0600, Mark Tinguely wrote:
> On 01/-10/63 13:59, Christoph Hellwig wrote:
>> There is no reason to wake up log space waiters when unlocking inodes or
>> dquots, and the commit log has no explanation for this function either.
>>
>> Given that we now have exact log space wakeups everywhere we can assume
>> to reason for this function was to paper over log space races in earlier
   the
>> XFS versions.
>>
>> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> I agree, these unlock won't change the amount of available log space.
>
> I did not find the exact reason for these original calls the the log  
> space wake routines.
>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

I agree too.  Christoph's assessment that "the reason for this function was
to paper over log space races" seems spot on, and it's nice to get rid
of xfs_trans_unlocked_item.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
