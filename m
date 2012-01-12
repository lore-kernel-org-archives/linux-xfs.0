Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CGdjiw006186 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 10:39:45 -0600
Date: Thu, 12 Jan 2012 11:39:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
Message-ID: <20120112163943.GA22223@infradead.org>
References: <4F06F71A.2010301@oracle.com> <20120110171855.GX6390@sgi.com>
	<4F0D21E5.7010908@oracle.com> <4F0DFA11.7030305@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F0DFA11.7030305@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, jeff.liu@oracle.com, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Wed, Jan 11, 2012 at 03:07:29PM -0600, Mark Tinguely wrote:
> 
> xfs_bmapi_read() returns the br_state == XFS_EXT_NORM for a hole.
> There are a couple places that a hole can trigger a data test.
> BTW, I could not generate a large enough hole that xfs_bmapi_read()
> would return as more than one hole entry, so I will ignore those
> situations and just list the couple places that a hole may be match
> a data rule:

We've been through this before, you need to overflow the 32-bit extent
length counter to get there.  Jeff, did you manage to create a test
case for that particular scenario?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
