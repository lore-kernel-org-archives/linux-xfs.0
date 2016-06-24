Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 167827CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 02:52:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FF7EAC002
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:52:53 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IFMT1bNgbRYhrpiH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:52:51 -0700 (PDT)
Received: from [91.114.64.3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bGLv0-0002rC-Ez
	for xfs@oss.sgi.com; Fri, 24 Jun 2016 07:52:50 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: get rid of unaligned embedded structs in on-disk structures
Date: Fri, 24 Jun 2016 09:52:44 +0200
Message-Id: <1466754767-10657-1-git-send-email-hch@lst.de>
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

Recent build bot reports show that besides ARM old ABI at least openrisc
and cris also have problems with our unaligned structures in the on-disk
format.  This series gets rid of our structs that just wrap u8 arrays
used for get_unaligned_be* and the __arch_pack magic.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
