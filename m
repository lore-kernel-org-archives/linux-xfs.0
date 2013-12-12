Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7919B7F72
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:31:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64004304043
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:31:17 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Uwc0JocJfqTqfgyp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:31:16 -0800 (PST)
Date: Thu, 12 Dec 2013 10:31:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_metadump: Make -F (force) optional
Message-ID: <20131212183115.GA16378@infradead.org>
References: <52A9F6CF.1070300@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A9F6CF.1070300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> xfs_metadump will pass "-F" to xfs_db to carry on even in the face
> of bad superblock magic. [1]  Depending on what we gave as an input
> file, we may very well fail quite badly:
> 
> > xfs_metadump: /root/anaconda.cfg is not a valid XFS filesystem (unexpected SB magic number 0x230a2320)
> > Floating point exception
> 
> I don't think it's possible to harden every path through libxfs for
> non-xfs filesystems as input.  (Even if it's possible, I don't think it's
> worth the effort).

Can you add a test to verify that xfs_metadump now correctly rejects
files that don't have a valid superblock?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
