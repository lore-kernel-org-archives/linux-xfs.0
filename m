Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E7ACA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 18:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B5F21734
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 18:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WCQP+iv9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfKASmf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 14:42:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfKASme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 14:42:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1IdTjs173553;
        Fri, 1 Nov 2019 18:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=zcW1E3NSDTmBQdvHsvbTgH80eGbGw1EmhO9iV9Tj28w=;
 b=WCQP+iv9y+7wx90ngf+1QvKpCRO0rnuY53/a584H5jxEhQBmgSx/EMU+dD1JRQPJDz0c
 YAwCzXyjM6cgKxApEDWB0sMd29fGkYKl9aLLwzrPEEOYwHEe/ZMaau1FBaTK8FcZH+V1
 BOu/9je5j2yuEJi9R7FOJDiqKr/PVENKBe/YfgHMSs4Pg2HLE2T84WpZM5dQXvvP1HeT
 a/F0IVD5yoniGBGac3ob9anBv9guQVgYp3qLGGRVl+Vbdjrljqut/4at2lfkVP3XCCoz
 7SjRqqabt1QemAYVYQRaLL5ZTN5d9+QP3HlFIrFUHE17oDpMczEWmepSiViVLH/795HT hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vxwhg3f2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 18:42:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1IdFbe190698;
        Fri, 1 Nov 2019 18:42:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vyv9jrq5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 18:42:31 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1IgURf032246;
        Fri, 1 Nov 2019 18:42:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 11:42:30 -0700
Date:   Fri, 1 Nov 2019 11:42:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: report repair activities on stdout, not
 stderr
Message-ID: <20191101184229.GZ15222@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
 <157177001031.1458930.10794386697707805480.stgit@magnolia>
 <ff4b4193-c6e1-130f-7e09-f8bb9790c33a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff4b4193-c6e1-130f-7e09-f8bb9790c33a@sandeen.net>
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

On Fri, Nov 01, 2019 at 01:26:49PM -0500, Eric Sandeen wrote:
> On 10/22/19 1:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Reduce the severity of reports about successful metadata repairs.  We
> > fixed the problem, so there's no action necessary on the part of the
> > system admin.
> 
> Hm, ok.  "we found corruption" seems quite important, but I guess it's
> not an operational error of the utility.  *shrug*

We *fixed* corruption, meaning that the fs is ok now.

If we left corruption behind (either because the user gave us "-n" or
the repair failed) then we still yell about it on stderr.

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/common.c |    2 +-
> >  scrub/common.h |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/scrub/common.c b/scrub/common.c
> > index b41f443d..7632a8d8 100644
> > --- a/scrub/common.c
> > +++ b/scrub/common.c
> > @@ -48,7 +48,7 @@ static struct {
> >  } err_levels[] = {
> >  	[S_ERROR]  = { .string = "Error",	.loglevel = LOG_ERR },
> >  	[S_WARN]   = { .string = "Warning",	.loglevel = LOG_WARNING },
> > -	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_WARNING },
> > +	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_INFO },
> >  	[S_INFO]   = { .string = "Info",	.loglevel = LOG_INFO },
> >  	[S_PREEN]  = { .string = "Optimized",	.loglevel = LOG_INFO }
> 
> My OCD wants this in the same order as error_level, I'll change that
> on commit if it's ok w/ you.  And if I remember.

<nod>

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> >  };
> > diff --git a/scrub/common.h b/scrub/common.h
> > index 9a37e9ed..ef4cf439 100644
> > --- a/scrub/common.h
> > +++ b/scrub/common.h
> > @@ -18,8 +18,8 @@ bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
> >  enum error_level {
> >  	S_ERROR	= 0,
> >  	S_WARN,
> > -	S_REPAIR,
> >  	S_INFO,
> > +	S_REPAIR,
> >  	S_PREEN,
> >  };
> >  
> > 
