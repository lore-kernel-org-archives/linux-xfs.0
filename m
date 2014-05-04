Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5C8D7F3F
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 04:42:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DE8C8F8039
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 02:42:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id l2ZbhoJcbNB2znGA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 02:42:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Wgsw6-0000mI-7e
	for xfs@oss.sgi.com; Sun, 04 May 2014 09:42:18 +0000
Date: Sun, 4 May 2014 02:42:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: repating 208 failures
Message-ID: <20140504094218.GA2920@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Did anyone see failure like:

generic/208 201s ... 200s
umount: /mnt/test: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))

which then abort xfstests?  I've seen them occasionally for a long time,
but these days they seem to happen more than 50% of the time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
