Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DFIhEF142286 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 09:18:43 -0600
Message-ID: <4F104B51.3090706@sgi.com>
Date: Fri, 13 Jan 2012 09:18:41 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/12] repair: handle filesystems with the log in
	allocation group 0
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174742.515301323@bombadil.infradead.org>
In-Reply-To: <20111202174742.515301323@bombadil.infradead.org>
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

On 01/-10/63 13:59, Christoph Hellwig wrote:
> Sindre Skogen reported that repair chokes on a very small filesystem created
> by mkfs.xfs from xfsprogs 2.9.4.  It turned out that for some reason this
> filesystem had the log in allocation group 0 and thus repairs validation
> of the root inode number was off.  Fix this by adding the log blocks if
> the log is allocated in allocation group 0.
>


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
