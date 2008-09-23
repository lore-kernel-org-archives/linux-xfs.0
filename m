Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 10:26:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8NHQQ4G014510
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 10:26:27 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DE0A1319F12
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 10:28:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id mAyn8EPgKDl5OJgx for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 10:28:00 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KiBg8-0005mi-0Z
	for xfs@oss.sgi.com; Tue, 23 Sep 2008 17:28:00 +0000
Date: Tue, 23 Sep 2008 13:28:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: RFC: adding a crc field to xfs_buf_log_format_t
Message-ID: <20080923172800.GA22047@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

With adding CRC to xfs metadata structures we face an interesting
problem.  As we want all the CRCs logged we always have to log the CRC.
But this means for many modification that previous just required one
or two chunks of a buffer logged (e.g. superblock counters or changing a
single btree records) we would now need a second iovec.  One idea to
avoid this would be to put the crc into a modified version of
xfs_buf_log_format_t.  Any opinions wether this is worth the trouble?
