Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q239Xc81255409 for <xfs@oss.sgi.com>; Sat, 3 Mar 2012 03:33:38 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Gpn5xeRi09UKs1ZC (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 Mar 2012 01:33:33 -0800 (PST)
Date: Sat, 3 Mar 2012 04:33:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfstests patch] 113: add testing for O_DIRECT + O_SYNC
Message-ID: <20120303093332.GA8417@infradead.org>
References: <x49ipim7r19.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49ipim7r19.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Mar 02, 2012 at 02:15:46PM -0500, Jeff Moyer wrote:
> Hi,
> 
> This patch adds a couple more aio-stress runs to test 113.  The first
> simply adds -S, to test out AIO+DIO+O_SYNC.  The second adds -S and -o
> 2, which directs aio-stress to only perform the random write test.
> These two tests helped identify several bugs in ext4.

I'd rather make this a separate testcase, maybe moving the _do_test into
common code.

Rationale:  newly added tests shouldn't make old testcases fail, as that
would be rather confusing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
