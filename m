Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4DB7A7F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 17:52:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEFE0AC001
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:52:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6agLvnf1Ne5QWqbP for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 15:52:35 -0700 (PDT)
Date: Thu, 2 Oct 2014 08:52:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: kill time.h
Message-ID: <20141001225221.GA10298@dastard>
References: <1411954911-12278-1-git-send-email-david@fromorbit.com>
	<20140929104443.GB10847@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140929104443.GB10847@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 29, 2014 at 03:44:43AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 29, 2014 at 11:41:51AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The typedef for timespecs and nanotime() are completely unnecessary,
> > and delay() can be moved to fs/xfs/linux.h, which means this file
> > can go away.
> 
> Looks good, but shouldn't we just kill delay(), too? There's just
> 11 callers, and none of them in libxfs.

Eventually, yes. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
