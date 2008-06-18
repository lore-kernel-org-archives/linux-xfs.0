Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 10:08:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IH8pbb010140
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:08:51 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3F99CE7004
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:09:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id dKHVDR7YL0uxBkEg for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:09:49 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 4308DA84114
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 12:09:48 -0500 (CDT)
Message-ID: <4859415B.3000009@sandeen.net>
Date: Wed, 18 Jun 2008 12:09:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: is the flush-on-close-after-truncate still needed?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

After Lachlan's fix to separate on-disk and in-memory sizes, and only
update on-disk when data is on-disk
(http://www.linux.sgi.com/archives/xfs/2007-05/msg00020.html) is the
XFS_ITRUNCATED flag / flush-on-close-after-truncate still needed?

Thanks,
-Eric
