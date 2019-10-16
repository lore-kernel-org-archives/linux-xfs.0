Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2075FA372A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D058721A49
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:25:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h5A40Tqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390957AbfJPSZh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:25:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49552 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbfJPSZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 14:25:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIIvQ5128681;
        Wed, 16 Oct 2019 18:25:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CVbrzfRNZNcanxCIRMfNB3CsZ12VZxmQ4m9Q5Az96QY=;
 b=h5A40Tqo+XSWYMXrqJSRQzzMXz2y1YvWqY5Cy2aoAiJ0d3MWBEE7x39Cpm2CsCalyI80
 yWPsIAwlsoX6XGOZDZbIbqZSIBH9lRxGUTTvsm7cZROE8g4OtytS87Ppo78/wcEzci6e
 +Up1yms3ZGwE6jOPLatkPlWUpgTlDWXGXhlxt/GNERm5JzxqKWgPqQZ9E7LbXgqu1auC
 PZoyskaPAWvxA3I1kZiaQZ0gcF7ugCDJw4Dy4GC10/ptoZiI0ugz4RAHflAFw21hscLd
 z3A03Wu0J5fbPkAgxDgJi5EiZ8dtCeuNahXCe11uVEMp3n1N8bxXnYwdYT3OyqJWvSIt MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vk6sqrxpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:25:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIJ82I057453;
        Wed, 16 Oct 2019 18:25:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vp3bhqbhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:25:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9GIPDTd013935;
        Wed, 16 Oct 2019 18:25:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 18:25:13 +0000
Date:   Wed, 16 Oct 2019 11:25:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 02/12] xfs: remove very old mount option
Message-ID: <20191016182512.GB13108@magnolia>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118645272.9678.5887961059070306546.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118645272.9678.5887961059070306546.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:40:52AM +0800, Ian Kent wrote:
> It appears the biosize mount option hasn't been documented as
> a vilid option since 2005.

    ^^^^^ "valid"

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> So remove it.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_super.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8d1df9f8be07..1bb7ede5d75b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -51,7 +51,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>   * Table driven mount option parser.
>   */
>  enum {
> -	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
> +	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
>  	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
>  	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
> @@ -67,7 +67,6 @@ static const match_table_t tokens = {
>  	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
>  	{Opt_logdev,	"logdev=%s"},	/* log device */
>  	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
> -	{Opt_biosize,	"biosize=%u"},	/* log2 of preferred buffered io size */
>  	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount */
>  	{Opt_noalign,	"noalign"},	/* turn off stripe alignment */
>  	{Opt_swalloc,	"swalloc"},	/* turn on stripe width allocation */
> @@ -229,7 +228,6 @@ xfs_parseargs(
>  				return -ENOMEM;
>  			break;
>  		case Opt_allocsize:
> -		case Opt_biosize:
>  			if (suffix_kstrtoint(args, 10, &iosize))
>  				return -EINVAL;
>  			iosizelog = ffs(iosize) - 1;
> 
