Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 76F017F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 17:12:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5351F304064
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:12:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tkD4nZRE1PsGrfRh for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 15:12:13 -0700 (PDT)
Date: Fri, 31 May 2013 08:12:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Fix test wildcard expansion.
Message-ID: <20130530221211.GP29466@dastard>
References: <51A7CC6B.3030607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A7CC6B.3030607@sgi.com>
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
Cc: xfstests <xfs@oss.sgi.com>

On Thu, May 30, 2013 at 05:02:19PM -0500, Rich Johnston wrote:
> 
> Before commit 38d58591 "xfstests: fix typo in check",
> check xfs/[0-9]?? would execute all tests/xfs/[0-9]?? because:
> 
> 'if grep "^$testname" $group_file >/dev/null'
> returns the contents of $group_file because $testname="".
> 
> Therefore xfs/[0-9]?? was echoed to $tmp.list
> 
> Fix the parsing in check to expand the regular expressions for test names.

I just fixed this locally myself:

-                       if grep "^$test_name" $group_file >/dev/null ; then
+                       if egrep "^$test_name" $group_file >/dev/null ; then

Which just tells grep to treat the pattern as an extended regex....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
