Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 377887F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 07:18:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B91C7AC004
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:18:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gbAFde2xqmdyy1M0 for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 05:18:33 -0700 (PDT)
Date: Tue, 27 May 2014 08:18:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs: add scan owner field to xfs_eofblocks
Message-ID: <20140527121810.GB63281@bfoster.bfoster>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-2-git-send-email-bfoster@redhat.com>
	<20140527104428.GC1440@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527104428.GC1440@infradead.org>
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

On Tue, May 27, 2014 at 03:44:28AM -0700, Christoph Hellwig wrote:
> On Fri, May 23, 2014 at 07:52:28AM -0400, Brian Foster wrote:
> > The scan owner field represents an optional inode number that is
> > responsible for the current scan. The purpose is to identify that an
> > inode is under iolock and as such, the iolock shouldn't be attempted
> > when trimming eofblocks. This is an internal only field.
> 
> xfs_free_eofblocks already does a trylock, and without that calling it
> from one iolock holding process to another would be a deadlock waiting
> to happen.
> 
> I have to say I'm still not very easy with iolock nesting, even if it's
> a trylock.
> 

Right... maybe I'm not parsing your point. The purpose here is to avoid
the trylock entirely. E.g., Indicate that we have already acquired the
lock and can proceed with xfs_free_eofblocks(), rather than fail a
trylock and skip (which appears to be a potential infinite loop scenario
here due to how the AG walking code handles EAGAIN).

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
