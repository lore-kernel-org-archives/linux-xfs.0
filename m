Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB8CB7FE2
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 84E9F8F804B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BBQ95RxJ2eqZb8fo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:26 -0800 (PST)
Message-Id: <20131211073445.353655850@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/12] run more generic tests on TEST_DIR
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
Cc: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

As Stanislav pointed out previously various tests worked fine on NFS
when it still defined a scratch dir that we abused for the test dir.

This series makes various tests that don't require specific file system
sizes or parameters run on TEST_DIR instead of using the scratch devices.

This also allow to remove various bits of boilerplat code as the TEST_DIR
is always available, and checked after each test.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
