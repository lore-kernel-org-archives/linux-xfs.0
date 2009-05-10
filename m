Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AILNNE196727 for <xfs@oss.sgi.com>; Sun, 10 May 2009 13:21:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B53FEF7FFF8
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 11:25:51 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Eh8GCAz34A9wjNnX for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 11:25:51 -0700 (PDT)
Message-ID: <4A071B25.2020808@sandeen.net>
Date: Sun, 10 May 2009 13:21:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: add aio-dio-test suite
References: <4A050B11.5010403@sandeen.net>
	<20090510181917.GA23930@infradead.org>
In-Reply-To: <20090510181917.GA23930@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, May 08, 2009 at 11:48:17PM -0500, Eric Sandeen wrote:
>> Pull in the aio-dio-regress test suite from
>> http://git.kernel.org/?p=linux/kernel/git/zab/aio-dio-regress.git
>>
>> Changed from last time to break out into individual tests,
>> and move it under src/aio-dio-regress
>>
>> Also flagged a few as part of the "quick" group.
> 
> The xfsqa integration looks good to me.  Might be worth to mention
> what test each test cases runs in the top of file comments instead
> of just the aio+dio testsuite.

good point, I'll lift comments from the tests themselves into the scripts.

> Also what about keeping a file named SOURCE or similar in
> src/aio-dio-regress to tell exactly where we got this version
> from (repository + commit) so that we know what to diff against.

ok, sure.

I'll ask jeff & zach to put some proper licensing on the c files, and do
the same for my new scripts as well.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
