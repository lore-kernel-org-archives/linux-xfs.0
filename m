Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18ED929E17
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 06:16:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E194D8F8078
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 04:16:18 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id qNr5VR6uaCnyDA2H (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 04:16:14 -0800 (PST)
Date: Wed, 6 Nov 2013 04:16:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: atime reporting issues
Message-ID: <20131106121614.GA13530@infradead.org>
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
To: linux-nfs@vger.kernel.org
Cc: xfs@oss.sgi.com

xfstest 193 fail on NFS because it can't find out that nfs has noatime
behavior.  Part of the bug is that xfstests check the mount flags it
explicitly passes, but even one that is fixed NFS seems to claim having
relatime behavior in /proc/self/mounts.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
