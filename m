Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E4707F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 19:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BAEBAC002
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 17:25:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DhaQ7E8OGE8s3fib for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 17:25:19 -0700 (PDT)
Date: Mon, 13 May 2013 10:25:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: unify apostrophes in output files
Message-ID: <20130513002500.GI32675@dastard>
References: <1368349273-23968-1-git-send-email-tracek@redhat.com>
	<1368349273-23968-2-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368349273-23968-2-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Sun, May 12, 2013 at 11:01:13AM +0200, Tomas Racek wrote:
> With coreutils v8.16 the style of apostrophes changed from `word' to
> 'word'. This is breaking some tests which use the older form.
> 
> This commit introduces function _filter_apostrophes and changes the
> affected tests.

I'm not sure this is the best approach as it means we have to
remember in future to do this filtering in the places that need it.

I suspect that we'd do better to filter the entire output file from
check before we diff the golden output and the test output. An
inplace sed modification would be all that is needed like:

	# coreutils 2.20+ changed quote formats in error messages.
	# filter the damage out so that golden images match both old
	# and new versions of coreutils.
	sed -i 's/`/'\''/g' <test output file>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
