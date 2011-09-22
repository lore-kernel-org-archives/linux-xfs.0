Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MH1JnN246014 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 12:01:19 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AC7A140E4BA
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 10:06:47 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id GlDbPdeVyZNZNE2b for
	<xfs@oss.sgi.com>; Thu, 22 Sep 2011 10:06:47 -0700 (PDT)
Date: Thu, 22 Sep 2011 19:01:14 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: System stuck in D state while deleting messages in mutt
Message-ID: <20110922170114.GA1627@x4.trippels.de>
References: <20110919135622.GA13039@x4.trippels.de>
	<20110922164930.GC12353@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110922164930.GC12353@infradead.org>
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

On 2011.09.22 at 12:49 -0400, Christoph Hellwig wrote:
> On Mon, Sep 19, 2011 at 03:56:22PM +0200, Markus Trippelsdorf wrote:
> > My system just got stuck while I was trying to delete old messages in
> > mutt. I'm running the latest git kernel. This happened on my SSD:
> 
> Stuck as in staying in it for a long time, or forever?

Longer than 5 minutes and then I rebooted.

> Are you using Maildir?

Yes. I was trying to delete ~3000 messages in one directory.

I think this issue is a manifestation of the same deadlock that Stefan
reported earlier.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
