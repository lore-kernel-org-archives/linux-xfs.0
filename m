Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54FC37F3F
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 07:48:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCD13AC004
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 05:48:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id R4d5XyjTtfzUQwax (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 05:48:13 -0700 (PDT)
Date: Wed, 12 Aug 2015 08:48:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 12/13] xfs: add helper to conditionally remove items
	from the AIL
Message-ID: <20150812124810.GB20635@bfoster.bfoster>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439233309-19959-13-git-send-email-bfoster@redhat.com>
	<20150812071727.GB14237@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150812071727.GB14237@infradead.org>
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

On Wed, Aug 12, 2015 at 12:17:27AM -0700, Christoph Hellwig wrote:
> > +			xfs_trans_ail_remove(lip->li_ailp, lip,
> > +					     SHUTDOWN_LOG_IO_ERROR);
> 
> I'd say remove the ail argument, lip->li_ailp can be derferenced inside
> xfs_trans_ail_remove safely.

Ok.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
