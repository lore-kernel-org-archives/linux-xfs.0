Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 355A97F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 02:15:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1DB958F8033
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 00:15:20 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id oev7NueCxTLAawnH (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 00:15:18 -0700 (PDT)
Date: Wed, 12 Aug 2015 00:15:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: disentagle EFI release from the extent count
Message-ID: <20150812071518.GA14237@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-2-git-send-email-bfoster@redhat.com>
	<20150809073641.GA3163@infradead.org>
	<20150810123726.GA18933@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150810123726.GA18933@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Aug 10, 2015 at 08:37:27AM -0400, Brian Foster wrote:
> > As a follow on we should be able to remove atomic_inc_return and
> > replace it with a local iterator in xfs_bmap_finish().
> > 
> 
> I'm not sure what you mean here...

efi_next_extent is not only used is to find a 'slot' for the extent
in xfs_trans_log_efi_extent.  For that we don't need an atomic_t
in the EFI, but can have a local variable in xfs_bmap_finish.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
