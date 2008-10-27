Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:36:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDaW4m021638
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:36:33 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 876F91487ED0
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:36:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id u7jqMH60Kop2MnGr for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:36:32 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSGm-0000CN-6B
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:36:32 +0000
Date: Mon, 27 Oct 2008 09:36:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] setattr simplification
Message-ID: <20081027133632.GA761@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This series has three patches to use the standard inode_change_ok function
like other filesystems instead of making up our own.

-- 
