Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Sep 2008 17:20:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m910Ienw007191
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 17:18:41 -0700
Received: from shards.monkeyblade.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CE051B4FBE9
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 17:20:16 -0700 (PDT)
Received: from shards.monkeyblade.net (shards.monkeyblade.net [198.137.202.13]) by cuda.sgi.com with ESMTP id fAOFB896Xh2NzVv8 for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 17:20:16 -0700 (PDT)
Received: from [172.19.0.93] (c-67-164-30-157.hsd1.ca.comcast.net [67.164.30.157])
	(authenticated bits=0)
	by shards.monkeyblade.net (8.14.1/8.14.1) with ESMTP id m910KDRv022148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 17:20:14 -0700
Subject: XFS website remiss
From: "J.H." <warthog9@kernel.org>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 17:20:15 -0700
Message-Id: <1222820415.2854.78.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Afternoon everyone,

Since I happened to be rebuilding a couple of machines and was poking
around on the XFS website (http://oss.sgi.com/projects/xfs/) - I noticed
that it's remiss in one of the more prominent users - kernel.org.

===============

A bit more than a year ago kernel.org, in an ever increasing need to
squeeze more performance out of it's machines, made the leap of
migrating the primary mirror machines (mirrors.kernel.org) to XFS.  We
site a number of reasons including fscking 5.5T of disk is long and
painful, we were hitting various cache issues, and we were seeking
better performance out of our file system.

After initial tests looked positive we made the jump, and have been
quite happy with the results.  With an instant increase in performance
and throughput, as well as the worst xfs_check we've ever seen taking 10
minutes, we were quite happy.  Subsequently we've moved all primary
mirroring file-systems to XFS, including www.kernel.org , and
mirrors.kernel.org.  With an average constant movement of about 400mbps
around the world, and with peaks into the 3.1gbps range serving
thousands of users simultaneously it's been a file system that has taken
the brunt we can throw at it and held up spectacularly.

===============

- John 'Warthog9' Hawley
Chief Kernel.org Administrator
