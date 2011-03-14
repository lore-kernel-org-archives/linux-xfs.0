Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2EAXTRv065406 for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 05:33:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F02CB138EB3B
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 03:36:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nABEVASdtcggEIIl for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2011 03:36:23 -0700 (PDT)
Date: Mon, 14 Mar 2011 06:36:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Does XFS ever relocate extents after they are on disk?
Message-ID: <20110314103622.GA715@infradead.org>
References: <903E14DC-D9EA-4BDC-8D43-FBB9AB4127BC@cs.ucsd.edu>
	<20110311100936.GA11879@infradead.org>
	<D03B8F30-7E6D-4C85-8160-9FB505E09B9F@cs.ucsd.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D03B8F30-7E6D-4C85-8160-9FB505E09B9F@cs.ucsd.edu>
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
To: Steven Swanson <swanson@cs.ucsd.edu>
Cc: xfs@oss.sgi.com

On Fri, Mar 11, 2011 at 02:29:30PM -0800, Steven Swanson wrote:
> Christoph,
> 
> Thanks for the quick reply.  
> 
> Here's another question:  If I write data to an extent that already exists, am I also guaranteed that the new data will overwrite the same location?  For instance, will XFS ever relocate an extent on a write in order to expand the extent?

Right now it won't. I wouldn't call that a guaranteed though - e.g. if
we're ever going to finish off storig file data in the inode for small
files we'll have to migrate them out of the inode once we create the
first extent.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
