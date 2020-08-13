Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A16FC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 13:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 260EC20791
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 13:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bheZMrl0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgHMNx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 09:53:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60354 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgHMNx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 09:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597326837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CeLhH49YC+n2DWDZKUqrOrwZzcgte+3NhS2OL/Bltww=;
        b=bheZMrl0RBg/UYZ4pGWiFFivBxeCsT20ypY+MYxWBeO4Bc+RbElVMdyOFWvNFQl2I63s1T
        uQvv8FiKFJCyYRjc+A85XYJFu6kwkM7/H2Av0ByTUpWL+dJtr0QQ6+m3KjaLlzVHs/C6oW
        +H8WQewHFzrJuvbO0bW9jRLdeQn6y3Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-qCRVtFVANISmTaiwfMEMow-1; Thu, 13 Aug 2020 09:53:55 -0400
X-MC-Unique: qCRVtFVANISmTaiwfMEMow-1
Received: by mail-pl1-f200.google.com with SMTP id b11so3906576plx.21
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 06:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CeLhH49YC+n2DWDZKUqrOrwZzcgte+3NhS2OL/Bltww=;
        b=EEYoe5POAoP8vOzGAolw5mLhVc1yy7zT6rUDAAe85ddwBjEHqX5spuXNy5NJPxTjCN
         pINLpJF4VHfmHJJk5kOOxpuxcX6T3xxiXeB1dnclAejc2zkPrwZe2j13fX8Xr5HSaEs0
         TMjkHjO48We8LrVKDzGGfwJTgVSEtTVttvphTxLNjkMy5N6X/MRvfnWjdfuPTg2RnZ88
         Bq/5EEGj3wuamb3t6y02Ecvd1tE7x8ZiIuNt/8Usbcb0snKgIuUzfL/OtotDa8WOIEEG
         6rn7/AbM3zFxXF1m7hNl7gBO61hwFS1bmctSkpCtoidNcGGYkKEF651+3xBlQ6nmBC4Y
         LAsg==
X-Gm-Message-State: AOAM532B8dtTg3KRnu8tWfhO8m09PSAt/bcojBM0WCr+YJtr70JWYxYK
        bokkc7YXebjPwACwKGSL0Pt+RXW+GPABtPjbbXrkMfmHL5Sarrp9mbwNIRx3HCDdk7kj5K4NppS
        6F+q+OSZqz1ZVIAk8d802
X-Received: by 2002:a17:902:246:: with SMTP id 64mr4000141plc.70.1597326834538;
        Thu, 13 Aug 2020 06:53:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGtIUuZzkSz4q0UIU6z8rxYKEjjvQSaIntZNK2wjPPugjMYHrE1Y/bk4ZJbbiYPgtLDmJ2rQ==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr4000127plc.70.1597326834275;
        Thu, 13 Aug 2020 06:53:54 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s8sm6510621pfc.122.2020.08.13.06.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 06:53:53 -0700 (PDT)
Date:   Thu, 13 Aug 2020 21:53:45 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: use correct inode to set inode type
Message-ID: <20200813135345.GA3176@xiangao.remote.csb>
References: <20200813060324.8159-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813060324.8159-1-zlang@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Thu, Aug 13, 2020 at 02:03:24PM +0800, Zorro Lang wrote:
> A test fails as:
>   # xfs_db -c "inode 133" -c "addr" -c "p core.size" -c "type inode" -c "addr" -c "p core.size" /dev/sdb1
>   current
>           byte offset 68096, length 512
>           buffer block 128 (fsbno 16), 32 bbs
>           inode 133, dir inode -1, type inode
>   core.size = 123142
>   current
>           byte offset 65536, length 512
>           buffer block 128 (fsbno 16), 32 bbs
>           inode 128, dir inode 128, type inode
>   core.size = 42
> 
> The "type inode" get wrong inode addr due to it trys to get the
> beginning of an inode chunk, refer to "533d1d229 xfs_db: properly set
> inode type".

From the kernel side, the prefered way is
commit id ("subject")

> 
> We don't need to get the beginning of a chunk in set_iocur_type, due
> to set_cur_inode(ino) will help to do all of that and make a proper
> verification. We just need to give it a correct inode.
> 
> Reported-by: Jianhong Yin <jiyin@redhat.com>
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  db/io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 6628d061..61940a07 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -591,6 +591,7 @@ set_iocur_type(
>  	/* Inodes are special; verifier checks all inodes in the chunk */
>  	if (type->typnm == TYP_INODE) {
>  		xfs_daddr_t	b = iocur_top->bb;
> +		int		bo = iocur_top->boff;
>  		xfs_ino_t	ino;
>  
>  		/*
> @@ -598,7 +599,7 @@ set_iocur_type(
>   		 * which contains the current disk location; daddr may change.
>   		 */
>  		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> -			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> +			(((b << BBSHIFT) + bo) >> mp->m_sb.sb_inodelog) %
>  			XFS_AGB_TO_AGINO(mp, mp->m_sb.sb_agblocks));
>  		set_cur_inode(ino);
>  		return;

Not familar with such code, but after looking into a bit, (my premature
thought is that) I'm wondering if we need to reverify original buffer in

if (type->fields) {
	...
	set_cur()
}

iocur_top->typ = type;

/* verify the buffer if the type has one. */
...

since set_cur() already verified the buffer in
set_cur->libxfs_buf_read->...->libxfs_readbuf_verify?

Not related to this patchset but I'm a bit curious about it now...

Thanks,
Gao Xiang

> -- 
> 2.20.1
> 

