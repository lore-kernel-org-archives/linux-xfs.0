Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7CD617F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 03:23:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6A8098F80D6
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 01:23:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id gVf0DukHbkJOUEFD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 01:23:11 -0800 (PST)
Date: Tue, 2 Dec 2014 01:23:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix set-but-unused warnings
Message-ID: <20141202092310.GA25767@infradead.org>
References: <1417489741-11223-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417489741-11223-1-git-send-email-david@fromorbit.com>
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

On Tue, Dec 02, 2014 at 02:09:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The kernel compile doesn't turn on these checks by default, so it's
> only when I do a kernel-user sync that I find that there are lots of
> compiler warnings waiting to be fixed. Fix up these set-but-unused
> warnings.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  Maybe we should enable those warnings for fs/xfs?

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
