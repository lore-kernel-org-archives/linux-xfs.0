Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n39HBspG002961 for <xfs@oss.sgi.com>; Thu, 9 Apr 2009 12:12:09 -0500
Date: Thu, 9 Apr 2009 13:11:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: a couple getbmap cleanups
Message-ID: <20090409171135.GA25303@infradead.org>
References: <20090224133858.GB15820@infradead.org>
	<9EF64CF3-FDFC-4777-94A5-7295E827ABA4@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9EF64CF3-FDFC-4777-94A5-7295E827ABA4@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Apr 06, 2009 at 07:57:48PM -0500, Felix Blyakher wrote:
> Shouldn't we set error to ENOMEM here?

Yes, good catch.

> Should the callers be taught to handle ENOMEM now?

The kernel callchain handles it, and in userspace the only caller
(xfs_io) will handled it by printing an out of memory message.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
