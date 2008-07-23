Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 14:46:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NLkcHG026064
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:46:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D4E9E8F496
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:47:47 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ywVTKUDsKCsJwSRy for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:47:47 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NLlbNg010775
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:47:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NLlbff010773
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 23:47:37 +0200
Date: Wed, 23 Jul 2008 23:47:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/2] kill bhv_vnode_t
Message-ID: <20080723214737.GA10655@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dave complained today that the fate of bhv_vnode_t isn't entirely clear
yet, so I've prepared these two patches to kill it in a minimally
invasive way.  While it causes churn in a lot of areas it does not
affect the generated code at all.
