Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B1317CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 19:23:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 058A9304093
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 17:23:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8xCst672RCB5gN0i for <xfs@oss.sgi.com>;
	Wed, 31 Jul 2013 17:23:56 -0700 (PDT)
Date: Thu, 1 Aug 2013 10:23:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801002341.GI7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
	<20130731220154.GA11378@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130731220154.GA11378@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>

On Wed, Jul 31, 2013 at 06:01:54PM -0400, Theodore Ts'o wrote:
> Have you considered what happens if you have a 10 megabyte file, of
> which the first 5 megs are mmap'ed into a userspace process.
> 
> Now suppose you call COLLAPASE_RANGE on a one megabyte range starting
> at offset 1024k from the beginning of the file.
> 
> Does the right thing happen to the mmap'ed region in memory?

Implementation detail. like a hole punch, it needs to invalidate the
range that it is operating over so mmap()d regions are refaulted
after the operation is done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
