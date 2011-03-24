Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2OMP7Pw182691 for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 17:25:08 -0500
Received: from os.inf.tu-dresden.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6618F379648
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 15:28:14 -0700 (PDT)
Received: from os.inf.tu-dresden.de (os.inf.tu-dresden.de [141.76.48.99]) by
	cuda.sgi.com with ESMTP id 3P3ZL0a6sr5GFDZu for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2011 15:28:14 -0700 (PDT)
Date: Thu, 24 Mar 2011 23:28:07 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Subject: Re: 2.6.38: Quota over NFS4
Message-ID: <20110324222807.GC10821@os.inf.tu-dresden.de>
References: <20110320214316.GB26036@fieldses.org>
	<20110321184043.GC4992@os.inf.tu-dresden.de>
	<20110321222301.GB472@fieldses.org>
	<20110322221305.GA5857@os.inf.tu-dresden.de>
	<20110323150328.GD23418@fieldses.org>
	<20110323174052.GE5005@os.inf.tu-dresden.de>
	<20110323190632.GA26306@fieldses.org>
	<20110323223017.GA5177@os.inf.tu-dresden.de>
	<20110324171704.GA1784@infradead.org>
	<20110324175106.GB1886@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110324175106.GB1886@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com


On Thu Mar 24, 2011 at 13:51:06 -0400, J. Bruce Fields wrote:
> On Thu, Mar 24, 2011 at 01:17:05PM -0400, Christoph Hellwig wrote:
> > On Wed, Mar 23, 2011 at 11:30:17PM +0100, Adam Lackorzynski wrote:
> > > I probably mistyped something and thus bisected again:
> > 
> > maybe this is just a symptom.  When was the nfs4 code converted
> > to just use a single open struct file, and what are the lifetime
> > rules for it?  It would easily be that a long alive file might
> > make XFS keep persistent preallocations longer or similar issues.
> 
> Definitely, the commit he's bisect to there seems much more likely to be
> a culprit.  I'll take a closer look....
> 
> > Adam, can you create a loop filesystem with ext3 or something else
> > on it and see if the problem is XFS-specific?
> 
> Originally it sounded like he was able to reproduce this only on one
> specific filesystem so I wondered whether there was something particular
> to that filesystem.

I just found out it happens also with a newly created xfs and also with
ext3 and ext4. The reason that I did not see that initially is that the
script I'm using needs to be on the same fs which wasn't the case when I
initially tried it with a new fs. The sequence I'm using is:

# mount x.x.x:/home /tmp/st
# su - foo
$ cd /tmp/st/foo/x
$ ../test-script
foo@host:/tmp/st/foo/x$ ../test-script 
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
x.x.x:/home    39321600      15 39321585    1% /tmp/st
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
x.x.x:/home    39321600      16 39321584    1% /tmp/st
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
x.x.x:/home    39321600      16 39321584    1% /tmp/st



test-script:
#! /bin/sh

df -i .
cp /bin/ls x1
df -i .
cat x1 > /dev/null
rm x1
df -i .






Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
