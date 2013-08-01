Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61E1A7F37
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 03:50:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7BEEAC001
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 01:50:26 -0700 (PDT)
Date: Thu, 1 Aug 2013 01:50:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/49] xfs: split out inode log item format definition
Message-ID: <20130801085024.GA13494@infradead.org>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-3-git-send-email-david@fromorbit.com>
	<51F7E7BF.6020108@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F7E7BF.6020108@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

> >+} xfs_icdinode_t;
> 
> 
> A log header file does not strike me as the place for the internal
> representation of the on disk inode structure.

It's not not really the in-core version, I just messed up the name when
doing the proper endianess annotations for XFS many years ago.

The correct name would be xfs_log_inode or similar.  Maybe the comments
should get a little update.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
