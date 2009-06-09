Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59IWHjF052642 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:32:17 -0500
Message-ID: <4A2EAAAC.1010103@redhat.com>
Date: Tue, 09 Jun 2009 13:32:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enable test 080 for LInux
References: <4A2EA257.9000702@redhat.com>
	<20090609182801.GA12057@infradead.org>
In-Reply-To: <20090609182801.GA12057@infradead.org>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:

> That last line of the comment should be removed I think.
>
> Given that IRIX doesn't work we should just remove it from _supported_os
> above.
>   
Heh, good points, here's the revised one:

Seems to work here...  Anyone know why it's disabled?

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/080 b/080
index e9721ad..dc51c59 100755
--- a/080
+++ b/080
@@ -47,14 +47,11 @@ _supported_fs xfs
 
 # Apparently should be able to work on IRIX,
 # but not at the moment.
-# It does not work on Linux due to some locking issues...
-_supported_os IRIX
-
-[ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"
+_supported_os Linux
 
 _setup_testdir
 
-#quiet=-q
+quiet=-q
 clean=-c
 
 export here

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
