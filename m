Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA9DC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 01:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiGNB54 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 21:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiGNB5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 21:57:54 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C50EA23157
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 18:57:53 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1243D4435;
        Wed, 13 Jul 2022 20:57:32 -0500 (CDT)
Message-ID: <bec46274-1ef5-c8de-2861-b8dadf3b188b@sandeen.net>
Date:   Wed, 13 Jul 2022 20:57:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     hexiaole <hexiaole1994@126.com>, linux-xfs@vger.kernel.org
Cc:     hexiaole <hexiaole@kylinos.cn>
References: <20220628144542.33704-1-hexiaole1994@126.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v1] xfs: correct nlink printf specifier from hd to PRIu32
In-Reply-To: <20220628144542.33704-1-hexiaole1994@126.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/28/22 9:45 AM, hexiaole wrote:
> From: hexiaole <hexiaole@kylinos.cn>
> 
> 1. Description
> libxfs/xfs_log_format.h declare 'di_nlink' as unsigned 32-bit integer:
> 
> typedef struct xfs_icdinode {
>         ...
>         __uint32_t      di_nlink;       /* number of links to file */
>         ...
> } xfs_icdinode_t;
> 
> But logprint/log_misc.c use '%hd' to print 'di_nlink':
> 
> void
> xlog_print_trans_inode_core(xfs_icdinode_t *ip)
> {
>     ...
>     printf(_("nlink %hd uid %d gid %d\n"),
>            ip->di_nlink, ip->di_uid, ip->di_gid);
>     ...
> }
> 
> '%hd' can be 16-bit on many architectures, on these architectures, the 'printf' only print the low 16-bit of 'di_nlink'.
> 
> 2. Reproducer
> 2.1. Commands
> [root@localhost ~]# cd
> [root@localhost ~]# xfs_mkfile 128m 128m.xfs
> [root@localhost ~]# mkfs.xfs 128m.xfs
> [root@localhost ~]# mount 128m.xfs /mnt/
> [root@localhost ~]# cd /mnt/
> [root@localhost mnt]# seq 1 65534|xargs mkdir -p
> [root@localhost mnt]# cd
> [root@localhost ~]# umount /mnt/
> [root@localhost ~]# xfs_logprint 128m.xfs|grep nlink|tail -1
> 
> 2.2. Expect result
> nlink 65536
> 
> 2.3. Actual result
> nlink 0

I'm being pedantic for such a small change, but technically this needs to be sent
with a Signed-off-by: from you please?

It's probably enough for you to just reply to this thread with "yes, please
add my Signed-off-by"

Thanks,
-Eric

> ---
>  logprint/log_misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 35e926a3..6add28ed 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -444,7 +444,7 @@ xlog_print_trans_inode_core(
>      printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
>  	   ip->di_magic, ip->di_mode, (int)ip->di_version,
>  	   (int)ip->di_format);
> -    printf(_("nlink %hd uid %d gid %d\n"),
> +    printf(_("nlink %" PRIu32 " uid %d gid %d\n"),
>  	   ip->di_nlink, ip->di_uid, ip->di_gid);
>      printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
>  		xlog_extract_dinode_ts(ip->di_atime),
