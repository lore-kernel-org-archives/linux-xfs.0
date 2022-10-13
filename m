Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067B9C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 19:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJMTLE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 15:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiJMTKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 15:10:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF5C43E76
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 12:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F76EB81FCA
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 19:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56B7C433D6;
        Thu, 13 Oct 2022 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665688231;
        bh=beZGuM7OPeffWINQiNWZEqVhf7DAAGXJeLoomrXg8ZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SD3L0jG2/j9yk+l8MPWKz1qW4YFTOVdiS7NY7SaYRWK+5xl9p/wksBhOc6s/xDCbk
         EXWWvG9XQNd1ZRM0gCYtCcYu2O1LPC+lqxBuYlnXKxq5z7dfYGJRyTZdGZsjKx6Ipt
         B+o6eWDcltFzGs98cnFslcShWqvejW87oiGrPAMiOtf0C4jw7SfRinVyFoXA0ziJZQ
         FH+RIpvznf+jf9RDJwfRQ2Z0M0UOe3ghKyVmDFXtylewA1K+EdYnc0UztCg1o/g/a7
         piDfFgYu57nAGU/VBKKealHqC41nS20NfEz1wi5bn/lU8zXdO6XYjU8J39GtAyzaN6
         +WZrx6y/W51yw==
Date:   Thu, 13 Oct 2022 12:10:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfsdump: fix on-media inventory stream packing
Message-ID: <Y0hip0cjfi1oWn1B@magnolia>
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
 <20221013031518.1815861-4-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013031518.1815861-4-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 02:15:17PM +1100, Donald Douwsma wrote:
> With the on-media inventory now being restored for multiple streams we
> can see that the restored streams both claim to be for /dev/nst0.
> 
> [root@rhel8 xfsdump-dev]# xfsdump -L "Test2" -f /dev/nst0 -M "tape1" -f /dev/nst1 -M "tape2" /boot
> ...
> [root@rhel8 xfsdump-dev]# rm -rf /var/lib/xfsdump/inventory /tmp/test1/*
> [root@rhel8 xfsdump-dev]# restore/xfsrestore -L Test2 -f /dev/nst0 -f /dev/nst1 /tmp/test2
> restore/xfsrestore: using scsi tape (drive_scsitape) strategy
> restore/xfsrestore: using scsi tape (drive_scsitape) strategy
> restore/xfsrestore: version 3.1.10 (dump format 3.0) - type ^C for status and control
> ...
> restore/xfsrestore: Restore Summary:
> restore/xfsrestore:   stream 0 /dev/nst0 OK (success)
> restore/xfsrestore:   stream 1 /dev/nst1 ALREADY_DONE (another stream completed the operation)
> restore/xfsrestore: Restore Status: SUCCESS
> [root@rhel8 xfsdump-dev]# xfsdump -I
> file system 0:
>         fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>         session 0:
>                 mount point:    rhel8:/boot
>                 device:         rhel8:/dev/sda1
>                 time:           Wed Oct 12 15:36:55 2022
>                 session label:  "Test2"
>                 session id:     50be3b17-d9f9-414d-885b-ababf660e189
>                 level:          0
>                 resumed:        NO
>                 subtree:        NO
>                 streams:        2
>                 stream 0:
>                         pathname:       /dev/nst0
>                         start:          ino 133 offset 0
>                         end:            ino 28839 offset 0
>                         interrupted:    YES
>                         media files:    1
>                         media file 0:
>                                 mfile index:    2
>                                 mfile type:     data
>                                 mfile size:     165675008
>                                 mfile start:    ino 133 offset 0
>                                 mfile end:      ino 28839 offset 0
>                                 media label:    "test"

It's odd that you have -M tape1 above but this ends up labelled "test"?
If that isn't just a munged patch message, then that might need fixing
(separate patch) as well.

The code change looks correct though.  Thanks for fixing dump.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>                                 media id:       e2e6978d-5546-4f1f-8c9e-307168071889
>                 stream 1:
>                         pathname:       /dev/nst0
>                         start:          ino 133 offset 0
>                         end:            ino 28839 offset 0
>                         interrupted:    YES
>                         media files:    1
>                         media file 0:
>                                 mfile index:    0
>                                 mfile type:     data
>                                 mfile size:     166723584
>                                 mfile start:    ino 28839 offset 0
>                                 mfile end:      ino 1572997 offset 0
>                                 media label:    "tape2"
>                                 media id:       1ad6d919-7159-42fb-a20f-5a2c4e3e24b1
> xfsdump: Dump Status: SUCCESS
> [root@rhel8 xfsdump-dev]#
> 
> Fix this by indexing the stream being packed for the on-media inventory.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  inventory/inv_stobj.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index 025d431..fb4d93a 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -798,7 +798,7 @@ stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
>  	sesbuf += sizeof(invt_session_t);
>  
>  	for (i = 0; i < ses->s_cur_nstreams; i++) {
> -		xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
> +		xlate_invt_stream(&strms[i], (invt_stream_t *)sesbuf, 1);
>  		sesbuf += sizeof(invt_stream_t);
>  	}
>  
> -- 
> 2.31.1
> 
