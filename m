Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0578E7FCC
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 15:37:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E88998F8081
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 13:37:45 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id E4PGRVvANdCZebAm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 13:37:44 -0800 (PST)
Date: Tue, 3 Feb 2015 13:37:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: struct xfs_sb is no longer tied to the on-disk
	format
Message-ID: <20150203213744.GA31631@infradead.org>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-2-git-send-email-david@fromorbit.com>
	<20150202084102.GA28121@infradead.org>
	<20150202193020.GJ6282@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202193020.GJ6282@dastard>
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

On Tue, Feb 03, 2015 at 06:30:21AM +1100, Dave Chinner wrote:
> > I'd expect to move it close to stuct xfs_mount, and maybe even merge
> > it into that in the long run.
> 
> I guess moving the structure there is fine, but we still want all
> the version functions to be shared with userspace, which then makes
> for an interesting set of dependencies. Any other ideas?

Are they really worth the sharing?  If they are worth it we'll
need somethign that can expect a xfs_sb/xfs_mount to be defined.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
