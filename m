Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13FnnPM072507 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 09:49:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BD7EDF7C7
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 07:49:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cjCX0WpjDQGV867J for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 07:49:09 -0800 (PST)
Date: Tue, 3 Feb 2009 10:49:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090203154907.GA21278@infradead.org>
References: <498376CF.8020806@renderforce.de> <200902031022.38583@zmi.at>
	<20090203093239.GA14963@infradead.org> <200902031140.08576@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902031140.08576@zmi.at>
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

On Tue, Feb 03, 2009 at 11:40:08AM +0100, Michael Monnerie wrote:
> On Dienstag 03 Februar 2009 Christoph Hellwig wrote:
> > Yes. ?I would hope raid controllers disable the write cache on disks,
> > but for lower end controllers I'm not sure they really do it.
> 
> On Areca Controllers, I can select if I want it on or off. Could an 
> information about the disk cache be written to the FAQ? Would for sure 
> save some people's data... :-)
> 
> So battery backed controller cache on, disk cache off, barriers off.
> Quite simple once you know it :-))

Yeah, that sounds correct.  Do you volunteer for the FAQ entry?  xfs.org
is a wiki so you could add it.  I'm happy to proof-read it if you want.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
