Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2OHm5Bh169943 for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 12:48:06 -0500
Received: from fieldses.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 146263787A6
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 10:51:11 -0700 (PDT)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id yXJMBn4yBs6KJx7G for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2011 10:51:11 -0700 (PDT)
Date: Thu, 24 Mar 2011 13:51:06 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.38: Quota over NFS4
Message-ID: <20110324175106.GB1886@fieldses.org>
References: <20110320213111.GO11929@os.inf.tu-dresden.de>
	<20110320214316.GB26036@fieldses.org>
	<20110321184043.GC4992@os.inf.tu-dresden.de>
	<20110321222301.GB472@fieldses.org>
	<20110322221305.GA5857@os.inf.tu-dresden.de>
	<20110323150328.GD23418@fieldses.org>
	<20110323174052.GE5005@os.inf.tu-dresden.de>
	<20110323190632.GA26306@fieldses.org>
	<20110323223017.GA5177@os.inf.tu-dresden.de>
	<20110324171704.GA1784@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110324171704.GA1784@infradead.org>
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
Cc: linux-nfs@vger.kernel.org, Adam Lackorzynski <adam@os.inf.tu-dresden.de>, xfs@oss.sgi.com

On Thu, Mar 24, 2011 at 01:17:05PM -0400, Christoph Hellwig wrote:
> On Wed, Mar 23, 2011 at 11:30:17PM +0100, Adam Lackorzynski wrote:
> > I probably mistyped something and thus bisected again:
> 
> maybe this is just a symptom.  When was the nfs4 code converted
> to just use a single open struct file, and what are the lifetime
> rules for it?  It would easily be that a long alive file might
> make XFS keep persistent preallocations longer or similar issues.

Definitely, the commit he's bisect to there seems much more likely to be
a culprit.  I'll take a closer look....

> Adam, can you create a loop filesystem with ext3 or something else
> on it and see if the problem is XFS-specific?

Originally it sounded like he was able to reproduce this only on one
specific filesystem so I wondered whether there was something particular
to that filesystem.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
