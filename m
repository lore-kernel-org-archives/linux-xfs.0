Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89413CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 563472086D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ek+oD9vf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfKAUQA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 16:16:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39850 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfKAUP7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 16:15:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KE63X026124;
        Fri, 1 Nov 2019 20:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ey3n/Lfc72J620e6b4JmgT1pGID7EZqGPbCwZb0AFls=;
 b=Ek+oD9vfkfPZ+0yDkQxwdTxaYKPqiawg9LPaGynK4SBpfYXT44XD+nRvxL4E5hwgcN95
 43Rm/bjpjX0YdjpvMlZP9ylkhsLAm3g/HXujFmJoCNYsxjt9hdI/6jSv0GM+fNEh17rF
 hA8zHSXt91Jpc/38BE8OkXdFYA89Aa4e350nujwhd3IbjQL4ccvMxK0mSCc2L/wZ5f6e
 u7oiw9EgvMmwDmyfgEJX2Zdb3+zW6uiTV+XztK8IMAZ/kvGL2a6PpmFVjNc0mUxPTs19
 CLkFPIj2oXczW5XDrUoM2dwh3VidvxkZ9mLZwYbCmI5/+RRRihKcb125AJTsNGMB/lST EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vxwhg3vv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:15:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KE4Sf056961;
        Fri, 1 Nov 2019 20:15:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w0rurwu8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:15:38 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1KFbhf029974;
        Fri, 1 Nov 2019 20:15:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 13:15:37 -0700
Date:   Fri, 1 Nov 2019 13:15:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 12/16] xfs: dont set sb in xfs_mount_alloc()
Message-ID: <20191101201536.GG15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259466607.28278.4456308072088112584.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259466607.28278.4456308072088112584.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:51:06PM +0800, Ian Kent wrote:
> When changing to use the new mount api the super block won't be
> available when the xfs_mount struct is allocated so move setting the
> super block in xfs_mount to xfs_fs_fill_super().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_super.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4b570ba3456a..62dfc678c415 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1560,8 +1560,7 @@ xfs_destroy_percpu_counters(
>  }
>  
>  static struct xfs_mount *
> -xfs_mount_alloc(
> -	struct super_block	*sb)
> +xfs_mount_alloc(void)
>  {
>  	struct xfs_mount	*mp;
>  
> @@ -1569,7 +1568,6 @@ xfs_mount_alloc(
>  	if (!mp)
>  		return NULL;
>  
> -	mp->m_super = sb;

Just out of curiosity, is there any place where we need m_super in
between here...

>  	spin_lock_init(&mp->m_sb_lock);
>  	spin_lock_init(&mp->m_agirotor_lock);
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> @@ -1605,9 +1603,10 @@ xfs_fs_fill_super(
>  	 * allocate mp and do all low-level struct initializations before we
>  	 * attach it to the super
>  	 */
> -	mp = xfs_mount_alloc(sb);
> +	mp = xfs_mount_alloc();
>  	if (!mp)
>  		goto out;
> +	mp->m_super = sb;

...and here?  For example, logging errors?  AFAICT the only thing that
goes on between these two points is option parsing, right?  (And the
parsing has its own prefixed logging, etc.)

--D

>  	sb->s_fs_info = mp;
>  
>  	error = xfs_parseargs(mp, (char *)data);
> 
