Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72F7E7F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 07:24:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31ACA304039
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 05:24:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bYswj6kxvELN3iW2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2015 05:24:04 -0700 (PDT)
Date: Wed, 23 Sep 2015 08:24:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_io: Implement inodes64 command - bug in
	XFS_IOC_FSINUMBERS?
Message-ID: <20150923122401.GA37210@bfoster.bfoster>
References: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
	<20150921220832.GB19114@dastard>
	<20150922075432.GC26699@redhat.com>
	<20150922122238.GA46026@bfoster.bfoster>
	<20150922220054.GL19114@dastard> <20150923102834.GA4490@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150923102834.GA4490@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On Wed, Sep 23, 2015 at 12:28:34PM +0200, Carlos Maiolino wrote:
> Howdy folks,
> 
> I was working in implementing the suggested feature in my patch, about getting
> the next inode used after one is provided, and I hit something that I'm not really
> sure if this might be considered a bug, or just a work form.
> 
> XFS_IOC_FSINUMBERS, is supposed to be called with a zeroed
> xfs_fsop_bulkreq.lastip, so at each call, kernel will update this number to the
> last inode returned, and, the next call will return in xfs_inogrp.xi_startino,
> the next existing inode after .lastip.
> 
> So, I was expecting that, passing a non-zero .lastip at the first call, I would
> be able to get the next inode right after the one I passed through .lastip, but,
> after some tests and reading the code, I noticed that this is not the case.
> 
> The problem (not sure if I can really say it's a problem), is that, if the inode
> number passed, happens to be somewhere in the middle of an inode chunk, the
> whole chunk will not be printed, only the next inode chunk will start to be
> printed, hiding all information of the previous one.
> 
> I'm not sure if this is the desired behavior or not, but, I'd say that, if the
> inode passed in .lastip, is not the first in the chunk, the output should start
> for its own chunk, instead of the next one, but, I prefer to see you folks POV
> before starting to fix something that I'm not sure if it's actually broken :-)
> 

On a quick pass through, it seems like this is probably just the nature
of the granularity and typical use case of the inumbers interface. For
one, I think the lastip parameter is intended to be used as a cookie as
opposed to an inode-granularity search key. The return structures also
appear to describe inode records so there isn't any natural way to get a
partial record that I can see. Note that bulkstat does appear to support
an inode granularity starting point (see xfs_bulkstat_grab_ichunk()) as
the output format is inode granularity.

FWIW, I would probably try to handle something like the above in
userspace by working with the interface rather than modifying it. In
other words, subtract (at least) XFS_INODES_PER_CHUNK from the inode
number in question and use that as a starting point to ensure the output
contains the record for the inode if one exists.

It seems like you could change the inumbers behavior to return the
record that contains lastip + 1 if you really wanted to, we'd just have
to take care not to break the lastip behavior itself (e.g., we can't
just search for any record that contains lastip). What looks
interesting, and might justify doing something in this area, is the
behavior presumably caused by doing a greater than or equal to
(XFS_LOOKUP_GE) lookup in xfs_inumbers(). If lastino happens to be a
record startino, we'll actually return the record that contains that
inode (thus technically supporting a mid-record start). If the index in
the record is beyond that, we'll skip it and start at the next record.
Unless I misinterpret that, it seems like that should be fixed one way
or another.

Brian

> Cheers
> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
