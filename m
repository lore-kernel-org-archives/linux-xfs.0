Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 586B07F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 16:17:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 470998F8052
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 14:17:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	19AGQW9HDZrAIjfG for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 14:17:14 -0700 (PDT)
Date: Fri, 25 Oct 2013 08:17:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 4/4] xfsprog: add mkfs.xfs sb v4 support for dirent
	filetype field
Message-ID: <20131024211708.GU2797@dastard>
References: <20131017152804.204045257@sgi.com>
	<20131017152955.689963160@sgi.com>
	<20131024161514.GA14558@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024161514.GA14558@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 09:15:14AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 17, 2013 at 10:28:08AM -0500, Mark Tinguely wrote:
> > Add directory inode type feature to mkfs.xfs and its manual page.
> > 
> > In sb v4, "mkfs.xfs -n ftype=1" turns on the feature.
> > 
> > The feature is automatically turned on for "-m crc=1", but reject
> > the use of the "-n ftype=0|1" with the "-m crc=1" option.
> 
> Seems like this causes a spurious failure in xfs/206:

Yes, it will. the xfstests repair filter needs to be updated every
time a new option is added to the output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
