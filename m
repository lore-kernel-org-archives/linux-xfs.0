Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3F1B7F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 08:19:23 -0500 (CDT)
Message-ID: <513DD9EC.5080303@sgi.com>
Date: Mon, 11 Mar 2013 08:19:40 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests, aio-dio-extend-stat.c: fix error reporting
References: <x49y5fqgnfu.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49y5fqgnfu.fsf@segfault.boston.devel.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: xfs@oss.sgi.com

Jeff thanks for submitting this patch.  Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


This has been committed.

--Rich


commit 06166c2dbaedce9db77b9c6325e21ddf760a7623
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Fri Jan 18 22:01:57 2013 +0000

     xfstests, aio-dio-extend-stat.c: fix error reporting

     If we receive an unexpected result from an async write, the error
     reporting does not tell the actual number of bytes written.  Fix that,
     and also a couple of typos in printf's.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
