Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 17:27:40 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA31RRRx020528
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 17:27:28 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19D451BDB76D
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 17:27:29 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id xe2IPJnKW4GMtq4G for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 17:27:29 -0800 (PST)
Date: Mon, 3 Nov 2008 12:27:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] embededd struct xfs_imap into xfs_inode
Message-ID: <20081103012725.GP19509@disturbed>
References: <20081027134126.GE3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027134126.GE3183@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:41:26AM -0400, Christoph Hellwig wrote:
> Most uses of struct xfs_imap are to map and inode to a buffer.  To avoid
> copying around the inode location information we should just embedd a
> strcut xfs_imap into the xfs_inode.  To make sure it doesn't bloat an
> inode the im_len is changed to a ushort, which is fine as that's what
> the users exepect anyway.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
