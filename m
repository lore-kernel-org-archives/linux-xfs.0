Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A170A7F6F
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 14:13:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21C10AC001
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 12:13:18 -0700 (PDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id HtYyvRkRz4Fro4SO
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 18 Jul 2014 12:13:17 -0700 (PDT)
Received: by mail-wg0-f45.google.com with SMTP id x12so3967543wgg.16
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 12:13:16 -0700 (PDT)
Received: from teal.hq.k1024.org (178-83-234-80.dynamic.hispeed.ch.
	[178.83.234.80])
	by mx.google.com with ESMTPSA id o2sm9660602wij.24.2014.07.18.12.13.15
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Fri, 18 Jul 2014 12:13:15 -0700 (PDT)
Date: Fri, 18 Jul 2014 21:13:14 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: Error setting extent size on a directory
Message-ID: <20140718191314.GB27801@teal.hq.k1024.org>
References: <20140714070913.GA29541@teal.hq.k1024.org>
	<20140717090450.GA27425@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140717090450.GA27425@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, Jul 17, 2014 at 02:04:50AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 14, 2014 at 09:09:13AM +0200, Iustin Pop wrote:
> > The xfsctl man page says that an extent size should be settable any time
> > on a directory, so why would this fail? Looking at the kernel sources,
> > I see a number of possible cases where EINVAL is returned:
> 
> And no special casing for directories at all..

I was not sure if di_nextents is valid (tracks the extents number, and
hence can be non-zero for a directory), I'll take this as a
confirmation.

> > So to me this reads as if the di_nextents check can also fail for a
> > directory which has extents, contradicting the man page. Which one needs
> > to be updated?
> > 
> > The question arises to if the extent size also applies, then, to
> > allocating extents for a directory - instead of just being inherited for
> > files (the man page says no).
> 
> We're not using the extent size hint on the directory itself.

Aha, this is good to know.

> So to
> me it seems we just not check for already allocated blocks if we're
> setting the extent size on a directory, but instead maybe make sure
> the directory.

Not sure I parse that - do you mean we should either check for a
directory, or for zero extent count?

> What's also a little odd is that we allow setting
> the extent size on a directory even if the extent size inherit bit is
> not set, which doesn't make much sense to me.

Since the hint it is never used for directories, agreed it doesn't make
sense. Should this be an error (since I don't think warnings can be
reported).

> Do you want to prepare a patch to remove the check for directories?
> At testcase for xfstests that ensures this works also would be highly
> useful..

I'll try to. Is the tree against which I should sent the kernel patch at
git://oss.sgi.com/xfs/xfs?

thanks,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
