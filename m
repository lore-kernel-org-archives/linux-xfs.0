Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8429D7CB1
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 10:57:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 563173040E9
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 08:57:17 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id q2zOrGKXh5NmLpG2 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2016 08:57:14 -0700 (PDT)
Date: Tue, 22 Mar 2016 16:57:40 +0100
From: Jan Kara <jack@suse.cz>
Subject: XFS hole punch races
Message-ID: <20160322155740.GB28772@quack.suse.cz>
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

Hi,

similarly to ext4 also XFS had races between hole punching and page faults
which could result in data corruption. The fixes were merged in 4.1-rc1 but
it might make sense to backport them to older stable releases given the
nature of the issue.

Relevant fixes are:

de0e8c20ba3a65b0f15040aabbefdc1999876e6b
075a924d45cc69c75a35f20b4912b85aa98b180a
e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef
0f9160b444e4de33b65dfcd3b901358a3129461a
723cac48473358939759885a18e8df113ea96138
ec56b1f1fdc69599963574ce94cc5693d535dd64

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
