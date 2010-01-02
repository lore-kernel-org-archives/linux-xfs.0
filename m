Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02Ck1eV109169 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 06:46:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CB5E172F08B
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 04:46:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pEF46NtbYKwgx6BR for
	<xfs@oss.sgi.com>; Sat, 02 Jan 2010 04:46:51 -0800 (PST)
Date: Sat, 2 Jan 2010 07:46:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Kill filestreams cache flush
Message-ID: <20100102124649.GA8004@infradead.org>
References: <1262399900-19110-1-git-send-email-david@fromorbit.com>
	<20100102115338.GA18502@infradead.org>
	<20100102121203.GG13802@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100102121203.GG13802@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Jan 02, 2010 at 11:12:03PM +1100, Dave Chinner wrote:
> Which means that sync destroys active filestreams associations and
> that seems more broken to me than anything an active reference will
> cause. I think just letting them time out is better than having them
> destroyed by external operations. I'm happy to leave it there if you
> want....

Just trying to understand what's going on here.  If you think the new
behaviour is better and it doesn't cause any regressions in QA I'm fine
with it.  Consider it:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
