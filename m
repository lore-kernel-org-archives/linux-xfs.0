Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 19:08:38 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4228I6c020380
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 19:08:19 -0700
From: xaiki@sgi.com
Subject: Don't use d_alloc_anon for open_by_handle
Date: Fri,  2 May 2008 11:55:37 +1000
Message-Id: <1209693339-4861-1-git-send-email-xaiki@sgi.com>
In-Reply-To: <20080501070244.GH108924158@sgi.com>
References: <20080501070244.GH108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

One of our DMAPI user found that in some cases inodes weren't getting through
xfs_inactive() in any reasonable amount of time. Investigation tracked it down
to the use of d_alloc_anon() combined with another thread accessing the same
inode via an open().

So we introduce a stripped down version of d_alloc_anon, that won't try to find
an existing dentry, nor will hash it.
