Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1FL3com087868 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 15:03:40 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A072A1CFB09
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 13:04:54 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 70ClrsErW5knoxem for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 13:04:54 -0800 (PST)
Subject: Re: [PATCH 0/4] implement optimized fdatasync
From: Andi Kleen <andi@firstfloor.org>
References: <20100215094445.528696829@bombadil.infradead.org>
Date: Mon, 15 Feb 2010 22:04:52 +0100
In-Reply-To: <20100215094445.528696829@bombadil.infradead.org> (Christoph
	Hellwig's message of "Mon, 15 Feb 2010 04:44:45 -0500")
Message-ID: <877hqemcqz.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> This series implements a real fdatasync, that is one that is not
> simply identical to fdatasync, but one that skips logging the inode


... to fsync?

> if there are only timestamp updates.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
