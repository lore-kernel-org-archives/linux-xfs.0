Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAG7wbUJ148259 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 01:58:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 861362526F9
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 23:58:32 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wpJljZ0wcXPhGIXZ for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 23:58:32 -0800 (PST)
Date: Wed, 16 Nov 2011 02:58:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] repair: validate acl count before reading it
Message-ID: <20111116075829.GA15620@infradead.org>
References: <20111115080714.GA24931@infradead.org>
	<20111116002323.GW5534@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111116002323.GW5534@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 16, 2011 at 11:23:23AM +1100, Dave Chinner wrote:
> >  	count = be32_to_cpu(dacl->acl_cnt);
> > +	if (count > XFS_ACL_MAX_ENTRIES) {
> > +		do_warn(_("to larget ACL, size %d"), count);
> 
>                            "Too many ACL entries, count %d\n" 

Ok.

> > +		*aclp = NULL;
> > +		return EINVAL;
> > +	}
> > +
> > +
> >  	end = &dacl->acl_entry[0] + count;
> >  	acl = malloc((int)((char *)end - (char *)dacl));
> > -	if (!acl)
> > -		return NULL;
> > +	if (!acl) {
> > +		do_warn(_("cannot malloc enough for ACL attribute\n"));
> > +		do_warn(_("SKIPPING this ACL\n"));
> 
> Should you put that same "Skipping" message for all the error cases?

For the ENOMEM case we indeed skip the ACL.  For other errors we will
just remove this attribute.  Given how enomem really should not just
happen for that small ACL I wonder how special casing it makes any
sense - but that code has been there for a while.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
