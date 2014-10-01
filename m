Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E776C7F63
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 17:57:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C62F18F8035
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:57:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pVXXuqhwjInurNzR for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 15:57:13 -0700 (PDT)
Date: Thu, 2 Oct 2014 08:56:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: fix crc field handling in xfs_sb_to/from_disk
Message-ID: <20141001225636.GC10298@dastard>
References: <542C1B36.5080804@redhat.com> <542C1CB8.103@sandeen.net>
	<20141001155604.GB787@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141001155604.GB787@infradead.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 01, 2014 at 08:56:04AM -0700, Christoph Hellwig wrote:
> Looks good (although it will conflict with Dave's sb_to_disk rework..)

That's ok. I'm slipping that superblock logging change to the next
merge window as I haven't had a chance to look at the problems you
reported yet and it's too close to the next merge window to be
debugging changes to on-disk format handling code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
