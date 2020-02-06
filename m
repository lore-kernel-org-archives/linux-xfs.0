Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B14C35247
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 23:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64DAA214AF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 23:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vPe6jNK/";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F1qJRWxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgBFXHi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 18:07:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgBFXHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 18:07:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016N4Uth176396;
        Thu, 6 Feb 2020 23:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RK6RpRqjucm2pjs4voGfBUrIPmvFnYFOde/7aj5v5bw=;
 b=vPe6jNK/1lG6j1uVyCox86uQFgCw9gfpT10lis6F/GdxrnB9sVHa7/TSkoJK3ir91cVd
 9rEskoqXeDxkx7gcbnf2BTo6xIzKlVKCMQ6Sd3FoL32lgvCdsWARljFKMGxO3i9CBceV
 1RzQ5CMSV7iZY8F6ZV8DCIfawWEMswAAB2CyurCPuMUDud8AyCzASgu0Iu/hB6NxPsFD
 LWa1TCtY2RLnNJzHtUd0IFFQR/0XFjfouaOIeryq8Sv43zmmtciNP1pmaHT4x59Zs83d
 eH++qkemcbK+edSDQgiFTK1LIzRf/UOUX/aDJvYcXHjDLc125ASusf3sSKu5AfJDWTv9 Ng== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RK6RpRqjucm2pjs4voGfBUrIPmvFnYFOde/7aj5v5bw=;
 b=F1qJRWxS8u0OVVg2+fQAy07GrgoAN65IInjzSlhevoTI2837dsUvhB1iFSVoZI8HUlNN
 cRzLKJ5BimTWGRMuG75Yo7l4X9UfUoAaG6X2m3Iutq33MinSaVyFi/jVNnCSw3RL5oFY
 l4TdYQyGrup5t7XX7+xObomhAFM28PpRY+au/ix228JVoTU2XJz6gMrsTur/B/H5KMD4
 rMGcW8y1vTC5kobnmPV7RxJttD4y7DM83kOotFq3M4OaCR66Fnrx4q2XLFfFOOJjY/SD
 zGThkaXrVpZlr4k2Fdm3FeAY0C23Y+4rJXIS2Idp4LLwq3253BkrijI9B9kW4Hy41Qdd AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xykbpcvfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 23:07:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016N4Rve079244;
        Thu, 6 Feb 2020 23:07:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2y0jfyvmtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 23:07:33 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 016N7XXe017064;
        Thu, 6 Feb 2020 23:07:33 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 15:07:32 -0800
Date:   Thu, 6 Feb 2020 15:07:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: xchk_xattr_listent() fix context->seen_enough to
 -ECANCELED
Message-ID: <20200206230731.GH6870@magnolia>
References: <20200205190455.1834330-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205190455.1834330-1-billodo@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 05, 2020 at 01:04:55PM -0600, Bill O'Donnell wrote:
> Commit e7ee96dfb8c (xfs: remove all *_ITER_ABORT values)
> replaced *_ITER_ABORT values with -ECANCELED. The replacement
> in the case of scrub/attr.c xchk_xattr_listent() is in
> error (context->seen_enough = 1;). Instead of '1', use
> the intended -ECANCELED.
> 
> Fixes: e7ee96dfb8c (xfs: remove all *_ITER_ABORT values)
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/scrub/attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd444b80..5d0590f78973 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -171,7 +171,7 @@ xchk_xattr_listent(
>  					     args.blkno);
>  fail_xref:
>  	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> -		context->seen_enough = 1;

Hmm.  The attr list functions do:

	if (context->seen_enough)
		break;

to stop iteration of the attributes.  Any nonzero value will work,
positive or negative.  Further down in the scrub/attr.c, xchk_xattr
does:

	/* Did our listent function try to return any errors? */
	if (sx.context.seen_enough < 0)
		error = sx.context.seen_enough;

Which means that if seen_enough is set to a negative value, we'll return
that negative value all the way back to userspace, which means that the
userspace buffer is not updated and xfs_scrub will think there was a
runtime error.

> +		context->seen_enough = -ECANCELED;

So this will cause xfs_scrub to abort with "Operation Canceled" if it
found a corruption error.  The patch I sent to the list had -ECANCELED,
but then I noticed the scrub breakage and changed it to 1 before
committing.  Other parts of the attr code use 1 to stop an attr walk
without returning errors to userspace.

Perhaps it's time to replace that novel use of "1" (and audit all the
branching and whatnot) with -ECANCELED so that we can go on cargoculting
negative int errors in peace.

(*UGH* I remembered that I was the one who applied negative int error
semantics to seen_enough in the first place; before that, its meaning
was purely boolean.  It's still screaming for a cleanup though...)

--D

>  	return;
>  }
>  
> -- 
> 2.24.1
> 
