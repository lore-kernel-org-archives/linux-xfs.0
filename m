Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 031F47F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:25:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBFBD304090
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:25:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6QVc5R86xLlvfr70 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 09:25:16 -0800 (PST)
Message-Id: <20140204172402.380571745@bombadil.infradead.org>
Date: Tue, 04 Feb 2014 09:24:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] support appending AIO writes
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
Cc: Sergey Meirovich <rathamahata@gmail.com>

At least XFS can support appending AIO writes easily, and Sergey has
demonstrated a use case for them.

I've not done any performance testing myself, but ensured that xfstests
already exercises the code path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
