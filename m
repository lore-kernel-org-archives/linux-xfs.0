Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E1217F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 15:53:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E3E18F8089
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 13:53:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Kk2SWTC98gAqDNfj for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 13:53:48 -0700 (PDT)
Received: from Liberator.local (unknown [40.139.179.11])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5530163C3A20
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 15:53:47 -0500 (CDT)
Message-ID: <54FF59DA.60700@sandeen.net>
Date: Tue, 10 Mar 2015 16:53:46 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 0/4] xfs_repair: clean up process_sf_dir2
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
To: xfs-oss <xfs@oss.sgi.com>

4 patches, which in the end collapse & remove a bit of code.

First patch adds a missing dino_dirty flag in a cut&paste codepath
Second patch removes impossible tests (if (A) tests under a
(!A) codepath).
Third patch collapses two different "bad namelen" casess into one.
Fourth removes special handling of the last entry, which doesn't work anyway.

More details in the individual patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
