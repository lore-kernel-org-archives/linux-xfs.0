Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FB427F74
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 14:11:29 -0600 (CST)
Message-ID: <5277FF72.1010005@sgi.com>
Date: Mon, 4 Nov 2013 14:11:30 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/318 use symbolic namespaced ids
References: <20131024154414.GB19055@infradead.org>	<20131024161155.080eabad@oracle.com>
	<20131025093154.GA24583@infradead.org>
In-Reply-To: <20131025093154.GA24583@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On 10/25/2013 04:31 AM, Christoph Hellwig wrote:
> On Thu, Oct 24, 2013 at 04:11:55PM -0400, Dwight Engen wrote:
>> Christoph, I think the following should fix 318 for you.
>
> This fixes the test for me, thanks.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
Hey Dwight,

This still fails for me.

--Rich

diff -u tests/generic/318.out 
/usr/src/tot/xfstests/results//generic/318.out.bad
--- tests/generic/318.out	2013-11-04 13:03:03.000000000 -0600
+++ /usr/src/tot/xfstests/results//generic/318.out.bad	2013-11-04 
14:08:32.000000000 -0600
@@ -17,7 +17,7 @@
  # group: 65534
  user::rw-
  user:0:r-x	#effective:r--
-user:1:rw-	#effective:r--
+user:12:rw-	#effective:r--
  group::r--
  group:0:--x	#effective:---
  mask::r--
@@ -43,7 +43,7 @@
  # group: 65534
  user::rw-
  user:0:r-x	#effective:r--
-user:1:rw-	#effective:r--
+user:12:rw-	#effective:r--
  group::r--
  group:0:--x	#effective:---
  mask::r--

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
