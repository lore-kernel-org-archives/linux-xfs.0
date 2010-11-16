Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGF5YRH069914 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 09:05:34 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 421848F80BA
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 07:07:04 -0800 (PST)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 242D470017C6
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 09:07:04 -0600 (CST)
Message-Id: <20101116150502.179825893@sgi.com>
Date: Tue, 16 Nov 2010 09:05:02 -0600
From: wkendall@sgi.com
Subject: [PATCH v3 0/9] xfsrestore dirent limitations and scaling issues
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

v3 of this series reworks a couple of the patches based on feedback
from Alex Elder:

- 3rd patch: changed a buffer size check to an assert.
- 7th patch: move static functions up in the file and
  create typedefs for segix_t and relnix_t.

The remainder is unchanged from the previous submission.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
