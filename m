Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 22:54:32 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L6sOA9024794
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 22:54:28 -0800
Date: Mon, 21 Jan 2008 06:54:42 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with
	struct list_head
Message-ID: <20080121065442.GA31816@infradead.org>
References: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net> <20080121040422.GA25541@infradead.org> <20080121041258.GZ155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121041258.GZ155259@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com

On Mon, Jan 21, 2008 at 03:12:58PM +1100, David Chinner wrote:
> Doesn't really make any difference to me - i've got to rebase the patch
> on the xfsaild thread commit anyway....

Ok, then I'm all for putting it in.  Especially as it should help
detangling the header mess.  IIRC after this patch there is no need
anymore to pull in xfs_trans.h before xfs_mount.h anymore.
