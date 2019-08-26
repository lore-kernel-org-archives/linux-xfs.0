Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB61C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30BE921872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZwK4e164"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbfHZTeI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 15:34:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729201AbfHZTeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 15:34:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QJSm4w109310;
        Mon, 26 Aug 2019 19:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JLpkAINg8b+AUSZR2zJ2hS8JFqUHaHv2ZXh+AX8kdmE=;
 b=ZwK4e164Q5NwJxHUsS8liBDFZTZWo/NtjRZCeYWvCxJ040DTJue+7fI7auwEpk9aOequ
 RRxtNGR2NbRwcNgrSxLeK1Slq4vbVeiH1umXvrq7lbIYuVOdqydhhfGfYGah4jyinILE
 BfzLzDpBOKuj3L9McRMCm19QP/eZ5neP2YzhoydjZkmxwrmNZrNPRVTeEoxFsSoLMIRD
 8JuLMDUAel3EWnju5fyJbDjbZLUFLBltTCxj/lg0SaZdulZmloRlu0ksNgPi/CCMypqf
 E6iaX3EOsMaq2RxTLq+xxzSP+odu2M5ufABKwYIH6H4bnBUPrq4+aQmIOjFJJseD1teY aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ujw703p79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 19:33:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QJXQBi097522;
        Mon, 26 Aug 2019 19:33:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2umj1tdvsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 19:33:57 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QJXuPK013251;
        Mon, 26 Aug 2019 19:33:56 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 12:33:56 -0700
Date:   Mon, 26 Aug 2019 12:33:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 00/15] xfs: mount API patch series
Message-ID: <20190826193354.GU1037350@magnolia>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652158924.2607.14608448087216437699.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:59:16AM +0800, Ian Kent wrote:
> This patch series adds support to xfs for the new kernel mount API
> as described in the LWN article at https://lwn.net/Articles/780267/.
> 
> In the article there's a lengthy description of the reasons for
> adopting the API and problems expected to be resolved by using it.
> 
> The series has been applied to the repository located at
> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git, and built, and
> the xfstests suite run against it.
> 
> I didn't see any failures that look like they are related to mounting.

I don't think there are any xfstests that test mount option parsing in
anger.

--D

> Changes from the initial posting of the series:
> - changed .name to uppercase in fs_parameter_description to ensure
>   consistent error log messages between the vfs parser and the xfs
>   parameter parser.
> - clearify comment above xfs_parse_param() about when possibly
>   allocated mp->m_logname or mp->m_rtname are freed.
> - factor out xfs_remount_rw() and xfs_remount_ro() from  xfs_remount().
> - changed xfs_mount_alloc() to not set super block in xfs_mount so it
>   can be re-used when switching to the mount-api.
> - fixed don't check for NULL when calling kfree() in xfs_fc_free().
> - refactored xfs_parseargs() in an attempt to highlight the code
>   that actually changes in converting to use the new mount api.
> - dropped xfs-mount-api-rename-xfs_fill_super.patch, it didn't seem
>   necessary.
> - move comment about remount difficulties above xfs_reconfigure()
>   and increase line length to try and make the comment managable.
> - add patch vfs-Create-fs_context-aware-mount_bdev-replacement.patch
>   that adds the vfs_get_block_super() needed by the series.
> 
> The patch "vfs: Create fs_context-aware mount_bdev() replacement" is
> currently included in linux-next so there will be conflicts if this
> series is merged in the next merge window so please be aware of it.
> 
> ---
> 
> David Howells (1):
>       vfs: Create fs_context-aware mount_bdev() replacement
> 
> Ian Kent (14):
>       xfs: mount-api - add fs parameter description
>       xfs: mount-api - refactor suffix_kstrtoint()
>       xfs: mount-api - refactor xfs_parseags()
>       xfs: mount-api - make xfs_parse_param() take context .parse_param() args
>       xfs: mount-api - move xfs_parseargs() validation to a helper
>       xfs: mount-api - refactor xfs_fs_fill_super()
>       xfs: mount-api - add xfs_get_tree()
>       xfs: mount-api - add xfs_remount_rw() helper
>       xfs: mount-api - add xfs_remount_ro() helper
>       xfs: mount api - add xfs_reconfigure()
>       xfs: mount-api - add xfs_fc_free()
>       xfs: mount-api - dont set sb in xfs_mount_alloc()
>       xfs: mount-api - switch to new mount-api
>       xfs: mount-api - remove legacy mount functions
> 
> 
>  fs/fs_context.c            |    2 
>  fs/super.c                 |  111 +++++
>  fs/xfs/xfs_super.c         |  949 ++++++++++++++++++++++++--------------------
>  include/linux/fs_context.h |    9 
>  4 files changed, 631 insertions(+), 440 deletions(-)
> 
> --
> Ian
