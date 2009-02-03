Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n139XnXY051086 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 03:33:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27E2818ACFA9
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 01:33:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id X3fNlJ5LhQvHI6RI for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 01:33:10 -0800 (PST)
Date: Tue, 3 Feb 2009 04:32:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090203093239.GA14963@infradead.org>
References: <498376CF.8020806@renderforce.de> <200902030222.47644@zmi.at>
	<4987B673.8030406@sandeen.net> <200902031022.38583@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902031022.38583@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Feb 03, 2009 at 10:22:38AM +0100, Michael Monnerie wrote:
> But what about the hard disk cache - should that be disabled? I think in 
> case of a power failure, they just loose their cache contents, right? So 
> the battery-backed controller cache only helps himself, the disks will 
> just throw away up to the 32MB cache they have?

Yes.  I would hope raid controllers disable the write cache on disks,
but for lower end controllers I'm not sure they really do it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
