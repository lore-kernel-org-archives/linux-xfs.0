Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TAi6Po064278 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 05:44:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C425C8EC7CE
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:46:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GEMHAeOCU56lQFzD for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:46:11 -0700 (PDT)
Date: Thu, 29 Apr 2010 06:46:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfsqa: build dbtest on debian platforms
Message-ID: <20100429104611.GA17317@infradead.org>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
	<1272500186-29393-4-git-send-email-david@fromorbit.com>
	<20100429064943.GB3774@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100429064943.GB3774@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Spoken too soon.  While this second patch at least compiles on my Debian
testing  system it doesn't link:

/tmp/ccWcHXtY.o: In function `CleanupDbmLookup': /root/xfstests-dev/src/dbtest.c:304: undefined reference to `dbm_close'
/tmp/ccWcHXtY.o: In function `DoDbmLookup':
/root/xfstests-dev/src/dbtest.c:220: undefined reference to `dbm_fetch'
/root/xfstests-dev/src/dbtest.c:264: undefined reference to `dbm_fetch' /tmp/ccWcHXtY.o: In function `InitDbmLookup':
/root/xfstests-dev/src/dbtest.c:144: undefined reference to `dbm_open'
/root/xfstests-dev/src/dbtest.c:178: undefined reference to `dbm_store'
/root/xfstests-dev/src/dbtest.c:191: undefined reference to `dbm_close'
/root/xfstests-dev/src/dbtest.c:196: undefined reference to `dbm_open'
collect2: ld returned 1 exit status
make[2]: *** [dbtest] Error 1
make[1]: *** [src] Error 2
make: *** [default] Error 2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
