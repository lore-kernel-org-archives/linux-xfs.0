Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1CNmsNm216763 for <xfs@oss.sgi.com>; Sun, 12 Feb 2012 17:48:55 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VwFRTcqAzKblCkdk (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Feb 2012 15:48:53 -0800 (PST)
Date: Sun, 12 Feb 2012 18:48:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix msync() call in fsx.c:domapwrite()
Message-ID: <20120212234852.GB3848@infradead.org>
References: <1328642166-389-1-git-send-email-curtw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1328642166-389-1-git-send-email-curtw@google.com>
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
To: Curt Wohlgemuth <curtw@google.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 07, 2012 at 11:16:06AM -0800, Curt Wohlgemuth wrote:
> This explicitly sends MS_SYNC as the flag to msync() in
> fsx.c, in domapwrite().  Without this flag, the memory
> written to the mmap'ed region will not be flushed to disk;
> in fact, on Linux, calling msync() with a '0' or MS_ASYNC
> flag is a no-op.

Looks sensible to me - what exactly msync did has always been grossly
different for different operating systems, including changing meaning
on Linux a few times, so let's be explicit.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
