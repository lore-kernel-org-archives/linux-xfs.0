Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 00:23:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m997MxpV020859
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 00:22:59 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E71B61B0D05B
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 00:24:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id s3rJLAmAKBiqWmLT for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 00:24:39 -0700 (PDT)
Date: Thu, 9 Oct 2008 03:24:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] kill XFS_LITINO
Message-ID: <20081009072438.GA19672@infradead.org>
References: <20081007202153.GA16485@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007202153.GA16485@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

After some discusson in IRC I'll take this patch back.  We need to
do this calculation per inode, and for that XFS_LITINO needs to be
replaced with a per-inode macro and not a direct dereference of
a xfs_mount member.  I'll post versions of the other two patches
that don't need this one ASAP.
