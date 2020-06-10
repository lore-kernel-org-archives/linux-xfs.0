Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD25C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 16:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F2E206F4
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 16:02:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qjlnAs5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgFJQCg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 12:02:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgFJQCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 12:02:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05AFrALr137192;
        Wed, 10 Jun 2020 16:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=htFnvm7oZfEBFI2RT2kk9kJaL2tOurokob7gJHUjLTY=;
 b=qjlnAs5MIAKsCSYKAomMF7EYn+57OENAtDn7fVUmXlkECWm8LCYDNZjZfP/SL4zpkHQo
 uxgrCv7Suar4nv/V6nfTeoe6vA+FNrcWVdIaA7E7oI0VZsiVQ3jBIJ0QDqePMScY4AID
 28rJrMWx3ds5rXmKVy8LqpJ4U7tzzy0yTSotnRTX6ypzFpyPiTNZpyo6m54EZXvb0Ks2
 fA6J12Qyg5O0ZJeYjHV35OJtfchVVo+bw91zKwaiX6XpgSIaAqAxnPWZMHAvWVV5ddcX
 GiWqM83IkiM6wDcx1VOqhSLEbnZVEDSCZj3s+frmKEvpaYh0KPlQ7Rps5N3af1rjpm5u rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31jepnw43m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 16:02:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05AFvkEa090579;
        Wed, 10 Jun 2020 16:02:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31gn2yqdq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 16:02:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05AG2PqW012637;
        Wed, 10 Jun 2020 16:02:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jun 2020 09:02:24 -0700
Date:   Wed, 10 Jun 2020 09:02:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_copy: flush target devices before exiting
Message-ID: <20200610160223.GF11245@magnolia>
References: <20200608184757.GL1334206@magnolia>
 <1397005d-04a7-0a06-0549-7633da125ba0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397005d-04a7-0a06-0549-7633da125ba0@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 cotscore=-2147483648 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006100120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 09, 2020 at 11:31:52PM -0500, Eric Sandeen wrote:
> 
> On 6/8/20 1:47 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Flush the devices we're copying to before exiting, so that we can report
> > any write errors.
> 
> Hm, I hadn't really looked at xfs_copy in depth, funky stuff.
> 
> So normally errors look something like:
> 
> THE FOLLOWING COPIES FAILED TO COMPLETE
>     $TARGET -- write error at offset ABC
>     $TARGET -- seek error at offset XYZ
> 
> if for some reason we didn't detect any errors until this final
> device flush, we'll only see:
> 
>     $TARGET -- flush error -Q
> 
> and no header...
> 
> Seems like this error needs to be integrated w/ the other error reporting,
> something like:
> 
> check_errors(void)
> {
>         int     i, flush_error, first_error = 0;
> 
>         for (i = 0; i < num_targets; i++)  {
>                 flush_error = platform_flush_device(target[i].fd, 0);

<shrug> I was gonna skip the flush error if the target already died,
but yeah I agree this should come before THE FOLLOWING COPIES WERE EATEN
BY CIRCUMSTANCE.

--D

> 
>                 if (flush_error || target[i].state == INACTIVE)  {
>                         if (first_error == 0)  {
>                                 first_error++;
>                                 do_log(
>                                 _("THE FOLLOWING COPIES FAILED TO COMPLETE\n"));
>                         }
>                         if (target[i].state == INACTIVE) {
>                                 do_log("    %s -- ", target[i].name);
>                                 if (target[i].err_type == 0)
>                                         do_log(_("write error"));
>                                 else
>                                         do_log(_("lseek error"));
>                                 do_log(_(" at offset %lld\n"), target[i].position);
>                         }
>                         if (flush_error)
>                                 do_log(_("    %s -- flush error %d"),
>                                                 target[i].name, errno);
>                 }
>         }
>         if (first_error == 0)  {
>                 fprintf(stdout, _("All copies completed.\n"));
>                 fflush(NULL);
>         } else  {
>                 fprintf(stderr, _("See \"%s\" for more details.\n"),
>                         logfile_name);
>                 exit(1);
>         }
> }
> 
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  copy/xfs_copy.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> > index 2d087f71..7657ad3e 100644
> > --- a/copy/xfs_copy.c
> > +++ b/copy/xfs_copy.c
> > @@ -12,6 +12,7 @@
> >  #include <stdarg.h>
> >  #include "xfs_copy.h"
> >  #include "libxlog.h"
> > +#include "libfrog/platform.h"
> >  
> >  #define	rounddown(x, y)	(((x)/(y))*(y))
> >  #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
> > @@ -150,6 +151,10 @@ check_errors(void)
> >  			else
> >  				do_log(_("lseek error"));
> >  			do_log(_(" at offset %lld\n"), target[i].position);
> > +		} else if (platform_flush_device(target[i].fd, 0)) {
> > +			do_log(_("    %s -- flush error %d"),
> > +					target[i].name, errno);
> > +			first_error++;
> >  		}
> >  	}
> >  	if (first_error == 0)  {
> > 
