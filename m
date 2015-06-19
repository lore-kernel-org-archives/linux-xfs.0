Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFEF47F58
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 06:52:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6ACD9AC008
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 04:52:15 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id UZWRL0NeAbFioDcM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 04:52:13 -0700 (PDT)
Date: Fri, 19 Jun 2015 07:51:50 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <322058154.17077903.1434714710791.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150619111022.GA5212@infradead.org>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-2-git-send-email-jtulak@redhat.com>
	<20150619111022.GA5212@infradead.org>
Subject: Re: [PATCH 01/17] xfsprogs: use common code for multi-disk detection
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>



----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> To: "Jan ??ul??k" <jtulak@redhat.com>
> Cc: "Dave Chinner" <dchinner@redhat.com>, xfs@oss.sgi.com
> Sent: Friday, June 19, 2015 1:10:22 PM
> Subject: Re: [PATCH 01/17] xfsprogs: use common code for multi-disk detection
> 
> > index 70e43a0..3269ec3 100644
> > --- a/include/Makefile
> > +++ b/include/Makefile
> > @@ -26,9 +26,15 @@ QAHFILES = libxfs.h libxlog.h \
> >  	xfs_inode.h \
> >  	xfs_log_recover.h \
> >  	xfs_metadump.h \
> > +	xfs_mkfs.h \
> >  	xfs_mount.h \
> > +	xfs_quota_defs.h \
> > +	xfs_sb.h \
> > +	xfs_shared.h \
> >  	xfs_trace.h \
> > -	xfs_trans.h
> > +	xfs_trans.h \
> > +	xfs_trans_resv.h \
> > +	xfs_trans_space.h
> 
> These shouldn't be added to the headers installed by make install-qa.
> 
> (which I'm going to send a patch to remove once Dave applied the
> build fix, btw)
> 
OK, noted.

> Also I'm not sure xfs_mkfs.h really is a good name for a global header.

I don't see any issue with it, but if there is a reason for a different name, I can change it. :-)

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
