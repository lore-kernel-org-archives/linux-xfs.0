Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 024E37F6A
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:16:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E49A1304039
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:16:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id PCFC9by0PTfOtYb8 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:16:03 -0700 (PDT)
Received: from p5de57ec4.dip0.t-ipconnect.de ([93.229.126.196] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat
	Linux)) id 1ZJOao-0000O3-J7
	for xfs@oss.sgi.com; Sun, 26 Jul 2015 16:16:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: xfsprogs: fix and clean up installed headers V2
Date: Sun, 26 Jul 2015 18:13:19 +0200
Message-Id: <1437927209-31354-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series ensures we only install the minimum required headers, and
especially no autoconf-generated header that might differ for different
targets in multiarch setups.

Note that I'd like to see this in the first xfsprogs release that
includes the libxfs infrastructure changes, as it fixes regressions
in the amount of installed internals in those.

Changes since V1:
  - dropped a cleanup patch Dave didn't like
  - dropped two more cleanup patches that aren't really related

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
