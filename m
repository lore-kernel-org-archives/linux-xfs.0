Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q23BiHOo021913 for <xfs@oss.sgi.com>; Sat, 3 Mar 2012 05:44:17 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	g3Ul3jitKn37Jc1i (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 Mar 2012 03:44:14 -0800 (PST)
Date: Sat, 3 Mar 2012 06:44:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
Message-ID: <20120303114413.GA18748@infradead.org>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
	<1330774627.32457.24.camel@utemp.mieszkanie>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330774627.32457.24.camel@utemp.mieszkanie>
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
To: Rafa?? Kupka <kupson@kupson.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Mar 03, 2012 at 12:37:07PM +0100, Rafa?? Kupka wrote:
> On Fri, 2012-03-02 at 05:43 -0500, Christoph Hellwig wrote:
> Hello,
> 
> > From the trace this looks like we got incorrect results from xfs_imap,
> > which got some fairly significant changes between the two kernels
> > you tested.  Can you check if 2.6.36 shows this issue?  It's the first
> > kernel that had these big changes in inode lookup.
> 
> I've tested more kernels and here are results (linus git tree, no
> additional patches):
> - v2.6.36 -- good
> - v2.6.38 -- good
> - v2.6.39 -- bad, I/O error log entry and locked processes:

> - git revision 243b422af9ea9af4ead07a8ad54c90d4f9b6081a -- good
> It's one patch before "xfs: preallocation transactions do not need to be synchronous"
> 
> - git revision c5850150d0b9ae16840c5d9846f9d5a759996a15:
>     Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs
>     
>     * 'for-linus' of git://oss.sgi.com/xfs/xfs:
>       xfs: stop using the page cache to back the buffer cache
>       xfs: register the inode cache shrinker before quotachecks
>       xfs: xfs_trans_read_buf() should return an error on failure

This is the only patch in that area.  Give me a bit more time to
figure out how it could related to your issues.

> Hung xfsdump (only?) without any additional log entries
> (CONFIG_XFS_DEBUG is set):

> I don't know if it's the same bug - there is no assertion nor I/O error
> log entry...

It's the same code path at least..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
