Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2OHE0Y4168281 for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 12:14:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7915A378752
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 10:17:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id A9yuoVn6LJjqpfPH for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2011 10:17:07 -0700 (PDT)
Date: Thu, 24 Mar 2011 13:17:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.38: Quota over NFS4
Message-ID: <20110324171704.GA1784@infradead.org>
References: <20110320212633.GA26036@fieldses.org>
	<20110320213111.GO11929@os.inf.tu-dresden.de>
	<20110320214316.GB26036@fieldses.org>
	<20110321184043.GC4992@os.inf.tu-dresden.de>
	<20110321222301.GB472@fieldses.org>
	<20110322221305.GA5857@os.inf.tu-dresden.de>
	<20110323150328.GD23418@fieldses.org>
	<20110323174052.GE5005@os.inf.tu-dresden.de>
	<20110323190632.GA26306@fieldses.org>
	<20110323223017.GA5177@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110323223017.GA5177@os.inf.tu-dresden.de>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 23, 2011 at 11:30:17PM +0100, Adam Lackorzynski wrote:
> I probably mistyped something and thus bisected again:

maybe this is just a symptom.  When was the nfs4 code converted
to just use a single open struct file, and what are the lifetime
rules for it?  It would easily be that a long alive file might
make XFS keep persistent preallocations longer or similar issues.

Adam, can you create a loop filesystem with ext3 or something else
on it and see if the problem is XFS-specific?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
