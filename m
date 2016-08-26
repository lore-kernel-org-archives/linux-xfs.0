Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 152B07CAE
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 11:02:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA6F9304048
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 09:02:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w8fatV6dWqOY8VP0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 09:02:11 -0700 (PDT)
Date: Fri, 26 Aug 2016 12:02:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: make xfs_inode_set_eofblocks_tag cheaper for
	the common case
Message-ID: <20160826160209.GB17728@bfoster.bfoster>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-4-git-send-email-hch@lst.de>
	<20160825123808.GC25041@bfoster.bfoster>
	<20160826142616.GA21535@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826142616.GA21535@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 04:26:16PM +0200, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 08:38:09AM -0400, Brian Foster wrote:
> > I'm guessing the lockless check is intentional, but is that really
> > necessary? E.g., it doesn't seem like using ->i_flags_lock
> > unconditionally should affect performance in the way the AG lock or
> > radix tree work does, particularly since we're already holding
> > IOLOCK_EXCL in the current implementation. I could be wrong, but FWIW,
> > we do already have xfs_iflags_test_and_set() sitting around as well...
> 
> I don't think taking it should be too bad, but given the ops ordering
> it also seems entirely pointless to even take it.
> 

Then why are we taking it? I assumed it at least served as a memory
barrier...

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
