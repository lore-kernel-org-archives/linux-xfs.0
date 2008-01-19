Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 21:30:37 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0J5UKcj001036
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:30:23 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00F65C9C6B9
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:30:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 9oJPxo4kNi43zFxE for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:30:39 -0800 (PST)
Message-ID: <47918ADF.40205@sandeen.net>
Date: Fri, 18 Jan 2008 23:30:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW 1/2] Case insensitive support for XFS - kernel patch
References: <op.t43zfc073jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t43zfc073jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> This patch should apply to 2.6.24-rc6.

Just FYI, on the stack picture, of the bigger stack users these are the
deltas on my x86_64 box:

-xfs_bulkstat 280
+xfs_bulkstat 296   :(

-xfs_dir2_leaf_getdents 136
+xfs_dir2_leaf_getdents 200

-xfs_dir2_sf_to_block 120
+xfs_dir2_sf_to_block 136

-xfs_dir_canenter 144
+xfs_dir_canenter 152

-xfs_dir_createname 152
+xfs_dir_createname 168

-xfs_dir_lookup 152
+xfs_dir_lookup 168

-xfs_dir_replace 152
+xfs_dir_replace 168

-Eric
