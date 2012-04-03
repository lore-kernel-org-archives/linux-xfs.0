Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q33H1NfF228009 for <xfs@oss.sgi.com>; Tue, 3 Apr 2012 12:01:23 -0500
Message-ID: <4F7B2CE0.6010506@sgi.com>
Date: Tue, 03 Apr 2012 12:01:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: use shared ilock mode for direct IO writes by
	default
References: <20120327143445.196524266@bombadil.infradead.org>
	<20120327143826.969369776@bombadil.infradead.org>
In-Reply-To: <20120327143826.969369776@bombadil.infradead.org>
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

On 03/27/12 09:34, Christoph Hellwig wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> For the direct IO write path, we only really need the ilock to be taken in
> exclusive mode during IO submission if we need to do extent allocation
> instaled of all the time.
>
> Change the block mapping code to take the ilock in shared mode for the
> initial block mapping, and only retake it exclusively when we actually
> have to perform extent allocations.  We were already dropping the ilock
> for the transaction allocation, so this doesn't introduce new race windows.
>
> Based on an earlier patch from Dave Chinner.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
