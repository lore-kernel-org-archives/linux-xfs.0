Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06DA37CA1
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:31:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC2C9304053
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:31:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IrbOyjkjgmKUadtH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:31:29 -0700 (PDT)
Date: Thu, 24 Mar 2016 02:31:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Failing XFS memory allocation
Message-ID: <20160324093127.GA4204@infradead.org>
References: <56F26CCE.6010502@kyup.com>
	<20160323124312.GB43073@bfoster.bfoster> <56F29279.70600@kyup.com>
	<20160323131059.GC43073@bfoster.bfoster>
	<20160323230002.GY30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323230002.GY30721@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, Nikolay Borisov <kernel@kyup.com>, xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 10:00:02AM +1100, Dave Chinner wrote:
> I'm working on prototype patches to convert it to an in-memory btree
> but they are far from ready at this point. This isn't straight
> forward because all the extent management code assumes extents are
> kept in a linear array and can be directly indexed by array offset
> rather than file offset. I also want to make sure we can demand page
> the extent list if necessary, and that also complicates things like
> locking, as we currently assume the extent list is either completely
> in memory or not in memory at all.

FYI, I did patches to get rid almost all direct extent array access
a while ago, but I never bothered to post it as it seemed to much
churn.  Have you started that work yet or would it be useful
to dust those up again?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
