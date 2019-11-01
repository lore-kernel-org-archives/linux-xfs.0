Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAECCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CED92086D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bwt8psLk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfKATPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 15:15:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfKATPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 15:15:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JAxVP183514;
        Fri, 1 Nov 2019 19:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=nJigGy93Ofamud4aRT9G0Ivk1HpikSp2FzZ4+Z5GEBQ=;
 b=Bwt8psLkDOrkovgzFTMlZ7boILdxz08S3PR35nsSiNhbgGwN6V+iksPNYMQO40IgKs5z
 3J3HL4/Sfj3Eo/cZBCVYMh2rOu+mDU7bNfjfYLT/Gwqz3zY4qhll0TJcLh8rOzU63xMw
 4sz18F2f+q1LwPOaINXhfut/iqg0IutMwrQ0vm5mll1LsfYXgFBRbouEyzwAqWYK1Qdz
 Rt/IslDjaWB6hkfjfh/xMUPkvCTuFGd7+gua7lj1V52iS9TPeRP9DqVK1Fv+i2MVcl8M
 pNGLlRQOYFVkyCz+ziMADM4zYVRS6kPTqXagAKG1B2+4a6HJGth69zzmN4iOtknr5aR8 uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vxwhfupht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:15:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JD2Ah084229;
        Fri, 1 Nov 2019 19:15:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vyv9jt7yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:15:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1JF9LO011171;
        Fri, 1 Nov 2019 19:15:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 11:44:52 -0700
Date:   Fri, 1 Nov 2019 11:44:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_spaceman: always report sick metadata, checked
 or not
Message-ID: <20191101184451.GA15222@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
 <157176999737.1458930.11352482066082675215.stgit@magnolia>
 <877be5a9-d19c-cecf-10d7-e4ea3626d0f5@sandeen.net>
 <20191101184010.GY15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101184010.GY15222@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 11:40:10AM -0700, Darrick J. Wong wrote:
> On Fri, Nov 01, 2019 at 01:17:11PM -0500, Eric Sandeen wrote:
> > On 10/22/19 1:46 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > If the kernel thinks a piece of metadata is bad, we must always report
> > > it.  This will happen with an upcoming series to mark things sick
> > > whenever we return EFSCORRUPTED at runtime.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > I gotta say, I find this all really hard to read - something I should
> > have commented on earlier.  Masks, maps, and functions oh my.  bad and
> > sick and checked ... reported++ with no actual reporting ....
> 
> Hm, yeah, the "reported" variable here counts the number of things the
> kernel reported to us as having been checked or marked sick at some point.
> The whole point of that is that if the kernel hasn't marked anything
> checked or sick then we really can't say much about the state of the
> filesystem and maybe the user should run xfs_scrub.
> 
> > I'll try to think about what would make my poor brain happier later.
> > Comments, for one I think.  Maybe some bikeshedding over variable names.
> > 
> > I guess the upshot here is that if it's marked sick due to the kernel
> > sumbling over corruption, report it whether or not we ever explicitly
> > /asked/ for a check via the scrub interfaces?
> 
> Correct.

Sigh.  Change that to:

Correct, and soon I will send a kernel series that amends all of our
EFSCORRUPTED returns in libxfs to set the appropriate sick bit.  Then
spaceman will be able to pull reports about past corruption that were
found in the course of normal operations.

--D

> 
> --D
> 
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > > ---
> > >  spaceman/health.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/spaceman/health.c b/spaceman/health.c
> > > index 8fd985a2..0d3aa243 100644
> > > --- a/spaceman/health.c
> > > +++ b/spaceman/health.c
> > > @@ -171,10 +171,10 @@ report_sick(
> > >  	for (f = maps; f->mask != 0; f++) {
> > >  		if (f->has_fn && !f->has_fn(&file->xfd.fsgeom))
> > >  			continue;
> > > -		if (!(checked & f->mask))
> > > +		bad = sick & f->mask;
> > > +		if (!bad && !(checked & f->mask))
> > >  			continue;
> > >  		reported++;
> > > -		bad = sick & f->mask;
> > >  		if (!bad && quiet)
> > >  			continue;
> > >  		printf("%s %s: %s\n", descr, _(f->descr),
> > > 
