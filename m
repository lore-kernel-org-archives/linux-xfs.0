Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D029D7F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 09:04:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC3CB8F8049
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 07:04:16 -0700 (PDT)
Received: from mail-we0-f176.google.com (mail-we0-f176.google.com
	[74.125.82.176]) by cuda.sgi.com with ESMTP id pvmMEUmJEixMF28f
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 May 2013 07:04:15 -0700 (PDT)
Received: by mail-we0-f176.google.com with SMTP id r6so510697wey.35
	for <xfs@oss.sgi.com>; Thu, 02 May 2013 07:04:14 -0700 (PDT)
Received: from dhcp-30-128.brq.redhat.com (nat-pool-brq-t.redhat.com.
	[209.132.186.34])
	by mx.google.com with ESMTPSA id q18sm38435109wiw.8.2013.05.02.07.04.11
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Thu, 02 May 2013 07:04:13 -0700 (PDT)
From: ranto.boris@gmail.com
Subject: [PATCH 0/3] Tmpfs support and fixes for tmpfs/nfs
Date: Thu,  2 May 2013 16:03:56 +0200
Message-Id: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
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

Hi all,

This series contains three patches related to support of tmpfs file system in xfstests.

First patch provides the support itself. Second patch fixes a regression where ./check -nfs -n -g auto stopped working for nfs (and tmpfs) and the last patch changes the failure on empty exclude group to warning to simplify automated testing.

Regards,
Boris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
