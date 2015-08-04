Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E511D7FA8
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 04:21:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D226A8F8049
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 02:21:46 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id AqijA2SACwKowdAM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 02:21:44 -0700 (PDT)
Date: Tue, 4 Aug 2015 05:21:22 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1716990041.2536058.1438680082030.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150804084625.GB12844@infradead.org>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
	<1438612789-17486-5-git-send-email-jtulak@redhat.com>
	<20150804084625.GB12844@infradead.org>
Subject: Re: [PATCH v3 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
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
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: hch@infradead.org, xfs@oss.sgi.com
> Sent: Tuesday, August 4, 2015 10:46:25 AM
> Subject: Re: [PATCH v3 04/11] xfsprogs: Add ifdef dirent checks where it was	missing
> 
> > diff --git a/io/readdir.c b/io/readdir.c
> > index 20b8898..ed8f04d 100644
> > --- a/io/readdir.c
> > +++ b/io/readdir.c
> > @@ -104,12 +104,16 @@ read_directory(
> >  		if (!dirent)
> >  			break;
> >  
> > +#ifdef _DIRENT_HAVE_D_RECLEN
> >  		*total += dirent->d_reclen;
> > +#endif
> 
> You probably want to use d_namen + sizeof(*dirent) to approimate
> the value if d_reclen doesn't exist.
> 
> >  		count++;
> >  
> >  		if (dump) {
> >  			dump_dirent(offset, dirent);
> > +#ifdef _DIRENT_HAVE_D_OFF
> >  			offset = dirent->d_off;
> > +#endif
> 
> We're only using the offset for dumping the value, maybe setting
> it to 0 and adding a comment explaining it should go into the else
> branch here?
> 

That sounds reasonable, sending an updated patch.

Thanks. :-)

Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
