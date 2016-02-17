Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F31A7CA5
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:16:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E0B78F8033
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:16:29 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0B3siVogslLipAAq for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2016 00:16:27 -0800 (PST)
Date: Wed, 17 Feb 2016 19:16:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/15] xfsprogs: libxfs kernel sync to 4.6-for-next
Message-ID: <20160217081617.GF19486@dastard>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<20160217075614.GA11432@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217075614.GA11432@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Feb 16, 2016 at 11:56:14PM -0800, Christoph Hellwig wrote:
> The series looks fine modulo the nitpicks I posted.
> 
> But shouldn't the rtinode fixes go into 4.5 as clear bugfixes?

None of the changes in those two patches actually affect userspace.
These first is a log recovery fix, and the second was to silence a
warning in kernel IO submission which doesn't exist in userspace.

So apart from syncing up the code, AFAICT there isn't a compelling
reason to pull them back into 4.5.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
