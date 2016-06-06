Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 673DD7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 11:52:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 18D478F8040
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 09:52:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id F0HkBosj8xszouCG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 09:52:40 -0700 (PDT)
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id u56GqdeB001814
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 6 Jun 2016 16:52:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u56GqcCW000435
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 6 Jun 2016 16:52:39 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u56GqcgJ023900
	for <xfs@oss.sgi.com>; Mon, 6 Jun 2016 16:52:38 GMT
Date: Mon, 6 Jun 2016 09:52:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: add an option to enable reflinks at mount time
Message-ID: <20160606165236.GB5737@birch.djwong.org>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<1464877150-20457-4-git-send-email-hch@lst.de>
	<20160606112342.GB23695@redhat.com>
	<20160606112950.GC23695@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160606112950.GC23695@redhat.com>
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

On Mon, Jun 06, 2016 at 01:29:50PM +0200, Carlos Maiolino wrote:
> Ugh, I just realized dave and derrick had already replied, pointing issues I
> didn't figure out, but still I'm curious for the question I asked :)
> 
> > Hi hch,
> > 
> > The patchset looks good, although I'm not quite familiar with the reflink code
> > so, I apologize if it is a stupid question
> > 
> > After enabling the reflink feature during mount time, I believe this will not
> > have any problems in future mounts of this filesystem without reflink support?
> > 
> > > index 84348af..dfa5077 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -82,7 +82,7 @@ enum {
> > >  	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
> > >  	Opt_uquota, Opt_gquota, Opt_pquota,
> > >  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> > > -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
> > > +	Opt_discard, Opt_nodiscard, Opt_reflink, Opt_dax, Opt_err,
> > >  };
> > >  
> > >  static const match_table_t tokens = {
> > > @@ -132,6 +132,7 @@ static const match_table_t tokens = {
> > >  	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
> > >  	{Opt_discard,	"discard"},	/* Discard unused blocks */
> > >  	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
> > > +	{Opt_reflink,	"reflink"},	/* Do not discard unused blocks */
> > 						^^^^

I hadn't noticed the incorrect comment; it's good of you to point it out. :)

--D

> > 
> > Also, I believe this comment is wrong!?
> > 
> > Cheers
> > 
> > -- 
> > Carlos
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
