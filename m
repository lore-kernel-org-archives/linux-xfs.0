Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B7277F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 07:38:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 22D7C8F8039
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 05:38:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cOP49PcQ2YFizD0z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 05:38:55 -0700 (PDT)
Date: Mon, 10 Aug 2015 08:38:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/11] xfs: don't leave EFIs on AIL on mount failure
Message-ID: <20150810123853.GD18933@bfoster.bfoster>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-7-git-send-email-bfoster@redhat.com>
	<20150809080150.GA4253@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150809080150.GA4253@infradead.org>
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

On Sun, Aug 09, 2015 at 01:01:50AM -0700, Christoph Hellwig wrote:
> >  STATIC int
> >  xlog_recover_process_efis(
> > -	struct xlog	*log)
> > +	struct xlog		*log,
> > +	bool			cancel)
> 
> There is almost no code shared between cancelation and processing,
> so please add a new xlog_cancel_efis helper instead.
> 

See v2.

> > +		efip = (struct xfs_efi_log_item *) lip;
> 
> Please use container_of to get to a containing structure.
> 

Ok.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
