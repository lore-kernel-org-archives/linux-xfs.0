Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C527C636CC
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Feb 2023 04:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjBKEnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Feb 2023 23:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKEnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Feb 2023 23:43:00 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70D12D57;
        Fri, 10 Feb 2023 20:42:58 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PDHyh2W51zdb9s;
        Sat, 11 Feb 2023 12:42:36 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sat, 11 Feb
 2023 12:42:56 +0800
Date:   Sat, 11 Feb 2023 13:06:41 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, <yang.yang29@zte.com.cn>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>
Subject: Re: [PATCH linux-next] xfs: use strscpy() to instead of strncpy()
Message-ID: <20230211050641.GA2118932@ceph-admin>
References: <202301091940437129873@zte.com.cn>
 <Y9sKXhxvf0DDusih@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y9sKXhxvf0DDusih@magnolia>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 04:57:02PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 09, 2023 at 07:40:43PM +0800, yang.yang29@zte.com.cn wrote:
> > From: Xu Panda <xu.panda@zte.com.cn>
> > 
> > The implementation of strscpy() is more robust and safer.
> > That's now the recommended way to copy NUL-terminated strings.
> > 
> > Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> > Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
> 
> Looks fine,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_xattr.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index 10aa1fd39d2b..913c1794bc2f 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -212,9 +212,7 @@ __xfs_xattr_put_listent(
> >  	offset = context->buffer + context->count;
> >  	memcpy(offset, prefix, prefix_len);
> >  	offset += prefix_len;
> > -	strncpy(offset, (char *)name, namelen);			/* real name */
> > -	offset += namelen;
> > -	*offset = '\0';
> > +	strscpy(offset, (char *)name, namelen + 1);			/* real name */

The name is not null terminated, it will result slab-out-of-bounds in strscpy().

[1] https://lore.kernel.org/linux-xfs/00000000000065a46a05f4529f59@google.com/T/#u

> > 
> >  compute_size:
> >  	context->count += prefix_len + namelen + 1;
> > -- 
> > 2.15.2
