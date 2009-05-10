Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AIJCT3196544 for <xfs@oss.sgi.com>; Sun, 10 May 2009 13:19:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0205D27667B
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 11:19:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jETXHrBRdgh7bYxn for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 11:19:17 -0700 (PDT)
Date: Sun, 10 May 2009 14:19:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests: add aio-dio-test suite
Message-ID: <20090510181917.GA23930@infradead.org>
References: <4A050B11.5010403@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A050B11.5010403@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, May 08, 2009 at 11:48:17PM -0500, Eric Sandeen wrote:
> Pull in the aio-dio-regress test suite from
> http://git.kernel.org/?p=linux/kernel/git/zab/aio-dio-regress.git
> 
> Changed from last time to break out into individual tests,
> and move it under src/aio-dio-regress
> 
> Also flagged a few as part of the "quick" group.

The xfsqa integration looks good to me.  Might be worth to mention
what test each test cases runs in the top of file comments instead
of just the aio+dio testsuite.

Also what about keeping a file named SOURCE or similar in
src/aio-dio-regress to tell exactly where we got this version
from (repository + commit) so that we know what to diff against.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
