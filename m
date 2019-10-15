Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5FCECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8007F2168B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:19:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TZFF3uwH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfJORTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:19:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbfJORTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 13:19:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHInr4073903;
        Tue, 15 Oct 2019 17:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eGI8EByLEQ2A9e15fXPmN4sq9oEedcQ9ZmCEEy0VOuE=;
 b=TZFF3uwHZNG8o8V6KtpCrqSozps61tu3v6nnN/weXTGXMe8oZOMeXVTkvXIqptCVFxnE
 XQfau4K0bI2yiyYN91rBgTamfm2gAB8KQxke8Dihq7S1wfqM1TsUyFC1wdfh1wXpyIsI
 s6qtAnc05VvQov9J+6MzUIHYjySTI7D5CbcgCGo0U8t/5zsqYVmwpQHCutEmGRhX1qCM
 AXfJYn0GoHfkLHhfKEc/DObX6Yuh7Xndvw+YgEDX7fmdfUY/vcfUssy0j+f9ojr05+7p
 /dpR+KhkRWh682HXV22kh2y5UH7N3LZ6CItgJkdu7TTmKgkMSYgRADSSCkOKXv6c4aii wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vk68uhmc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:19:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHINSA172132;
        Tue, 15 Oct 2019 17:19:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vnb0fhs1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:19:48 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9FHJg75011140;
        Tue, 15 Oct 2019 17:19:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 17:19:42 +0000
Date:   Tue, 15 Oct 2019 10:19:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs_scrub: fix handling of read-verify pool
 runtime errors
Message-ID: <20191015171941.GH13108@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
 <156944729476.298887.15638727982082805193.stgit@magnolia>
 <186d9d11-f02e-8c0f-ed85-b73a32ba9670@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <186d9d11-f02e-8c0f-ed85-b73a32ba9670@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 15, 2019 at 12:07:11PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:34 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix some bogosity with how we handle runtime errors in the read verify
> > pool functions.  First of all, memory allocation failures shouldn't be
> > recorded as disk IO errors, they should just complain and abort the
> > phase.  Second, we need to collect any other runtime errors in the IO
> > thread and abort the phase instead of silently ignoring them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/read_verify.c |   23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/scrub/read_verify.c b/scrub/read_verify.c
> > index b890c92f..00627307 100644
> > --- a/scrub/read_verify.c
> > +++ b/scrub/read_verify.c
> > @@ -53,6 +53,7 @@ struct read_verify_pool {
> >  	struct disk		*disk;		/* which disk? */
> >  	read_verify_ioerr_fn_t	ioerr_fn;	/* io error callback */
> >  	size_t			miniosz;	/* minimum io size, bytes */
> > +	int			errors_seen;
> >  };
> 
> I'd like to see a comment that says /* runtime/operational errors */
> to differentiate between verification errors.
> 
> Or maybe even rename it to runtime_errors or something.
> 
> I'm also confused; it's an int, but this patch assigns it with true/false,
> the next patch assigns errnos i.e. ECANCELED, .... what's it supposed to be?

It's a mess. :(

It ought to be an int since that's where we're going anyway.

Will add a comment, change the name, and make the usage consistent
throughout the series.

--D
