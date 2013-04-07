Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1FA097F69
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 07:00:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A1AB8F8035
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 05:00:03 -0700 (PDT)
Received: from mail-oa0-f43.google.com (mail-oa0-f43.google.com
	[209.85.219.43]) by cuda.sgi.com with ESMTP id YoW997aNCgMnRAY0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Apr 2013 05:00:03 -0700 (PDT)
Received: by mail-oa0-f43.google.com with SMTP id l10so5326254oag.30
	for <xfs@oss.sgi.com>; Sun, 07 Apr 2013 05:00:02 -0700 (PDT)
Message-ID: <51615FBF.2020001@gmail.com>
Date: Sun, 07 Apr 2013 19:59:59 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: xfstests 'make install' failed
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfstests <xfs@oss.sgi.com>

Hi,

The testcases of xfstests have been reorganized into different subdirs to filesystems.
But the 'install' section of Makefile still uses the old location of testcases.

The 'install' of Makefile needs to be modified for the latest source code organization.

Can someone share me one patch to make the install successful?


Thanks,
Sheng-Hui

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
