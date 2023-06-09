Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08073C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 15:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbjFIPEC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 11:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241495AbjFIPEB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2023 11:04:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38C530C5
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 08:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686322989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yUPsfdsk3Iy21xQ8M70UI0zjhCPokPQq3gCleINg9IA=;
        b=fWiTb0C6kJMWUagRqy5klQIl654JFdpodQwp3mj6knHVgDceK3JBLOVB3G1ENjVSNGQZwK
        /Y31OgYnmHT+4DNcUxmX5TXUK6VxLdopKvMvZ+JnG9vexku6PE3HVdvYkz51tkFwAdw35+
        zwXptZeqEXwoipQznYVnudNE8gbaSiA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-bqABIn8PP4O044U3LRsEEg-1; Fri, 09 Jun 2023 11:03:07 -0400
X-MC-Unique: bqABIn8PP4O044U3LRsEEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28955101A531
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 15:03:07 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2835140E954;
        Fri,  9 Jun 2023 15:03:06 +0000 (UTC)
Date:   Fri, 9 Jun 2023 10:03:05 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_repair: always print an estimate when reporting
 progress
Message-ID: <ZIM/KegChkoeTJE8@redhat.com>
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
 <20230531064143.1737591-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531064143.1737591-1-ddouwsma@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 31, 2023 at 04:41:43PM +1000, Donald Douwsma wrote:
> If xfs_repair completes the work for a given phase while allocation
> groups are still being processed the estimated time may be zero, when
> this occures xfs_repair prints an incomplete string.
> 
>  # xfs_repair -o ag_stride=4 -t 1 /dev/sdc
>  Phase 1 - find and verify superblock...
>          - reporting progress in intervals of 1 second
>  Phase 2 - using internal log
>          - zero log...
>          - 20:52:11: zeroing log - 0 of 2560 blocks done
>          - 20:52:12: zeroing log - 2560 of 2560 blocks done
>          - scan filesystem freespace and inode maps...
>          - 20:52:12: scanning filesystem freespace - 3 of 4 allocation groups done
>          - 20:52:13: scanning filesystem freespace - 4 of 4 allocation groups done
>          - found root inode chunk
>  Phase 3 - for each AG...
>          - scan and clear agi unlinked lists...
>          - 20:52:13: scanning agi unlinked lists - 4 of 4 allocation groups done
>          - process known inodes and perform inode discovery...
>          - agno = 0
>          - 20:52:13: process known inodes and inode discovery - 3456 of 40448 inodes done
>          - 20:52:14: process known inodes and inode discovery - 3456 of 40448 inodes done
>          - 20:52:14: Phase 3: elapsed time 1 second - processed 207360 inodes per minute
>          - 20:52:14: Phase 3: 8% done - estimated remaining time 10 seconds
>          - 20:52:15: process known inodes and inode discovery - 3456 of 40448 inodes done
>          - 20:52:15: Phase 3: elapsed time 2 seconds - processed 103680 inodes per minute
>          - 20:52:15: Phase 3: 8% done - estimated remaining time 21 seconds
>          - 20:52:16: process known inodes and inode discovery - 33088 of 40448 inodes done
>          - 20:52:16: Phase 3: elapsed time 3 seconds - processed 661760 inodes per minute
>          - 20:52:16: Phase 3: 81% done - estimated remaining time
>          - agno = 1
>  	...
> 
> Make this more consistent by printing 'estimated remaining time 0
> seconds' if there is a 0 estimate.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Looks fine.
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  repair/progress.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/repair/progress.c b/repair/progress.c
> index f6c4d988..9fb6e3eb 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -501,6 +501,8 @@ duration(int length, char *buf)
>  			strcat(buf, _(", "));
>  		strcat(buf, temp);
>  	}
> +	if (!(weeks|days|hours|minutes|seconds))
> +		sprintf(buf, _("0 seconds"));
>  
>  	return(buf);
>  }
> -- 
> 2.39.3
> 

