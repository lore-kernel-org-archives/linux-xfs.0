Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6K0FvSF002589
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 19:15:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DC5C13B3141
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 17:16:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Nz6Ey3w4xd7u5tvA for
	<linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 17:16:38 -0700 (PDT)
Date: Sun, 19 Jul 2009 20:16:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests: nslookup not found
Message-ID: <20090720001637.GA31674@infradead.org>
References: <alpine.DEB.2.01.0907191050010.6439@bogon>
	<20090719182012.GA10936@infradead.org>
	<alpine.DEB.2.01.0907191653240.6439@bogon>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0907191653240.6439@bogon>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Sun, Jul 19, 2009 at 04:57:19PM -0700, Christian Kujau wrote:
> On Sun, 19 Jul 2009 at 14:20, Christoph Hellwig wrote:
> > Can you resend a patch that just moves _get_fqdn and the check for
> > nslookup from common* into the "new" script?
> 
> If I understand correctly, maybe something like this would be acceptable?
> 
> I was tempted to use "hostname -f" to give out the fqdn, but appaerently 
> not every hostname knows "-f" and I did not want to let the whole script 
> fail just because nslookup is not in place.

Yes, that's exactly it.  Can you resend it with a proper subject,
description and add your Signed-off-by tag?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
