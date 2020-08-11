Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B02C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 19:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109CD20782
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 19:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XA78Qz97"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgHKTyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 15:54:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgHKTyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 15:54:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BJr3Cg141151;
        Tue, 11 Aug 2020 19:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FP0I60WWZo0r5SSoalVoBj2VngaynscKJmAmWeZjat0=;
 b=XA78Qz97MZYhN/EPDBIU4VfUbmx6wZPAEgGWjcUuIHipgd07XKfWfQ5SVHQHwGH9dDVk
 02ZRK1Vx3yTNgPpfya/dqu2OawJfwJT323LJczW6WF5wX3CIAyLakmMZ2jorIfQT4O0h
 AlMjJKZfBVQ7cWU58Zj/cycdgYiv2Y/lpQhCpbmtIguTE0Nx+62dX5k6lRF65jisXTlK
 93IgN6ThVcE6TNqqHb4fRmcHn5mFlyGR1d9iyyShSoqPhzW6W+sJMAdJt/rt2ujfDHz5
 +5WT6RH2yCRPFwEYXv/7wzLkVL4pGO5wLsabRj9yY4FOQvpSVxuFnhorlGEmao6vrO4Z dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32smpnetsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Aug 2020 19:54:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BJrHeA092151;
        Tue, 11 Aug 2020 19:54:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32t5y4uewn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 19:54:47 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07BJskNN014664;
        Tue, 11 Aug 2020 19:54:46 GMT
Received: from localhost (/10.159.237.56)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Aug 2020 19:54:46 +0000
Date:   Tue, 11 Aug 2020 12:54:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: allow setting dax flag on root directory
Message-ID: <20200811195445.GE6107@magnolia>
References: <159716413625.2135493.4789129138005837744.stgit@magnolia>
 <159716415037.2135493.12958426655000840394.stgit@magnolia>
 <3331be1f-87de-074a-65ac-2491a97b3f80@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3331be1f-87de-074a-65ac-2491a97b3f80@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008110140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 11, 2020 at 02:39:01PM -0500, Eric Sandeen wrote:
> On 8/11/20 9:42 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach mkfs to set the DAX flag on the root directory so that all new
> > files can be created in dax mode.  This is a complement to removing the
> > mount option.
> 
> So, a new -d option, "-d dax"
> 
> This is ~analogous to cowextsize, rtinherit, projinherit, and extszinherit
> so there is certainly precedence for this.  (where only rtinherit is a boolean
> like this, but they are all inheritable behaviors)
> 
> (I wonder if "daxinherit" would be more consistent, but won't bikeshed
> that (much))

/me is indifferent either way.  But I guess some day we might want to
have a dax= flag to indicate something like "set the data device
geometry to optimize for DAX?

Nah, I think if we were ever going to do that, we'd have something more
like:

	-d usage=dax
	-d usage=ssd
	-d usage=floopy

Meh.  I'll change it to daxinherit, since that /is/ what it does.

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man8/mkfs.xfs.8 |   11 +++++++++++
> >  mkfs/xfs_mkfs.c     |   14 ++++++++++++++
> >  2 files changed, 25 insertions(+)
> > 
> > 
> > diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> > index 9d762a43011a..4b4fdd86b2f4 100644
> > --- a/man/man8/mkfs.xfs.8
> > +++ b/man/man8/mkfs.xfs.8
> > @@ -394,6 +394,17 @@ All inodes created by
> >  will have this extent size hint applied.
> >  The value must be provided in units of filesystem blocks.
> >  Directories will pass on this hint to newly created children.
> > +.TP
> > +.BI dax= value
> > +All inodes created by
> > +.B mkfs.xfs
> > +will have the DAX flag set.
> > +This means that directories will pass the flag on to newly created files
> 
> let's call this "children" to match the other similar options?
> 
> (because technically it is passed on not only to regular files, right?)

Directories and regular files, though not to other special files.
Maybe we should fix that.

> > +and files will use the DAX IO paths when possible.
> > +This value is either 1 to enable the use or 0 to disable.
> > +By default,
> > +.B mkfs.xfs
> > +will not enable DAX mode.
> >  .RE
> >  .TP
> >  .B \-f
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 2e6cd280e388..33507f6ea21c 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -60,6 +60,7 @@ enum {
> >  	D_PROJINHERIT,
> >  	D_EXTSZINHERIT,
> >  	D_COWEXTSIZE,
> > +	D_DAX,
> >  	D_MAX_OPTS,
> >  };
> >  
> > @@ -254,6 +255,7 @@ static struct opt_params dopts = {
> >  		[D_PROJINHERIT] = "projinherit",
> >  		[D_EXTSZINHERIT] = "extszinherit",
> >  		[D_COWEXTSIZE] = "cowextsize",
> > +		[D_DAX] = "dax",
> >  	},
> >  	.subopt_params = {
> >  		{ .index = D_AGCOUNT,
> > @@ -369,6 +371,12 @@ static struct opt_params dopts = {
> >  		  .maxval = UINT_MAX,
> >  		  .defaultval = SUBOPT_NEEDS_VAL,
> >  		},
> > +		{ .index = D_DAX,
> > +		  .conflicts = { { NULL, LAST_CONFLICT } },
> 
> er....  should we conflict with reflink ....  ?
> 
> > +		  .minval = 0,
> > +		  .maxval = 1,
> > +		  .defaultval = 1,
> 
> Hm, interesting that this is a little different from rtinherit:
> 
>                 { .index = D_RTINHERIT,
>                   .conflicts = { { NULL, LAST_CONFLICT } },
>                   .minval = 1,
>                   .maxval = 1,
>                   .defaultval = 1,
>                 },
> 
> I think this means that:
> 
> -d rtinherit
> -d rtinherit=1
> 
> are valid, but
> 
> -d rtinherit=0 is not, but
> 
> -d dax
> -d dax=1
> -d dax=0
> 
> are all valid?

TBH, I find it a little odd that you *can't* say "-d rtinherit=0" from a
completeness perspective, but...

> While the latter makes a bit more sense, I wonder if we should stay
> consistent w/ the rtinherit semantics.  Or do you envision some sort
> of automatic enabling of this based on device typethat we'd need to
> override in the future?

...the goal is to set this automatically once distros start shipping a
libblkid that has blkid_topology_get_dax().  At that point we'll
probably want a way to force it off.

Unless we want the ability to specify -ddax=0 the magic seekrit hook to
discover if (future) mkfs actually supports dax autodetection?  Hmm,
that alone sounds like sufficient justification.  Ok.

--D

> 
> > +		},
> >  	},
> >  };
> >  
> > @@ -1434,6 +1442,12 @@ data_opts_parser(
> >  		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
> >  		cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
> >  		break;
> > +	case D_DAX:
> > +		if (getnum(value, opts, subopt))
> > +			cli->fsx.fsx_xflags |= FS_XFLAG_DAX;
> > +		else
> > +			cli->fsx.fsx_xflags &= ~FS_XFLAG_DAX;
> > +		break;
> >  	default:
> >  		return -EINVAL;
> >  	}
> > 
