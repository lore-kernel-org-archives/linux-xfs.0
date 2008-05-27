Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 09:25:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4RGPNrh022861
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:25:23 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B53CBEEB06
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:26:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id RGPTyeWrf8i3ilUA for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:26:14 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4RGQ6Oc030432
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 18:26:06 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4RGQ5jv030430
	for xfs@oss.sgi.com; Tue, 27 May 2008 18:26:05 +0200
Date: Tue, 27 May 2008 18:26:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: xfs_check
Message-ID: <20080527162605.GA30344@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

In the past we had quite a few cases where we told people to run
xfs_repair -n instead of xfs_check.  I think that makes a lot of sense
because xfs_repair -n generally gives output at least as useful as
xfs_check if not more so and also is a lot faster.  Is there any reason
why we shouldn't simply kill xfs_check and replaced it with a wrapper
around xfs_repair?
