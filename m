Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9302ACA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 18:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 640EC21734
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 18:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dua4KEpM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfKASkY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 14:40:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfKASkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 14:40:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1IdT5C158889;
        Fri, 1 Nov 2019 18:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eZOZS9qHxrnIZSmtA5AL8kda5BDCu5KAYvGcPJjB+0Y=;
 b=dua4KEpMJG09htascadCMuF0yEapfW2qZIMY+l1P6UWb15DtIkFanLVYwxCesbk9Q/r2
 WTjil5A4Mb4s7wD22zThkDMadcFLuUW/4EgWhliwUaKsrJEKiWJ5dO/XgZR3tSGs0UsM
 Du1rlqa0k9R+RmdkufjvjOtPzxVW1uaS9m31KM+0EcVZ2eUHNg9PddDJv/JlUDeddm1W
 bHRsu6DVmJ6YATMCSnEKexJsSHZVAcfnf3Jwq1+waWAFKWJQTP8QqcIszXk76NY/fJKt
 F5FMfM352BL/q2QoOCslU2sqWOpp+oEI2OnerNHU3d/+8du8+7ve1JpA9G8S4N+R1Cow tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vxwhfuhb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 18:40:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1IdM1F034038;
        Fri, 1 Nov 2019 18:40:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w0rurpvqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 18:40:19 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA1IeH4J031507;
        Fri, 1 Nov 2019 18:40:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 11:40:17 -0700
Date:   Fri, 1 Nov 2019 11:40:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_spaceman: always report sick metadata, checked
 or not
Message-ID: <20191101184010.GY15222@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
 <157176999737.1458930.11352482066082675215.stgit@magnolia>
 <877be5a9-d19c-cecf-10d7-e4ea3626d0f5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877be5a9-d19c-cecf-10d7-e4ea3626d0f5@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 01:17:11PM -0500, Eric Sandeen wrote:
> On 10/22/19 1:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If the kernel thinks a piece of metadata is bad, we must always report
> > it.  This will happen with an upcoming series to mark things sick
> > whenever we return EFSCORRUPTED at runtime.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I gotta say, I find this all really hard to read - something I should
> have commented on earlier.  Masks, maps, and functions oh my.  bad and
> sick and checked ... reported++ with no actual reporting ....

Hm, yeah, the "reported" variable here counts the number of things the
kernel reported to us as having been checked or marked sick at some point.
The whole point of that is that if the kernel hasn't marked anything
checked or sick then we really can't say much about the state of the
filesystem and maybe the user should run xfs_scrub.

> I'll try to think about what would make my poor brain happier later.
> Comments, for one I think.  Maybe some bikeshedding over variable names.
> 
> I guess the upshot here is that if it's marked sick due to the kernel
> sumbling over corruption, report it whether or not we ever explicitly
> /asked/ for a check via the scrub interfaces?

Correct.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  spaceman/health.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/spaceman/health.c b/spaceman/health.c
> > index 8fd985a2..0d3aa243 100644
> > --- a/spaceman/health.c
> > +++ b/spaceman/health.c
> > @@ -171,10 +171,10 @@ report_sick(
> >  	for (f = maps; f->mask != 0; f++) {
> >  		if (f->has_fn && !f->has_fn(&file->xfd.fsgeom))
> >  			continue;
> > -		if (!(checked & f->mask))
> > +		bad = sick & f->mask;
> > +		if (!bad && !(checked & f->mask))
> >  			continue;
> >  		reported++;
> > -		bad = sick & f->mask;
> >  		if (!bad && quiet)
> >  			continue;
> >  		printf("%s %s: %s\n", descr, _(f->descr),
> > 
