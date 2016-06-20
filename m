Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9014C7CA1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:21:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41D46304032
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 03:21:28 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eeXgNEQdgD5qRNXs (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 03:21:26 -0700 (PDT)
Date: Mon, 20 Jun 2016 03:21:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Reported regressions for 4.7 as of Sunday, 2016-06-19
Message-ID: <20160620102122.GB23462@infradead.org>
References: <7cc588b7-f1cf-62a8-e45b-ec7d863ba51e@leemhuis.info>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7cc588b7-f1cf-62a8-e45b-ec7d863ba51e@leemhuis.info>
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
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Another important one is the rename regression in XFS and ext4 that
I suspect is due the VFS changes in 4.7:

http://oss.sgi.com/pipermail/xfs/2016-June/049138.html

http://oss.sgi.com/pipermail/xfs/2016-June/049309.html

possibly related:

http://marc.info/?l=linux-kernel&m=146605889024559&w=2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
