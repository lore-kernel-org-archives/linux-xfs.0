Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22AhpqL040036 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 04:43:51 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5ewX448LDvxwKQgF (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 02:43:50 -0800 (PST)
Date: Fri, 2 Mar 2012 05:43:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
Message-ID: <20120302104348.GA22230@infradead.org>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330539626.7615.73.camel@utemp.mieszkanie>
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
Cc: xfs@oss.sgi.com

>From the trace this looks like we got incorrect results from xfs_imap,
which got some fairly significant changes between the two kernels
you tested.  Can you check if 2.6.36 shows this issue?  It's the first
kernel that had these big changes in inode lookup.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
