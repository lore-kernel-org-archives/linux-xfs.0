Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3MJRdll229191 for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 14:27:40 -0500
Received: from fieldses.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC2921A34CBD
	for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 12:31:08 -0700 (PDT)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id QcptHFDjCIlY5qDo for <xfs@oss.sgi.com>;
	Fri, 22 Apr 2011 12:31:08 -0700 (PDT)
Date: Fri, 22 Apr 2011 15:31:03 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.38: Quota over NFS4
Message-ID: <20110422193103.GB32290@fieldses.org>
References: <20110321222301.GB472@fieldses.org>
	<20110322221305.GA5857@os.inf.tu-dresden.de>
	<20110323150328.GD23418@fieldses.org>
	<20110323174052.GE5005@os.inf.tu-dresden.de>
	<20110323190632.GA26306@fieldses.org>
	<20110323223017.GA5177@os.inf.tu-dresden.de>
	<20110324171704.GA1784@infradead.org>
	<20110324175106.GB1886@fieldses.org>
	<20110324222807.GC10821@os.inf.tu-dresden.de>
	<20110325000310.GA5514@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110325000310.GA5514@fieldses.org>
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

On Thu, Mar 24, 2011 at 08:03:10PM -0400, J. Bruce Fields wrote:
> On Thu, Mar 24, 2011 at 11:28:07PM +0100, Adam Lackorzynski wrote:
> > 
> > On Thu Mar 24, 2011 at 13:51:06 -0400, J. Bruce Fields wrote:
> > > On Thu, Mar 24, 2011 at 01:17:05PM -0400, Christoph Hellwig wrote:
> > > > On Wed, Mar 23, 2011 at 11:30:17PM +0100, Adam Lackorzynski wrote:
> > > > > I probably mistyped something and thus bisected again:
> > > > 
> > > > maybe this is just a symptom.  When was the nfs4 code converted
> > > > to just use a single open struct file, and what are the lifetime
> > > > rules for it?  It would easily be that a long alive file might
> > > > make XFS keep persistent preallocations longer or similar issues.
> > > 
> > > Definitely, the commit he's bisect to there seems much more likely to be
> > > a culprit.  I'll take a closer look....
> > > 
> > > > Adam, can you create a loop filesystem with ext3 or something else
> > > > on it and see if the problem is XFS-specific?
> > > 
> > > Originally it sounded like he was able to reproduce this only on one
> > > specific filesystem so I wondered whether there was something particular
> > > to that filesystem.
> > 
> > I just found out it happens also with a newly created xfs and also with
> > ext3 and ext4. The reason that I did not see that initially is that the
> > script I'm using needs to be on the same fs which wasn't the case when I
> > initially tried it with a new fs. The sequence I'm using is:
> 
> Ah-hah, got it.  So the leak's probably of a delegation on the file
> containing the script itself.  OK, I should be able to fix that, thanks!

This should be fixed in the latest upstream (so, in 39-rc5, when that
comes out) and soon in stable.  Let me know if not.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
