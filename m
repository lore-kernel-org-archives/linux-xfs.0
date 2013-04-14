Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C2A57F4C
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 19:38:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E93C7304032
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 17:38:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0SIDBDEPPkE8Btzu for <xfs@oss.sgi.com>;
	Sun, 14 Apr 2013 17:38:03 -0700 (PDT)
Date: Mon, 15 Apr 2013 09:26:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: kludge patch for per-dir test number sorting by ./check
Message-ID: <20130414232600.GA5117@destitution>
References: <5169C4FE.4030209@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5169C4FE.4030209@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>

On Sat, Apr 13, 2013 at 04:50:06PM -0400, Michael L. Semon wrote:
> I'm trying to get the new xfstests to run the XFS tests first, then

The question is why do you want to do this? Is there any specific
reason for running the tests in that order?

FWIW, if all you want to do is run the xfs tests, run:

$ sudo ./check xfs[0-9][0-9][0-9]

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
