Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B33E87F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 10:24:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 976548F8066
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 08:24:45 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OrcBy48rZ3xlQZiB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 08:24:44 -0700 (PDT)
Date: Wed, 23 Apr 2014 08:24:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: remove dmapi tests from the auto group
Message-ID: <20140423152444.GE26128@infradead.org>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
	<1398204274-2113-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398204274-2113-6-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Apr 23, 2014 at 08:04:33AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is no mainline kernel support for DMAPI in XFS, and so every
> time the xfstests auto group is run it throws a large number of
> "[not run] Assuming DMAPI modules are not loaded". I've noted that
> people are excluding the dmapi group to avoid this, so rather than
> inflict pain on everyone, make hose few that need to do dmapi
> testing include it specifically.
> 
> IOWs, remove the DMAPI tests from the auto group.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Yes, we shouldn't run them by default.  They also probably should move
from the tests/xfs/ dir to a new tests/dmapi one as they aren't really
XFS specific, they are specific to the out of tree dmapi code which
at one point could also support JFS.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
