Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA27C7CA0
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2016 01:33:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD4E58F807A
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 23:33:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3sV9PLMFOVNOH7mJ for <xfs@oss.sgi.com>;
	Sat, 13 Aug 2016 23:33:29 -0700 (PDT)
Date: Sun, 14 Aug 2016 16:33:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: first set of iomap fix
Message-ID: <20160814063326.GD16044@dastard>
References: <1471131781-14107-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471131781-14107-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 13, 2016 at 04:42:54PM -0700, Christoph Hellwig wrote:
> This contains various fixes for the iomap path for 4.8, but it skips
> the changes to the delalloc path (which aren't really about the iomap
> path itself anyway).
> 
> Two fixes to make the iomap buffered write path catch up with changes
> to the filemap one.  Then I've cherry picked the FIEMAP_FLAG_SYNC patch
> from Dave, and added my version of re-implementing FIEMAP_FLAG_XATTR
> as well.

Thanks for the quick turnaround on these, Christoph.  Your change
for handling xattr mappings is simpler than the one I have - the
optional ioend handling is definitely an improvement.  At first
glance I can't see anything obvious wrong with the patches - I'll
give them a spin through QA and see what falls out...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
