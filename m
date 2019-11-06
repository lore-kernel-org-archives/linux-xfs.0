Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F931C5DF65
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 20:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BEAA217F4
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 20:22:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iM6C6k2w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKFUWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 15:22:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35488 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfKFUWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 15:22:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6KJ8Uk130791;
        Wed, 6 Nov 2019 20:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=66Dhrc+PT2KofsmP2GONJ4fHuX4pfwzed1Gh3ti6laA=;
 b=iM6C6k2w3986f8PTaBXTyP1ZYO0akfysGUhTEFodwzNH40f+2DtTPFdLetwqZjqvUXZZ
 ocqpxQAVthi5qcqTLbkE30bffIf49OcnGuS0ThjJVQSayQm/3O7JBc17YXCPrKYqSi28
 zvNlyAk0V5quFLD1tKqYdifsVJDJ3pRNTcanbCfLqmhhNJoZOLtcAHMLSwSKgcTzhBGw
 XYPKTnjTp72JTfarUTMEg/By7ekgpt1yWO2zGkY+81eAz/mXpgEiyR6XEAUl+GAjHKwo
 AGF3FmrpBr0AV7WS/eI2YNdVOsCtwLFaW14tNLdwwnr1SxHgCS9/VYb+fj6N5lq3L2jf wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w0sfch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 20:22:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6KJWww183139;
        Wed, 6 Nov 2019 20:22:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w41wfceq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 20:22:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6KM8b2030247;
        Wed, 6 Nov 2019 20:22:09 GMT
Received: from localhost (/10.159.234.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 12:22:08 -0800
Date:   Wed, 6 Nov 2019 12:22:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/3] xfs_scrub: perform media scans of entire devices
Message-ID: <20191106202207.GO4153244@magnolia>
References: <157177019803.1460684.3524666107607426492.stgit@magnolia>
 <157177021069.1460684.13385243350591362467.stgit@magnolia>
 <9c620b96-fef4-9b30-db78-f6c091d6adac@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c620b96-fef4-9b30-db78-f6c091d6adac@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060200
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 02:15:43PM -0600, Eric Sandeen wrote:
> On 10/22/19 1:50 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new feature to xfs_scrub where specifying multiple -x will cause
> > it to perform a media scan of the entire disk, not just the file data
> > areas.
> 
> Hm.... convince me why this is useful?  It's likely that any such block
> will get remapped when it's used anyway, right?  What does this help?

It's really only useful as a general media scan, which anyone can do
with ddrescue.  It could potentially be useful if storage reverts to the
old days where writes don't actually remap (flooppies!)....

...eh, let's drop this and the next patch.  I don't even think pmem
behaves like that.

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  man/man8/xfs_scrub.8 |    3 +++
> >  scrub/phase6.c       |   60 ++++++++++++++++++++++++++++++++++++++++++++++----
> >  scrub/phase7.c       |    5 ++++
> >  scrub/xfs_scrub.c    |    4 ++-
> >  scrub/xfs_scrub.h    |    1 +
> >  5 files changed, 66 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
> > index e881ae76..2cdec380 100644
> > --- a/man/man8/xfs_scrub.8
> > +++ b/man/man8/xfs_scrub.8
> > @@ -97,6 +97,9 @@ Prints the version number and exits.
> >  .TP
> >  .B \-x
> >  Read all file data extents to look for disk errors.
> > +If this option is given more than once, scrub all disk contents.
> 
> This addition doesn't really make clear what -xx does, IMHO.  Something
> more explicit like "look for errors even in freespace?"

Yeah.

> > +If this option is given more than twice, report errors even if they have not
> > +yet caused data loss.
> 
> sooo w/ -xx it'll read freespace but not report errors, with -xxx it will?

The same as -xx.

--D

> 
> -Eric
