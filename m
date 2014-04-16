Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 751DF7F6D
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:40:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 569F68F8064
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 10:40:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FTPVsBy8Qp3AfIPZ for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 10:40:00 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C21A963C5FD4
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:39:59 -0500 (CDT)
Message-ID: <534EC073.8090006@sandeen.net>
Date: Wed, 16 Apr 2014 12:40:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 0/2] xfs: clean up return handling
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
To: xfs-oss <xfs@oss.sgi.com>

2 patches here:

First of all, "return" is not a function.  "return(EIO);" is silly.
"return (EIO);" is even sillier.  Stop it.

Second of all, XFS_ERROR was designed long ago to trap return values,
but it's not runtime configurable, it's not consistently used,
and we can do the same thing today with systemtap.

So nuke that macro, too.

This is a *lot* of churn.  It'll make merging across this change hard.
So we might want to batch this up with another suggestion of Dave's,
to migrate all of xfs to the Linux convention of negative error
returns everywhere, so we don't have two nasty points to merge
across - that'd be fine with me.  But anyway, here it is for now.

For posterity, the first patch was generated with:

perl -p -i -e 's/return \(([a-zA-Z0-9]*?)\)/return $1/g' *.c
perl -p -i -e 's/return\(([a-zA-Z0-9]*?)\)/return $1/g' *.c

and the 2nd with:

perl -p -i -e 's/return\(XFS_ERROR\(([a-zA-Z0-9]*?)\)\)/return XFS_ERROR($1)/g' *.c
perl -p -i -e 's/return \(XFS_ERROR\(([a-zA-Z0-9]*?)\)\)/return XFS_ERROR($1)/g' *.c

(Yes, I know I could have done it w/ one regexp - so sue me) ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
