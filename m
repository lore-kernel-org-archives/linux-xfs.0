Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0637C7CBF
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 19:38:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4307304043
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 17:38:31 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zQHFExJM5PimOujv for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 17:38:30 -0700 (PDT)
Date: Sat, 13 Apr 2013 10:38:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: make install support common/ and tests/ dirs
Message-ID: <20130413003829.GH30622@dastard>
References: <51678D0D.1070002@gmail.com> <20130412074034.GC30622@dastard>
	<5168396C.6020801@gmail.com> <51685552.6030808@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51685552.6030808@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfstests <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>, Wang Sheng-Hui <shhuiw@gmail.com>

On Fri, Apr 12, 2013 at 01:41:22PM -0500, Rich Johnston wrote:
> On 04/12/2013 11:42 AM, Wang Sheng-Hui wrote:
> >
> >Hi Dave,
> >
> >I introduces Makefile under tests/, which would return to TESTS_SUBDIRS
> >with the
> >$(dir function. By running find in $(shell, TEST_SUBDIRS will only get
> >the dir names,
> >and no Makefile.
> >
> >Regards,
> >Sheng-Hui
> 
> Thanks addressing comments and for v2 of this patch.
> 
> I still had issues with Makefile which I corrected at commit time.
> 
> Thanks again for the patch, it has been committed,

Rich, it's great that you are picking this stuff up quickly, but as
I asked recently, please don't commit patches while there is still
an active review conversation going on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
