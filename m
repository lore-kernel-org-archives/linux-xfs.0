Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A73BF7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 06:29:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 758448F8033
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 04:29:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MAg5wKPX2BGkl6OK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 04:29:55 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C685350F4D
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 11:29:54 +0000 (UTC)
Received: from redhat.com (vpn-57-209.rdu2.redhat.com [10.10.57.209])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u56BTpA1013375
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Mon, 6 Jun 2016 07:29:54 -0400
Date: Mon, 6 Jun 2016 13:29:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/3] xfs: add an option to enable reflinks at mount time
Message-ID: <20160606112950.GC23695@redhat.com>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<1464877150-20457-4-git-send-email-hch@lst.de>
	<20160606112342.GB23695@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160606112342.GB23695@redhat.com>
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
To: xfs@oss.sgi.com

Ugh, I just realized dave and derrick had already replied, pointing issues I
didn't figure out, but still I'm curious for the question I asked :)

> Hi hch,
> 
> The patchset looks good, although I'm not quite familiar with the reflink code
> so, I apologize if it is a stupid question
> 
> After enabling the reflink feature during mount time, I believe this will not
> have any problems in future mounts of this filesystem without reflink support?
> 
> > index 84348af..dfa5077 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -82,7 +82,7 @@ enum {
> >  	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
> >  	Opt_uquota, Opt_gquota, Opt_pquota,
> >  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> > -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
> > +	Opt_discard, Opt_nodiscard, Opt_reflink, Opt_dax, Opt_err,
> >  };
> >  
> >  static const match_table_t tokens = {
> > @@ -132,6 +132,7 @@ static const match_table_t tokens = {
> >  	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
> >  	{Opt_discard,	"discard"},	/* Discard unused blocks */
> >  	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
> > +	{Opt_reflink,	"reflink"},	/* Do not discard unused blocks */
> 						^^^^
> 
> Also, I believe this comment is wrong!?
> 
> Cheers
> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
