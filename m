Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2P008mp187065 for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 19:00:08 -0500
Received: from fieldses.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6EC6141EF7A
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 17:03:14 -0700 (PDT)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id gZX48pC1DJrKQOVW for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2011 17:03:14 -0700 (PDT)
Date: Thu, 24 Mar 2011 20:03:10 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.38: Quota over NFS4
Message-ID: <20110325000310.GA5514@fieldses.org>
References: <20110321184043.GC4992@os.inf.tu-dresden.de>
	<20110321222301.GB472@fieldses.org>
	<20110322221305.GA5857@os.inf.tu-dresden.de>
	<20110323150328.GD23418@fieldses.org>
	<20110323174052.GE5005@os.inf.tu-dresden.de>
	<20110323190632.GA26306@fieldses.org>
	<20110323223017.GA5177@os.inf.tu-dresden.de>
	<20110324171704.GA1784@infradead.org>
	<20110324175106.GB1886@fieldses.org>
	<20110324222807.GC10821@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110324222807.GC10821@os.inf.tu-dresden.de>
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
To: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Mar 24, 2011 at 11:28:07PM +0100, Adam Lackorzynski wrote:
> 
> On Thu Mar 24, 2011 at 13:51:06 -0400, J. Bruce Fields wrote:
> > On Thu, Mar 24, 2011 at 01:17:05PM -0400, Christoph Hellwig wrote:
> > > On Wed, Mar 23, 2011 at 11:30:17PM +0100, Adam Lackorzynski wrote:
> > > > I probably mistyped something and thus bisected again:
> > > 
> > > maybe this is just a symptom.  When was the nfs4 code converted
> > > to just use a single open struct file, and what are the lifetime
> > > rules for it?  It would easily be that a long alive file might
> > > make XFS keep persistent preallocations longer or similar issues.
> > 
> > Definitely, the commit he's bisect to there seems much more likely to be
> > a culprit.  I'll take a closer look....
> > 
> > > Adam, can you create a loop filesystem with ext3 or something else
> > > on it and see if the problem is XFS-specific?
> > 
> > Originally it sounded like he was able to reproduce this only on one
> > specific filesystem so I wondered whether there was something particular
> > to that filesystem.
> 
> I just found out it happens also with a newly created xfs and also with
> ext3 and ext4. The reason that I did not see that initially is that the
> script I'm using needs to be on the same fs which wasn't the case when I
> initially tried it with a new fs. The sequence I'm using is:

Ah-hah, got it.  So the leak's probably of a delegation on the file
containing the script itself.  OK, I should be able to fix that, thanks!

--b.

> 
> # mount x.x.x:/home /tmp/st
> # su - foo
> $ cd /tmp/st/foo/x
> $ ../test-script
> foo@host:/tmp/st/foo/x$ ../test-script 
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> x.x.x:/home    39321600      15 39321585    1% /tmp/st
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> x.x.x:/home    39321600      16 39321584    1% /tmp/st
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> x.x.x:/home    39321600      16 39321584    1% /tmp/st
> 
> 
> 
> test-script:
> #! /bin/sh
> 
> df -i .
> cp /bin/ls x1
> df -i .
> cat x1 > /dev/null
> rm x1
> df -i .
> 
> 
> 
> 
> 
> 
> Adam
> -- 
> Adam                 adam@os.inf.tu-dresden.de
>   Lackorzynski         http://os.inf.tu-dresden.de/~adam/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
