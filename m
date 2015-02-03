Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D04F8021
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 15:38:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD5D7AC00C
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 13:38:33 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GnXo7cMFzhs0PANs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 13:38:32 -0800 (PST)
Date: Tue, 3 Feb 2015 13:38:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use generic percpu counters for inode counter
Message-ID: <20150203213832.GB31631@infradead.org>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-3-git-send-email-david@fromorbit.com>
	<20150202164409.GA695@infradead.org>
	<20150202193344.GK6282@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202193344.GK6282@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Feb 03, 2015 at 06:33:44AM +1100, Dave Chinner wrote:
> > Why would the percpu counter not be initialized here?  Oh, I guess
> > this is for xfs_sb_verify().  But why can't xfs_mount_validate_sb simply
> > operate on the disk endian SB to avoid that whole issue?
> 
> Possibly. I'll look into it.

A simpler alternative would be to move them out of __xfs_sb_from_disk
into the one caller that needs these values.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
