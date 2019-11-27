Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB11C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34B1206F0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D9Hv2THh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfK0Pl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:41:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfK0Pl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 10:41:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARFdK3B087597;
        Wed, 27 Nov 2019 15:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tITtqrkSGZawSggOK9DCv+skaRXvMed9EyvjmqfMu9s=;
 b=D9Hv2THh8Q4WBFFW3CA08/kXnDVViEoWcrO8LRwGOdv4uhXITiVNr139OgEHBbwCJv3f
 Ls9Xed9VCHTRefUMgYx0V+jnaFMR2pewQ+MOUQDXt6me2q+Os0WqXO47c+zawh03FRKN
 96Skt2CpsLQtJqIRTy6HfXtGwbBjhWs2a/Ce9pIDheSwuoS9/nvfESNFa1VdY99FiCBi
 1L7QBvgj4ie/NoWxv0sJyWR9F3dfOarPyUZZBvdlQRnCtfWre/lr9zvK6d3VkUBpf9MD
 H4gekfepEKVxVASTZpr3QHu6oM15FSwN81g+8t7BJkwtxTK1fuy/DbtO2MBku2uhz7H+ MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wevqqeepq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 15:41:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARFdEhV004579;
        Wed, 27 Nov 2019 15:41:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wh0rjwmx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 15:41:22 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xARFfLUk028249;
        Wed, 27 Nov 2019 15:41:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Nov 2019 07:41:21 -0800
Date:   Wed, 27 Nov 2019 07:41:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/050: fix xfsquota configuration failures
Message-ID: <20191127154120.GS6219@magnolia>
References: <20191127041538.GH6212@magnolia>
 <20191127120641.GC20979@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127120641.GC20979@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 27, 2019 at 01:06:41PM +0100, Jan Kara wrote:
> On Tue 26-11-19 20:15:38, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The new 'xfsquota' configuration for generic/050 doesn't filter out
> > SCRATCH_MNT properly and seems to be missing an error message in the
> > golden output.  Fix both of these problems.
> > 
> > Fixes: e088479871 ("generic/050: Handle xfs quota special case with different output")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Umm, I can see how I messed up the SCRATCH_MNT filtering and didn't notice
> - thanks for fixing that. But the error message should not be there. The
> previous mount completely failed so we end up touching file on the parent
> filesystem which succeeds (well, unless the parent filesystem is read-only
> as well).

Heh, yes, I deliberately make the test dir and scratch mounts readonly
so that mount failures show up as errors.  Usually I catch it, but this
time I saw the previous line and was too hasty.

> So to avoid this obscure behavior, we should add something like
> (untested):
> 
> diff --git a/tests/generic/050 b/tests/generic/050
> index cf2b93814267..593e2e69bf9a 100755
> --- a/tests/generic/050
> +++ b/tests/generic/050
> @@ -59,8 +59,10 @@ blockdev --setro $SCRATCH_DEV
>  #
>  echo "mounting read-only block device:"
>  _try_scratch_mount 2>&1 | _filter_ro_mount
> -echo "touching file on read-only filesystem (should fail)"
> -touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> +if [ "${PIPESTATUS[0]}" -eq 0 ]; then
> +       echo "touching file on read-only filesystem (should fail)"
> +       touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> +fi
> 
> and update xfsquota output accordingly...

Ok.  I'll do that.

--D

> 
> 								Honza
> > @@ -1,8 +1,9 @@
> >  QA output created by 050
> >  setting device read-only
> >  mounting read-only block device:
> > -mount: /mnt-scratch: permission denied
> > +mount: SCRATCH_MNT: permission denied
> >  touching file on read-only filesystem (should fail)
> > +touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
> >  unmounting read-only filesystem
> >  umount: SCRATCH_DEV: not mounted
> >  setting device read-write
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
