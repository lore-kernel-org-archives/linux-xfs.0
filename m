Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E43EE7F3F
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 05:16:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 661CAAC002
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 03:16:27 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Di54fZ0Gwnlu72gJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 03:16:26 -0700 (PDT)
Date: Sun, 4 May 2014 12:16:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: attr cleanups
Message-ID: <20140504101623.GA4947@lst.de>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<53651375.9080305@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53651375.9080305@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, May 03, 2014 at 11:04:05AM -0500, Mark Tinguely wrote:
> Depends on how parent inode pointers are implemented, this folding the 
> internal version of get and set attributes could be undone.

We might have to introduce _locked version at that point.  But I'd like
to keep the xfs_name removal and other assorted cleanups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
