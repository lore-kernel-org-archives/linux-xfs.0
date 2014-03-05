Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3ADCD7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 09:51:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA02FAC009
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 07:51:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZU93VMi6aODs11o4 for
	<xfs@oss.sgi.com>; Wed, 05 Mar 2014 07:51:51 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 0/8] Add tests for zero range into xfstests
Date: Wed,  5 Mar 2014 16:51:31 +0100
Message-Id: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, lczerner@redhat.com, xfs@oss.sgi.com

Hi,

this patch set adds two new test for zero range into xfstests - generic/008
and ext4/001. It also adds zero range support for fsstress and fsx.

Thanks!
-Lukas

Changes in v2:
- fsstress print left over flag values
- rework test_fallocate() to work properly

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
