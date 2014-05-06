Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42A5A7FD5
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:18:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA889AC008
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:18:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id iJe9B4COtY5DDrUG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:18:20 -0700 (PDT)
Date: Tue, 6 May 2014 01:18:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: remove shared supberlock feature checking
Message-ID: <20140506081820.GD24143@infradead.org>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399348559-19889-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, May 06, 2014 at 01:55:59PM +1000, Dave Chinner wrote:
> 
> We reject any filesystem that is mounted with this feature bit set,
> so we don't need to check for it anywhere else. Remove the function
> for checking if the feature bit is set and any code that uses it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

If someone at SGI has some spare time for a BugWorks search I'd really
love to figure out of the story behind the shared superblock feature..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
