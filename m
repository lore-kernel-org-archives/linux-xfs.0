Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E37C7F37
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 01:26:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DC61304053
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 23:26:05 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id q7THnrGDLimFzjuz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2016 23:26:03 -0800 (PST)
Date: Fri, 8 Jan 2016 23:26:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
Message-ID: <20160109072600.GA21636@infradead.org>
References: <568FEA2C.6080708@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <568FEA2C.6080708@redhat.com>
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
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri, Jan 08, 2016 at 10:56:12AM -0600, Eric Sandeen wrote:
> This adds a new quotactl, Q_XGETQUOTA2.
> 
> Q_XGETQUOTA2 is exactly like Q_XGETQUOTA, except that it will
> return quota information for the id equal to or greater than
> the id requested.  In other words, if the specified id has
> no quota, the command will return quota information for the
> next higher id which does have a quota set.  If no higher id
> has an active quota, -ESRCH is returned.

Please add a flags argument to Q_XGETQUOTA2, and then make the
new behavior the first flag.  Keep Q_XGETQUOTA behavior for the
flag-less case.  That way we get future etensibility for free.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
