Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68F557F3F
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 07:48:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 433B1304032
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 05:48:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OFvm8X36Wg5vI39Y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 05:48:01 -0700 (PDT)
Date: Wed, 12 Aug 2015 08:47:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/11] xfs: disentagle EFI release from the extent count
Message-ID: <20150812124759.GA20635@bfoster.bfoster>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-2-git-send-email-bfoster@redhat.com>
	<20150809073641.GA3163@infradead.org>
	<20150810123726.GA18933@bfoster.bfoster>
	<20150812071518.GA14237@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150812071518.GA14237@infradead.org>
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

On Wed, Aug 12, 2015 at 12:15:18AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 10, 2015 at 08:37:27AM -0400, Brian Foster wrote:
> > > As a follow on we should be able to remove atomic_inc_return and
> > > replace it with a local iterator in xfs_bmap_finish().
> > > 
> > 
> > I'm not sure what you mean here...
> 
> efi_next_extent is not only used is to find a 'slot' for the extent
> in xfs_trans_log_efi_extent.  For that we don't need an atomic_t
> in the EFI, but can have a local variable in xfs_bmap_finish.

Ok, I see. efi_next_extent isn't used for much at this point. We could
kill it entirely, we'd just have to add an index parameter to the EFI
logging function (or change up the params). We do still have asserts in
the logging and item format handlers that help ensure a properly
constructed EFI, so there is some use I suppose. I'm not sure it needed
to be atomic though, even prior to the changes in this series...

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
