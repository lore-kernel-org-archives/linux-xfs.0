Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E516C433ED
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Apr 2021 00:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44BDB6113A
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Apr 2021 00:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhDJAzp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:55:45 -0400
Received: from gateway30.websitewelcome.com ([192.185.146.7]:46603 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235403AbhDJAzo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 20:55:44 -0400
X-Greylist: delayed 1502 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2021 20:55:43 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id D7C0F81DE
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 19:08:39 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id V1B1lhzHnMGeEV1B1lE0Z7; Fri, 09 Apr 2021 19:08:39 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ewx7eCV7voBdt/6tgm8R41S3pKpMi0vx9KC6Fn5lN9c=; b=jo4nqkLAYEH2cviOMrtqrQuCWW
        ew5f8broNVCkgFC29F3qrezHSoFVApl2GapQsW9iHe+uZ66u72+Cd1faVO7ru0P29+C0Ji6uzEhah
        Pqsa8ufyzxWoD2iSPljqUeUhngk9a3cahS4s4Ub2ZCN/6xrrGJG6B+aw++p17AFZ5oY7sb4li2aGu
        HG/C6myjjWnI2ywiBrOnxc4GByGvZn+9xvU/xHbN9zaYeuZx0ejmoS26AwmhbMk2IcnpsvwEv9Dti
        MVrYUSjjhBk6yF/GAkDxL91JgEkbJuI43TQBDpBpPqo/6vJYXUWitafkcIRAOCfp861hO1HIj1ih7
        Wr8Vlf/w==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:47294 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lV1B1-001Ga2-F3; Fri, 09 Apr 2021 19:08:39 -0500
Subject: Re: [PATCH v3][next] xfs: Replace one-element arrays with
 flexible-array members
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210311042302.GA137676@embeddedor>
 <20210311044700.GU3419940@magnolia>
 <96be7032-a95c-e8d2-a7f8-64b96686ea42@embeddedor.com>
 <20210320201711.GY22100@magnolia>
 <d5a9046e-e204-c854-34fe-2a39e58faea4@embeddedor.com>
 <20210320214831.GA22100@magnolia>
 <b9973292-efe6-5f95-a3a5-5d86e4081803@embeddedor.com>
Message-ID: <8d143f48-8cec-c36a-7c96-443445d44cd2@embeddedor.com>
Date:   Fri, 9 Apr 2021 19:08:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <b9973292-efe6-5f95-a3a5-5d86e4081803@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lV1B1-001Ga2-F3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:47294
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi!

On 4/9/21 01:54, Gustavo A. R. Silva wrote:
> 
> Hi!
> 
> I think I might have caught the issue:
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e5e0713bebcd8..9231457371100 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1937,17 +1937,17 @@ xfs_init_zones(void)
>  		goto out_destroy_trans_zone;
> 
>  	xfs_efd_zone = kmem_cache_create("xfs_efd_item",
> -					(sizeof(struct xfs_efd_log_item) +
> -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
> -					sizeof(struct xfs_extent)),
> -					0, 0, NULL);
> +					 struct_size((struct xfs_efd_log_item *)0,
> +					 efd_format.efd_extents,
> +					 XFS_EFD_MAX_FAST_EXTENTS),
> +					 0, 0, NULL);
>  	if (!xfs_efd_zone)
>  		goto out_destroy_buf_item_zone;
> 
>  	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
> -					 (sizeof(struct xfs_efi_log_item) +
> -					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
> -					 sizeof(struct xfs_extent)),
> +					 struct_size((struct xfs_efi_log_item *)0,
> +					 efi_format.efi_extents,
> +					 XFS_EFI_MAX_FAST_EXTENTS),
>  					 0, 0, NULL);
>  	if (!xfs_efi_zone)
>  		goto out_destroy_efd_zone;
> 
> I'm currently testing the patch with the fix above:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/commit/?h=testing/xfs-fixed

I'm running my tests again and, when I run ./check -g all on 5.12-rc2 without this patch, I see
the following error when the test reaches xfs/350:

[10630.458176] run fstests xfs/350 at 2021-04-09 18:33:25
[10630.808989] XFS (sdb1): Mounting V5 Filesystem
[10630.823642] XFS (sdb1): Ending clean mount
[10630.828252] xfs filesystem being mounted at /mnt/test supports timestamps until 2038 (0x7fffffff)
[10635.431857] [U] + Fuzz magicnum = zeroes
[10635.484247] XFS (sdb2): Invalid superblock magic number
[10635.998259] XFS (sdb2): Mounting V5 Filesystem
[10636.011306] XFS (sdb2): Ending clean mount
[10636.012740] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10636.013378] [U] ++ Try to write filesystem again
[10636.792921] XFS (sdb2): Unmounting Filesystem
[10639.071979] [U] + Fuzz magicnum = ones
[10639.124929] XFS (sdb2): Invalid superblock magic number
[10639.632516] XFS (sdb2): Mounting V5 Filesystem
[10639.642474] XFS (sdb2): Ending clean mount
[10639.645799] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10639.647805] [U] ++ Try to write filesystem again
[10640.487553] XFS (sdb2): Unmounting Filesystem
[10642.817589] [U] + Fuzz magicnum = firstbit
[10642.865363] XFS (sdb2): Invalid superblock magic number
[10643.323356] XFS (sdb2): Mounting V5 Filesystem
[10643.334475] XFS (sdb2): Ending clean mount
[10643.336493] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10643.337066] [U] ++ Try to write filesystem again
[10644.155821] XFS (sdb2): Unmounting Filesystem
[10646.503018] [U] + Fuzz magicnum = middlebit
[10646.549272] XFS (sdb2): Invalid superblock magic number
[10647.025628] XFS (sdb2): Mounting V5 Filesystem
[10647.036045] XFS (sdb2): Ending clean mount
[10647.037678] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10647.038222] [U] ++ Try to write filesystem again
[10647.889433] XFS (sdb2): Unmounting Filesystem
[10649.884045] [U] + Fuzz magicnum = lastbit
[10649.933139] XFS (sdb2): Invalid superblock magic number
[10650.410012] XFS (sdb2): Mounting V5 Filesystem
[10650.422481] XFS (sdb2): Ending clean mount
[10650.424557] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10650.425303] [U] ++ Try to write filesystem again
[10651.266636] XFS (sdb2): Unmounting Filesystem
[10653.273883] [U] + Fuzz magicnum = add
[10653.326476] XFS (sdb2): Invalid superblock magic number
[10653.822121] XFS (sdb2): Mounting V5 Filesystem
[10653.833971] XFS (sdb2): Ending clean mount
[10653.835387] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10653.835938] [U] ++ Try to write filesystem again
[10654.679518] XFS (sdb2): Unmounting Filesystem
[10656.896480] [U] + Fuzz magicnum = sub
[10656.944458] XFS (sdb2): Invalid superblock magic number
[10657.438870] XFS (sdb2): Mounting V5 Filesystem
[10657.446758] XFS (sdb2): Ending clean mount
[10657.450836] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10657.451545] [U] ++ Try to write filesystem again
[10658.295882] XFS (sdb2): Unmounting Filesystem
[10660.841168] [U] + Fuzz magicnum = random
[10660.894445] XFS (sdb2): Invalid superblock magic number
[10661.430426] XFS (sdb2): Mounting V5 Filesystem
[10661.455074] XFS (sdb2): Ending clean mount
[10661.456945] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10661.457397] [U] ++ Try to write filesystem again
[10662.279028] XFS (sdb2): Unmounting Filesystem
[10664.671702] [U] + Fuzz blocksize = zeroes
[10664.737855] XFS (sdb2): SB sanity check failed
[10664.737863] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10664.737877] XFS (sdb2): Unmount and run xfs_repair
[10664.737880] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10664.737884] 00000000: 58 46 53 42 00 00 00 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10664.737887] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10664.737889] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10664.737891] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10664.737893] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10664.737895] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10664.737897] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10664.737898] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10664.737922] XFS (sdb2): SB validate failed with error -117.
[10665.265433] XFS (sdb2): Mounting V5 Filesystem
[10665.279294] XFS (sdb2): Ending clean mount
[10665.283785] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10665.284524] [U] ++ Try to write filesystem again
[10666.058035] XFS (sdb2): Unmounting Filesystem
[10668.396404] [U] + Fuzz blocksize = ones
[10668.445747] XFS (sdb2): SB sanity check failed
[10668.445755] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10668.445776] XFS (sdb2): Unmount and run xfs_repair
[10668.445778] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10668.445781] 00000000: 58 46 53 42 ff ff ff ff 00 00 00 00 00 67 e7 00  XFSB.........g..
[10668.445784] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10668.445786] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10668.445789] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10668.445791] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10668.445793] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10668.445795] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10668.445796] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10668.445857] XFS (sdb2): SB validate failed with error -117.
[10669.059881] XFS (sdb2): Mounting V5 Filesystem
[10669.071515] XFS (sdb2): Ending clean mount
[10669.076272] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10669.076830] [U] ++ Try to write filesystem again
[10669.893290] XFS (sdb2): Unmounting Filesystem
[10672.389639] [U] + Fuzz blocksize = firstbit
[10672.446162] XFS (sdb2): SB sanity check failed
[10672.446170] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10672.446199] XFS (sdb2): Unmount and run xfs_repair
[10672.446201] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10672.446206] 00000000: 58 46 53 42 80 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10672.446210] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10672.446212] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10672.446215] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10672.446217] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10672.446219] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10672.446222] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10672.446224] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10672.446282] XFS (sdb2): SB validate failed with error -117.
[10673.028803] XFS (sdb2): Mounting V5 Filesystem
[10673.037324] XFS (sdb2): Ending clean mount
[10673.039541] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10673.040261] [U] ++ Try to write filesystem again
[10673.842546] XFS (sdb2): Unmounting Filesystem
[10676.127514] [U] + Fuzz blocksize = middlebit
[10676.184578] XFS (sdb2): SB sanity check failed
[10676.184586] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10676.184608] XFS (sdb2): Unmount and run xfs_repair
[10676.184611] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10676.184614] 00000000: 58 46 53 42 00 00 90 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10676.184617] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10676.184619] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10676.184621] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10676.184623] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10676.184626] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10676.184627] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10676.184629] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10676.184653] XFS (sdb2): SB validate failed with error -117.
[10676.735429] XFS (sdb2): Mounting V5 Filesystem
[10676.748376] XFS (sdb2): Ending clean mount
[10676.752533] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10676.753118] [U] ++ Try to write filesystem again
[10677.573686] XFS (sdb2): Unmounting Filesystem
[10679.567988] [U] + Fuzz blocksize = lastbit
[10679.619327] XFS (sdb2): SB sanity check failed
[10679.619334] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10679.619346] XFS (sdb2): Unmount and run xfs_repair
[10679.619348] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10679.619350] 00000000: 58 46 53 42 00 00 10 01 00 00 00 00 00 67 e7 00  XFSB.........g..
[10679.619352] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10679.619354] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10679.619356] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10679.619357] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10679.619359] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10679.619360] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10679.619361] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10679.619388] XFS (sdb2): SB validate failed with error -117.
[10680.210463] XFS (sdb2): Mounting V5 Filesystem
[10680.223957] XFS (sdb2): Ending clean mount
[10680.225661] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10680.226234] [U] ++ Try to write filesystem again
[10681.023494] XFS (sdb2): Unmounting Filesystem
[10683.038014] [U] + Fuzz blocksize = add
[10683.094403] XFS (sdb2): SB sanity check failed
[10683.094411] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10683.094423] XFS (sdb2): Unmount and run xfs_repair
[10683.094425] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10683.094427] 00000000: 58 46 53 42 00 00 17 e1 00 00 00 00 00 67 e7 00  XFSB.........g..
[10683.094430] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10683.094431] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10683.094433] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10683.094434] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10683.094435] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10683.094437] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10683.094438] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10683.094461] XFS (sdb2): SB validate failed with error -117.
[10683.646268] XFS (sdb2): Mounting V5 Filesystem
[10683.660136] XFS (sdb2): Ending clean mount
[10683.665474] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10683.666205] [U] ++ Try to write filesystem again
[10684.486387] XFS (sdb2): Unmounting Filesystem
[10686.932456] [U] + Fuzz blocksize = sub
[10686.988112] XFS (sdb2): SB sanity check failed
[10686.988121] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10686.988135] XFS (sdb2): Unmount and run xfs_repair
[10686.988137] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10686.988140] 00000000: 58 46 53 42 00 00 08 1f 00 00 00 00 00 67 e7 00  XFSB.........g..
[10686.988142] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10686.988151] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10686.988152] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10686.988154] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10686.988155] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10686.988157] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10686.988158] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10686.988179] XFS (sdb2): SB validate failed with error -117.
[10687.523945] XFS (sdb2): Mounting V5 Filesystem
[10687.536046] XFS (sdb2): Ending clean mount
[10687.540926] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10687.541539] [U] ++ Try to write filesystem again
[10688.393080] XFS (sdb2): Unmounting Filesystem
[10690.697969] [U] + Fuzz blocksize = random
[10690.758213] XFS (sdb2): SB sanity check failed
[10690.758222] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10690.758235] XFS (sdb2): Unmount and run xfs_repair
[10690.758237] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10690.758241] 00000000: 58 46 53 42 b9 e6 02 f2 00 00 00 00 00 67 e7 00  XFSB.........g..
[10690.758244] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10690.758246] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10690.758248] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10690.758251] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10690.758252] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10690.758254] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10690.758256] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10690.758285] XFS (sdb2): SB validate failed with error -117.
[10691.308337] XFS (sdb2): Mounting V5 Filesystem
[10691.320023] XFS (sdb2): Ending clean mount
[10691.325664] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10691.326227] [U] ++ Try to write filesystem again
[10692.142125] XFS (sdb2): Unmounting Filesystem
[10694.540331] [U] + Fuzz dblocks = zeroes
[10694.605376] XFS (sdb2): SB sanity check failed
[10694.605385] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10694.605399] XFS (sdb2): Unmount and run xfs_repair
[10694.605401] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10694.605404] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 00 00 00  XFSB............
[10694.605407] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10694.605409] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10694.605411] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10694.605413] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10694.605415] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10694.605417] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10694.605418] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10694.605458] XFS (sdb2): SB validate failed with error -117.
[10695.113752] XFS (sdb2): Mounting V5 Filesystem
[10695.142912] XFS (sdb2): Ending clean mount
[10695.144758] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10695.145194] [U] ++ Try to write filesystem again
[10695.954221] XFS (sdb2): Unmounting Filesystem
[10698.373692] [U] + Fuzz dblocks = ones
[10698.429619] XFS (sdb2): SB sanity check failed
[10698.429627] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10698.429638] XFS (sdb2): Unmount and run xfs_repair
[10698.429640] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10698.429650] 00000000: 58 46 53 42 00 00 10 00 ff ff ff ff ff ff ff ff  XFSB............
[10698.429652] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10698.429654] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10698.429655] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10698.429656] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10698.429658] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10698.429659] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10698.429661] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10698.429682] XFS (sdb2): SB validate failed with error -117.
[10699.024410] XFS (sdb2): Mounting V5 Filesystem
[10699.036038] XFS (sdb2): Ending clean mount
[10699.038327] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10699.039900] [U] ++ Try to write filesystem again
[10699.842797] XFS (sdb2): Unmounting Filesystem
[10702.260024] [U] + Fuzz dblocks = firstbit
[10702.317263] XFS (sdb2): SB sanity check failed
[10702.317272] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10702.317286] XFS (sdb2): Unmount and run xfs_repair
[10702.317289] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10702.317292] 00000000: 58 46 53 42 00 00 10 00 80 00 00 00 00 67 e7 00  XFSB.........g..
[10702.317295] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10702.317298] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10702.317300] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10702.317302] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10702.317304] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10702.317306] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10702.317307] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10702.317331] XFS (sdb2): SB validate failed with error -117.
[10702.872877] XFS (sdb2): Mounting V5 Filesystem
[10702.884348] XFS (sdb2): Ending clean mount
[10702.890077] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10702.890585] [U] ++ Try to write filesystem again
[10703.620773] XFS (sdb2): Unmounting Filesystem
[10705.931044] [U] + Fuzz dblocks = middlebit
[10705.985735] XFS (sdb2): SB sanity check failed
[10705.985743] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10705.985761] XFS (sdb2): Unmount and run xfs_repair
[10705.985762] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10705.985765] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 80 67 e7 00  XFSB.........g..
[10705.985768] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10705.985769] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10705.985771] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10705.985772] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10705.985774] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10705.985775] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10705.985776] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10705.985796] XFS (sdb2): SB validate failed with error -117.
[10706.533315] XFS (sdb2): Mounting V5 Filesystem
[10706.544082] XFS (sdb2): Ending clean mount
[10706.548414] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10706.549104] [U] ++ Try to write filesystem again
[10707.339557] XFS (sdb2): Unmounting Filesystem
[10709.594864] [U] + Fuzz dblocks = lastbit
[10709.640075] XFS (sdb2): SB sanity check failed
[10709.640080] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10709.640089] XFS (sdb2): Unmount and run xfs_repair
[10709.640090] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10709.640093] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 01  XFSB.........g..
[10709.640094] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10709.640095] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10709.640097] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10709.640097] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10709.640103] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10709.640104] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10709.640105] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10709.640125] XFS (sdb2): SB validate failed with error -117.
[10710.173515] XFS (sdb2): Mounting V5 Filesystem
[10710.183729] XFS (sdb2): Ending clean mount
[10710.190875] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10710.191442] [U] ++ Try to write filesystem again
[10710.999385] XFS (sdb2): Unmounting Filesystem
[10713.403251] [U] + Fuzz dblocks = add
[10713.452168] XFS (sdb2): SB sanity check failed
[10713.452179] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10713.452191] XFS (sdb2): Unmount and run xfs_repair
[10713.452193] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10713.452195] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 ee e1  XFSB.........g..
[10713.452198] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10713.452199] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10713.452201] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10713.452202] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10713.452204] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10713.452205] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10713.452206] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10713.452227] XFS (sdb2): SB validate failed with error -117.
[10713.997789] XFS (sdb2): Mounting V5 Filesystem
[10714.010231] XFS (sdb2): Ending clean mount
[10714.015371] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10714.015883] [U] ++ Try to write filesystem again
[10714.771935] XFS (sdb2): Unmounting Filesystem
[10717.259459] [U] + Fuzz dblocks = sub
[10717.310086] XFS (sdb2): Mounting V5 Filesystem
[10717.322283] XFS (sdb2): resetting quota flags
[10717.322297] XFS (sdb2): Ending clean mount
[10717.327963] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10717.336408] XFS (sdb2): Unmounting Filesystem
[10718.044923] XFS (sdb2): Mounting V5 Filesystem
[10718.055794] XFS (sdb2): Ending clean mount
[10718.061024] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10718.061490] [U] ++ Try to write filesystem again
[10718.798068] XFS (sdb2): Unmounting Filesystem
[10721.235766] [U] + Fuzz dblocks = random
[10721.291746] XFS (sdb2): SB sanity check failed
[10721.291753] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10721.291767] XFS (sdb2): Unmount and run xfs_repair
[10721.291769] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10721.291772] 00000000: 58 46 53 42 00 00 10 00 f3 98 cc f4 2e c2 c3 ca  XFSB............
[10721.291775] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10721.291777] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10721.291779] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10721.291781] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10721.291783] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10721.291785] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10721.291786] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10721.291811] XFS (sdb2): SB validate failed with error -117.
[10721.843894] XFS (sdb2): Mounting V5 Filesystem
[10721.855953] XFS (sdb2): Ending clean mount
[10721.860526] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10721.861078] [U] ++ Try to write filesystem again
[10722.739885] XFS (sdb2): Unmounting Filesystem
[10725.256338] [U] + Fuzz rblocks = zeroes
[10727.014484] [U] + Fuzz rblocks = ones
[10727.072182] XFS (sdb2): realtime geometry sanity check failed
[10727.072189] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10727.072199] XFS (sdb2): Unmount and run xfs_repair
[10727.072201] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10727.072203] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10727.072205] 00000010: ff ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00  ................
[10727.072206] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10727.072207] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10727.072208] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10727.072210] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10727.072211] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10727.072211] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10727.072237] XFS (sdb2): SB validate failed with error -117.
[10727.605794] XFS (sdb2): Mounting V5 Filesystem
[10727.618453] XFS (sdb2): Ending clean mount
[10727.623406] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10727.623952] [U] ++ Try to write filesystem again
[10728.439124] XFS (sdb2): Unmounting Filesystem
[10730.546383] [U] + Fuzz rblocks = firstbit
[10730.601126] XFS (sdb2): realtime geometry sanity check failed
[10730.601132] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10730.601142] XFS (sdb2): Unmount and run xfs_repair
[10730.601143] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10730.601145] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10730.601147] 00000010: 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[10730.601148] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10730.601149] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10730.601150] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10730.601151] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10730.601152] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10730.601153] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10730.601175] XFS (sdb2): SB validate failed with error -117.
[10731.192351] XFS (sdb2): Mounting V5 Filesystem
[10731.201281] XFS (sdb2): Ending clean mount
[10731.206869] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10731.207335] [U] ++ Try to write filesystem again
[10732.016884] XFS (sdb2): Unmounting Filesystem
[10734.413773] [U] + Fuzz rblocks = middlebit
[10734.468546] XFS (sdb2): realtime geometry sanity check failed
[10734.468561] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10734.468575] XFS (sdb2): Unmount and run xfs_repair
[10734.468577] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10734.468581] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10734.468584] 00000010: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00  ................
[10734.468587] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10734.468589] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10734.468591] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10734.468593] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10734.468595] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10734.468597] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10734.468619] XFS (sdb2): SB validate failed with error -117.
[10735.044488] XFS (sdb2): Mounting V5 Filesystem
[10735.060124] XFS (sdb2): Ending clean mount
[10735.065015] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10735.065683] [U] ++ Try to write filesystem again
[10735.894924] XFS (sdb2): Unmounting Filesystem
[10738.382618] [U] + Fuzz rblocks = lastbit
[10738.436639] XFS (sdb2): realtime geometry sanity check failed
[10738.436647] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10738.436668] XFS (sdb2): Unmount and run xfs_repair
[10738.436670] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10738.436674] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10738.436676] 00000010: 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00  ................
[10738.436679] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10738.436680] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10738.436683] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10738.436684] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10738.436686] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10738.436688] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10738.436710] XFS (sdb2): SB validate failed with error -117.
[10739.029629] XFS (sdb2): Mounting V5 Filesystem
[10739.039773] XFS (sdb2): Ending clean mount
[10739.045296] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10739.045798] [U] ++ Try to write filesystem again
[10739.842740] XFS (sdb2): Unmounting Filesystem
[10742.135548] [U] + Fuzz rblocks = add
[10742.184957] XFS (sdb2): realtime geometry sanity check failed
[10742.184965] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10742.184977] XFS (sdb2): Unmount and run xfs_repair
[10742.184978] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10742.184980] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10742.184982] 00000010: 00 00 00 00 00 00 07 e1 00 00 00 00 00 00 00 00  ................
[10742.184983] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10742.184985] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10742.184986] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10742.184987] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10742.184988] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10742.184989] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10742.185009] XFS (sdb2): SB validate failed with error -117.
[10742.690555] XFS (sdb2): Mounting V5 Filesystem
[10742.703404] XFS (sdb2): Ending clean mount
[10742.707055] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10742.707705] [U] ++ Try to write filesystem again
[10743.525638] XFS (sdb2): Unmounting Filesystem
[10745.955268] [U] + Fuzz rblocks = sub
[10746.005392] XFS (sdb2): realtime geometry sanity check failed
[10746.005402] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10746.005428] XFS (sdb2): Unmount and run xfs_repair
[10746.005431] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10746.005436] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10746.005441] 00000010: ff ff ff ff ff ff f8 1f 00 00 00 00 00 00 00 00  ................
[10746.005444] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10746.005447] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10746.005450] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10746.005453] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10746.005455] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10746.005458] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10746.005484] XFS (sdb2): SB validate failed with error -117.
[10746.545012] XFS (sdb2): Mounting V5 Filesystem
[10746.556238] XFS (sdb2): Ending clean mount
[10746.560079] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10746.560635] [U] ++ Try to write filesystem again
[10747.341796] XFS (sdb2): Unmounting Filesystem
[10749.801228] [U] + Fuzz rblocks = random
[10749.856250] XFS (sdb2): realtime geometry sanity check failed
[10749.856259] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10749.856274] XFS (sdb2): Unmount and run xfs_repair
[10749.856276] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10749.856280] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10749.856284] 00000010: e3 c8 3c a4 1e f2 33 7a 00 00 00 00 00 00 00 00  ..<...3z........
[10749.856286] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10749.856288] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10749.856290] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10749.856292] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10749.856294] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10749.856295] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10749.856318] XFS (sdb2): SB validate failed with error -117.
[10750.413254] XFS (sdb2): Mounting V5 Filesystem
[10750.427798] XFS (sdb2): Ending clean mount
[10750.432992] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10750.433695] [U] ++ Try to write filesystem again
[10751.220188] XFS (sdb2): Unmounting Filesystem
[10753.791752] [U] + Fuzz rextents = zeroes
[10755.888633] [U] + Fuzz rextents = ones
[10755.938975] XFS (sdb2): realtime zeroed geometry check failed
[10755.938984] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10755.938998] XFS (sdb2): Unmount and run xfs_repair
[10755.939001] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10755.939004] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10755.939008] 00000010: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  ................
[10755.939019] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10755.939021] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10755.939023] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10755.939024] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10755.939026] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10755.939028] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10755.939051] XFS (sdb2): SB validate failed with error -117.
[10756.526169] XFS (sdb2): Mounting V5 Filesystem
[10756.539710] XFS (sdb2): Ending clean mount
[10756.544658] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10756.545324] [U] ++ Try to write filesystem again
[10757.368372] XFS (sdb2): Unmounting Filesystem
[10759.940901] [U] + Fuzz rextents = firstbit
[10759.996834] XFS (sdb2): realtime zeroed geometry check failed
[10759.996843] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10759.996858] XFS (sdb2): Unmount and run xfs_repair
[10759.996860] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10759.996864] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10759.996867] 00000010: 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00 00  ................
[10759.996869] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10759.996871] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10759.996873] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10759.996875] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10759.996876] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10759.996878] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10759.996923] XFS (sdb2): SB validate failed with error -117.
[10760.577789] XFS (sdb2): Mounting V5 Filesystem
[10760.592190] XFS (sdb2): Ending clean mount
[10760.596915] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10760.597569] [U] ++ Try to write filesystem again
[10761.360357] XFS (sdb2): Unmounting Filesystem
[10763.803816] [U] + Fuzz rextents = middlebit
[10763.859839] XFS (sdb2): realtime zeroed geometry check failed
[10763.859849] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10763.859865] XFS (sdb2): Unmount and run xfs_repair
[10763.859867] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10763.859872] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10763.859875] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 00  ................
[10763.859877] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10763.859880] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10763.859881] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10763.859883] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10763.859885] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10763.859887] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10763.860039] XFS (sdb2): SB validate failed with error -117.
[10764.393977] XFS (sdb2): Mounting V5 Filesystem
[10764.405934] XFS (sdb2): Ending clean mount
[10764.408291] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10764.408753] [U] ++ Try to write filesystem again
[10765.194953] XFS (sdb2): Unmounting Filesystem
[10767.642061] [U] + Fuzz rextents = lastbit
[10767.696794] XFS (sdb2): realtime zeroed geometry check failed
[10767.696802] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10767.696815] XFS (sdb2): Unmount and run xfs_repair
[10767.696817] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10767.696820] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10767.696824] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
[10767.696833] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10767.696835] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10767.696837] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10767.696838] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10767.696840] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10767.696842] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10767.696877] XFS (sdb2): SB validate failed with error -117.
[10768.170474] XFS (sdb2): Mounting V5 Filesystem
[10768.197459] XFS (sdb2): Ending clean mount
[10768.202226] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10768.203362] [U] ++ Try to write filesystem again
[10768.996498] XFS (sdb2): Unmounting Filesystem
[10771.044799] [U] + Fuzz rextents = add
[10771.104269] XFS (sdb2): realtime zeroed geometry check failed
[10771.104280] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10771.104292] XFS (sdb2): Unmount and run xfs_repair
[10771.104293] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10771.104295] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10771.104297] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e1  ................
[10771.104299] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10771.104300] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10771.104301] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10771.104302] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10771.104303] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10771.104304] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10771.104326] XFS (sdb2): SB validate failed with error -117.
[10771.648698] XFS (sdb2): Mounting V5 Filesystem
[10771.660387] XFS (sdb2): Ending clean mount
[10771.664679] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10771.665276] [U] ++ Try to write filesystem again
[10772.456567] XFS (sdb2): Unmounting Filesystem
[10774.873437] [U] + Fuzz rextents = sub
[10774.925617] XFS (sdb2): realtime zeroed geometry check failed
[10774.925623] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10774.925634] XFS (sdb2): Unmount and run xfs_repair
[10774.925636] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10774.925638] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10774.925640] 00000010: 00 00 00 00 00 00 00 00 ff ff ff ff ff ff f8 1f  ................
[10774.925641] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10774.925647] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10774.925648] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10774.925650] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10774.925651] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10774.925652] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10774.925672] XFS (sdb2): SB validate failed with error -117.
[10775.520734] XFS (sdb2): Mounting V5 Filesystem
[10775.530877] XFS (sdb2): Ending clean mount
[10775.533210] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10775.533785] [U] ++ Try to write filesystem again
[10776.327506] XFS (sdb2): Unmounting Filesystem
[10778.672500] [U] + Fuzz rextents = random
[10778.724176] XFS (sdb2): realtime zeroed geometry check failed
[10778.724190] XFS (sdb2): Metadata corruption detected at xfs_sb_read_verify+0x157/0x170, xfs_sb block 0xffffffffffffffff
[10778.724205] XFS (sdb2): Unmount and run xfs_repair
[10778.724207] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10778.724210] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 67 e7 00  XFSB.........g..
[10778.724213] 00000010: 00 00 00 00 00 00 00 00 c6 38 22 c9 a8 ea 01 66  .........8"....f
[10778.724215] 00000020: 9c c0 7d f5 0c 35 4b 1b 9e 2d 97 9a e7 37 36 58  ..}..5K..-...76X
[10778.724217] 00000030: 00 00 00 00 00 40 00 06 00 00 00 00 00 00 00 80  .....@..........
[10778.724219] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[10778.724221] 00000050: 00 00 00 01 00 19 f9 c0 00 00 00 04 00 00 00 00  ................
[10778.724223] 00000060: 00 00 0c fc b4 f5 02 00 02 00 00 08 00 00 00 00  ................
[10778.724225] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 15 00 00 19  ................
[10778.724247] XFS (sdb2): SB validate failed with error -117.
[10779.245765] XFS (sdb2): Mounting V5 Filesystem
[10779.261000] XFS (sdb2): Ending clean mount
[10779.265305] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10779.265865] [U] ++ Try to write filesystem again
[10780.115143] XFS (sdb2): Unmounting Filesystem
[10782.513178] [U] + Fuzz uuid = zeroes
[10782.568917] XFS (sdb2): Filesystem has null UUID - can't mount
[10785.533550] XFS (sdb2): Mounting V5 Filesystem
[10785.543855] XFS (sdb2): Metadata corruption detected at xfs_agi_verify+0xee/0x1a0, xfs_agi block 0x2
[10785.543873] XFS (sdb2): Unmount and run xfs_repair
[10785.543877] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10785.543880] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 00 19 f9 c0  XAGI............
[10785.543883] 00000010: 00 00 00 40 00 00 00 01 00 00 00 01 00 00 00 3d  ...@...........=
[10785.543886] 00000020: 00 00 00 80 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10785.543888] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10785.543889] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10785.543891] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10785.543893] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10785.543895] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10785.543918] XFS (sdb2): metadata I/O error in "xfs_read_agi+0xa1/0x150" at daddr 0x2 len 1 error 117
[10785.543936] XFS (sdb2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117, agno 0
[10785.543949] XFS (sdb2): Failed to read root inode 0x80, error 117
[10787.619103] [U] + Fuzz uuid = ones
[10787.675976] XFS (sdb2): Mounting V5 Filesystem
[10787.684134] XFS (sdb2): Internal error !uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid) at line 259 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_header_check_mount+0x4e/0x110
[10787.684158] CPU: 9 PID: 1146409 Comm: mount Tainted: G           OE     5.12.0-rc2 #13
[10787.684162] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10787.684165] Call Trace:
[10787.684169]  dump_stack+0x7d/0x9c
[10787.684175]  xfs_corruption_error+0x81/0x90
[10787.684179]  ? xlog_header_check_mount+0x4e/0x110
[10787.684182]  xlog_header_check_mount+0x78/0x110
[10787.684185]  ? xlog_header_check_mount+0x4e/0x110
[10787.684187]  xlog_find_verify_log_record+0x127/0x2a0
[10787.684190]  xlog_find_head+0x1c4/0x470
[10787.684194]  xlog_find_tail+0x43/0x370
[10787.684196]  ? try_to_wake_up+0x257/0x5c0
[10787.684208]  xlog_recover+0x2f/0x160
[10787.684210]  ? xfs_trans_ail_init+0xbc/0xf0
[10787.684213]  xfs_log_mount+0x181/0x310
[10787.684216]  xfs_mountfs+0x468/0x940
[10787.684220]  xfs_fs_fill_super+0x3ac/0x760
[10787.684223]  get_tree_bdev+0x171/0x270
[10787.684227]  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
[10787.684230]  xfs_fs_get_tree+0x15/0x20
[10787.684233]  vfs_get_tree+0x2a/0xc0
[10787.684237]  path_mount+0x484/0xac0
[10787.684241]  __x64_sys_mount+0x108/0x140
[10787.684244]  do_syscall_64+0x38/0x90
[10787.684248]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10787.684252] RIP: 0033:0x7f39ff2e3efe
[10787.684256] Code: 48 8b 0d 6d 8f 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 3a 8f 0c 00 f7 d8 64 89 01 48
[10787.684258] RSP: 002b:00007ffddd32a748 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[10787.684269] RAX: ffffffffffffffda RBX: 00007f39ff411264 RCX: 00007f39ff2e3efe
[10787.684271] RDX: 000055ae51fffb90 RSI: 000055ae51fffbd0 RDI: 000055ae51fffbb0
[10787.684273] RBP: 000055ae51fff960 R08: 0000000000000000 R09: 000055ae520028e0
[10787.684274] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[10787.684275] R13: 000055ae51fffbb0 R14: 000055ae51fffb90 R15: 000055ae51fff960
[10787.684278] XFS (sdb2): Corruption detected. Unmount and run xfs_repair
[10787.684281] XFS (sdb2): log has mismatched uuid - can't recover
[10787.684283] XFS (sdb2): xlog_header_check_dump:  SB : uuid = ffffffff-ffff-ffff-ffff-ffffffffffff, fmt = 1
[10787.684286] XFS (sdb2):     log : uuid = 9cc07df5-0c35-4b1b-9e2d-979ae7373658, fmt = 1
[10787.684289] XFS (sdb2): failed to find log head
[10787.684291] XFS (sdb2): log mount/recovery failed: error -117
[10787.684464] XFS (sdb2): log mount failed
[10790.606097] XFS (sdb2): Mounting V5 Filesystem
[10790.622711] XFS (sdb2): Metadata corruption detected at xfs_agi_verify+0xee/0x1a0, xfs_agi block 0x2
[10790.622727] XFS (sdb2): Unmount and run xfs_repair
[10790.622729] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10790.622731] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 00 19 f9 c0  XAGI............
[10790.622733] 00000010: 00 00 00 40 00 00 00 01 00 00 00 01 00 00 00 3d  ...@...........=
[10790.622734] 00000020: 00 00 00 80 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10790.622735] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10790.622736] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10790.622737] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10790.622738] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10790.622739] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10790.622888] XFS (sdb2): metadata I/O error in "xfs_read_agi+0xa1/0x150" at daddr 0x2 len 1 error 117
[10790.622904] XFS (sdb2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117, agno 0
[10790.622909] XFS (sdb2): Failed to read root inode 0x80, error 117
[10792.608945] [U] + Fuzz uuid = firstbit
[10792.660503] XFS (sdb2): Mounting V5 Filesystem
[10792.669649] XFS (sdb2): Internal error !uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid) at line 259 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_header_check_mount+0x4e/0x110
[10792.669667] CPU: 19 PID: 1147272 Comm: mount Tainted: G           OE     5.12.0-rc2 #13
[10792.669671] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10792.669673] Call Trace:
[10792.669678]  dump_stack+0x7d/0x9c
[10792.669684]  xfs_corruption_error+0x81/0x90
[10792.669688]  ? xlog_header_check_mount+0x4e/0x110
[10792.669691]  xlog_header_check_mount+0x78/0x110
[10792.669694]  ? xlog_header_check_mount+0x4e/0x110
[10792.669696]  xlog_find_verify_log_record+0x127/0x2a0
[10792.669699]  xlog_find_head+0x1c4/0x470
[10792.669710]  xlog_find_tail+0x43/0x370
[10792.669712]  ? try_to_wake_up+0x257/0x5c0
[10792.669717]  xlog_recover+0x2f/0x160
[10792.669719]  ? xfs_trans_ail_init+0xbc/0xf0
[10792.669722]  xfs_log_mount+0x181/0x310
[10792.669725]  xfs_mountfs+0x468/0x940
[10792.669729]  xfs_fs_fill_super+0x3ac/0x760
[10792.669732]  get_tree_bdev+0x171/0x270
[10792.669736]  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
[10792.669738]  xfs_fs_get_tree+0x15/0x20
[10792.669742]  vfs_get_tree+0x2a/0xc0
[10792.669745]  path_mount+0x484/0xac0
[10792.669749]  __x64_sys_mount+0x108/0x140
[10792.669753]  do_syscall_64+0x38/0x90
[10792.669758]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10792.669768] RIP: 0033:0x7fec49dedefe
[10792.669771] Code: 48 8b 0d 6d 8f 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 3a 8f 0c 00 f7 d8 64 89 01 48
[10792.669774] RSP: 002b:00007ffd39030558 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[10792.669777] RAX: ffffffffffffffda RBX: 00007fec49f1b264 RCX: 00007fec49dedefe
[10792.669779] RDX: 0000564fcc4ecb90 RSI: 0000564fcc4ecbd0 RDI: 0000564fcc4ecbb0
[10792.669781] RBP: 0000564fcc4ec960 R08: 0000000000000000 R09: 0000564fcc4ef8e0
[10792.669782] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[10792.669784] R13: 0000564fcc4ecbb0 R14: 0000564fcc4ecb90 R15: 0000564fcc4ec960
[10792.669786] XFS (sdb2): Corruption detected. Unmount and run xfs_repair
[10792.669789] XFS (sdb2): log has mismatched uuid - can't recover
[10792.669791] XFS (sdb2): xlog_header_check_dump:  SB : uuid = 1cc07df5-0c35-4b1b-9e2d-979ae7373658, fmt = 1
[10792.669794] XFS (sdb2):     log : uuid = 9cc07df5-0c35-4b1b-9e2d-979ae7373658, fmt = 1
[10792.669797] XFS (sdb2): failed to find log head
[10792.669798] XFS (sdb2): log mount/recovery failed: error -117
[10792.671055] XFS (sdb2): log mount failed
[10794.621029] XFS (sdb2): Mounting V5 Filesystem
[10794.632631] XFS (sdb2): Metadata corruption detected at xfs_agi_verify+0xee/0x1a0, xfs_agi block 0x2
[10794.632648] XFS (sdb2): Unmount and run xfs_repair
[10794.632650] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10794.632653] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 00 19 f9 c0  XAGI............
[10794.632655] 00000010: 00 00 00 40 00 00 00 01 00 00 00 01 00 00 00 3d  ...@...........=
[10794.632656] 00000020: 00 00 00 80 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10794.632657] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10794.632658] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10794.632660] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10794.632661] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10794.632662] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10794.632687] XFS (sdb2): metadata I/O error in "xfs_read_agi+0xa1/0x150" at daddr 0x2 len 1 error 117
[10794.632712] XFS (sdb2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117, agno 0
[10794.632719] XFS (sdb2): Failed to read root inode 0x80, error 117
[10796.443868] [U] + Fuzz uuid = middlebit
[10796.494240] XFS (sdb2): Mounting V5 Filesystem
[10796.504661] XFS (sdb2): Internal error !uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid) at line 259 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_header_check_mount+0x4e/0x110
[10796.504678] CPU: 15 PID: 1148135 Comm: mount Tainted: G           OE     5.12.0-rc2 #13
[10796.504682] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10796.504684] Call Trace:
[10796.504689]  dump_stack+0x7d/0x9c
[10796.504695]  xfs_corruption_error+0x81/0x90
[10796.504699]  ? xlog_header_check_mount+0x4e/0x110
[10796.504702]  xlog_header_check_mount+0x78/0x110
[10796.504704]  ? xlog_header_check_mount+0x4e/0x110
[10796.504707]  xlog_find_verify_log_record+0x127/0x2a0
[10796.504710]  xlog_find_head+0x1c4/0x470
[10796.504714]  xlog_find_tail+0x43/0x370
[10796.504722]  ? try_to_wake_up+0x257/0x5c0
[10796.504727]  xlog_recover+0x2f/0x160
[10796.504729]  ? xfs_trans_ail_init+0xbc/0xf0
[10796.504732]  xfs_log_mount+0x181/0x310
[10796.504735]  xfs_mountfs+0x468/0x940
[10796.504739]  xfs_fs_fill_super+0x3ac/0x760
[10796.504742]  get_tree_bdev+0x171/0x270
[10796.504747]  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
[10796.504749]  xfs_fs_get_tree+0x15/0x20
[10796.504753]  vfs_get_tree+0x2a/0xc0
[10796.504756]  path_mount+0x484/0xac0
[10796.504761]  __x64_sys_mount+0x108/0x140
[10796.504764]  do_syscall_64+0x38/0x90
[10796.504769]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10796.504773] RIP: 0033:0x7f145313befe
[10796.504783] Code: 48 8b 0d 6d 8f 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 3a 8f 0c 00 f7 d8 64 89 01 48
[10796.504785] RSP: 002b:00007fff336b18d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[10796.504789] RAX: ffffffffffffffda RBX: 00007f1453269264 RCX: 00007f145313befe
[10796.504791] RDX: 0000559e689ecb90 RSI: 0000559e689ecbd0 RDI: 0000559e689ecbb0
[10796.504792] RBP: 0000559e689ec960 R08: 0000000000000000 R09: 0000559e689ef8e0
[10796.504794] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[10796.504795] R13: 0000559e689ecbb0 R14: 0000559e689ecb90 R15: 0000559e689ec960
[10796.504798] XFS (sdb2): Corruption detected. Unmount and run xfs_repair
[10796.504800] XFS (sdb2): log has mismatched uuid - can't recover
[10796.504802] XFS (sdb2): xlog_header_check_dump:  SB : uuid = 9cc07df5-0c35-4b1b-1e2d-979ae7373658, fmt = 1
[10796.504805] XFS (sdb2):     log : uuid = 9cc07df5-0c35-4b1b-9e2d-979ae7373658, fmt = 1
[10796.504808] XFS (sdb2): failed to find log head
[10796.504809] XFS (sdb2): log mount/recovery failed: error -117
[10796.504956] XFS (sdb2): log mount failed
[10798.573228] XFS (sdb2): Mounting V5 Filesystem
[10798.583441] XFS (sdb2): Metadata corruption detected at xfs_agi_verify+0xee/0x1a0, xfs_agi block 0x2
[10798.583467] XFS (sdb2): Unmount and run xfs_repair
[10798.583469] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10798.583473] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 00 19 f9 c0  XAGI............
[10798.583475] 00000010: 00 00 00 40 00 00 00 01 00 00 00 01 00 00 00 3d  ...@...........=
[10798.583477] 00000020: 00 00 00 80 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10798.583479] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10798.583480] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10798.583482] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10798.583483] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10798.583484] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10798.583506] XFS (sdb2): metadata I/O error in "xfs_read_agi+0xa1/0x150" at daddr 0x2 len 1 error 117
[10798.583524] XFS (sdb2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117, agno 0
[10798.583530] XFS (sdb2): Failed to read root inode 0x80, error 117
[10800.642436] [U] + Fuzz uuid = lastbit
[10800.696698] XFS (sdb2): Mounting V5 Filesystem
[10800.704113] XFS (sdb2): Internal error !uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid) at line 259 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_header_check_mount+0x4e/0x110
[10800.704131] CPU: 25 PID: 1148998 Comm: mount Tainted: G           OE     5.12.0-rc2 #13
[10800.704136] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10800.704138] Call Trace:
[10800.704143]  dump_stack+0x7d/0x9c
[10800.704149]  xfs_corruption_error+0x81/0x90
[10800.704153]  ? xlog_header_check_mount+0x4e/0x110
[10800.704156]  xlog_header_check_mount+0x78/0x110
[10800.704159]  ? xlog_header_check_mount+0x4e/0x110
[10800.704161]  xlog_find_verify_log_record+0x127/0x2a0
[10800.704172]  xlog_find_head+0x1c4/0x470
[10800.704176]  xlog_find_tail+0x43/0x370
[10800.704178]  ? try_to_wake_up+0x257/0x5c0
[10800.704184]  xlog_recover+0x2f/0x160
[10800.704187]  ? xfs_trans_ail_init+0xbc/0xf0
[10800.704190]  xfs_log_mount+0x181/0x310
[10800.704194]  xfs_mountfs+0x468/0x940
[10800.704198]  xfs_fs_fill_super+0x3ac/0x760
[10800.704201]  get_tree_bdev+0x171/0x270
[10800.704206]  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
[10800.704209]  xfs_fs_get_tree+0x15/0x20
[10800.704212]  vfs_get_tree+0x2a/0xc0
[10800.704215]  path_mount+0x484/0xac0
[10800.704220]  __x64_sys_mount+0x108/0x140
[10800.704224]  do_syscall_64+0x38/0x90
[10800.704236]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10800.704240] RIP: 0033:0x7fa92ce7fefe
[10800.704244] Code: 48 8b 0d 6d 8f 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 3a 8f 0c 00 f7 d8 64 89 01 48
[10800.704247] RSP: 002b:00007ffcfd0a7228 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[10800.704251] RAX: ffffffffffffffda RBX: 00007fa92cfad264 RCX: 00007fa92ce7fefe
[10800.704254] RDX: 00005652d0e41b90 RSI: 00005652d0e41bd0 RDI: 00005652d0e41bb0
[10800.704255] RBP: 00005652d0e41960 R08: 0000000000000000 R09: 00005652d0e448e0
[10800.704257] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[10800.704258] R13: 00005652d0e41bb0 R14: 00005652d0e41b90 R15: 00005652d0e41960
[10800.704261] XFS (sdb2): Corruption detected. Unmount and run xfs_repair
[10800.704264] XFS (sdb2): log has mismatched uuid - can't recover
[10800.704266] XFS (sdb2): xlog_header_check_dump:  SB : uuid = 9cc07df5-0c35-4b1b-9e2d-979ae7373659, fmt = 1
[10800.704269] XFS (sdb2):     log : uuid = 9cc07df5-0c35-4b1b-9e2d-979ae7373658, fmt = 1
[10800.704272] XFS (sdb2): failed to find log head
[10800.704273] XFS (sdb2): log mount/recovery failed: error -117
[10800.704423] XFS (sdb2): log mount failed
[10803.749443] XFS (sdb2): Mounting V5 Filesystem
[10803.761133] XFS (sdb2): Metadata corruption detected at xfs_agi_verify+0xee/0x1a0, xfs_agi block 0x2
[10803.761144] XFS (sdb2): Unmount and run xfs_repair
[10803.761146] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10803.761148] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 00 19 f9 c0  XAGI............
[10803.761150] 00000010: 00 00 00 40 00 00 00 01 00 00 00 01 00 00 00 3d  ...@...........=
[10803.761152] 00000020: 00 00 00 80 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10803.761153] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10803.761154] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10803.761156] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10803.761157] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10803.761158] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10803.761179] XFS (sdb2): metadata I/O error in "xfs_read_agi+0xa1/0x150" at daddr 0x2 len 1 error 117
[10803.761197] XFS (sdb2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117, agno 0
[10803.761202] XFS (sdb2): Failed to read root inode 0x80, error 117
[10805.782390] [U] + Fuzz uuid = add
[10807.691230] [U] + Fuzz uuid = sub
[10809.780039] [U] + Fuzz uuid = random
[10809.839465] XFS (sdb2): Mounting V5 Filesystem
[10809.845372] XFS (sdb2): Internal error !uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid) at line 259 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_header_check_mount+0x4e/0x110
[10809.845392] CPU: 31 PID: 1149906 Comm: mount Tainted: G           OE     5.12.0-rc2 #13
[10809.845396] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10809.845398] Call Trace:
[10809.845410]  dump_stack+0x7d/0x9c
[10809.845417]  xfs_corruption_error+0x81/0x90
[10809.845422]  ? xlog_header_check_mount+0x4e/0x110
[10809.845425]  xlog_header_check_mount+0x78/0x110
[10809.845428]  ? xlog_header_check_mount+0x4e/0x110
[10809.845431]  xlog_find_verify_log_record+0x127/0x2a0
[10809.845434]  xlog_find_head+0x1c4/0x470
[10809.845439]  xlog_find_tail+0x43/0x370
[10809.845442]  ? try_to_wake_up+0x257/0x5c0
[10809.845447]  xlog_recover+0x2f/0x160
[10809.845449]  ? xfs_trans_ail_init+0xbc/0xf0
[10809.845453]  xfs_log_mount+0x181/0x310
[10809.845456]  xfs_mountfs+0x468/0x940
[10809.845467]  xfs_fs_fill_super+0x3ac/0x760
[10809.845470]  get_tree_bdev+0x171/0x270
[10809.845476]  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
[10809.845479]  xfs_fs_get_tree+0x15/0x20
[10809.845482]  vfs_get_tree+0x2a/0xc0
[10809.845486]  path_mount+0x484/0xac0
[10809.845491]  __x64_sys_mount+0x108/0x140
[10809.845495]  do_syscall_64+0x38/0x90
[10809.845500]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10809.845505] RIP: 0033:0x7f278606cefe
[10809.845509] Code: 48 8b 0d 6d 8f 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 3a 8f 0c 00 f7 d8 64 89 01 48
[10809.845512] RSP: 002b:00007ffc5b8b6d98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[10809.845516] RAX: ffffffffffffffda RBX: 00007f278619a264 RCX: 00007f278606cefe
[10809.845519] RDX: 000055fb61a47b90 RSI: 000055fb61a47bd0 RDI: 000055fb61a47bb0
[10809.845520] RBP: 000055fb61a47960 R08: 0000000000000000 R09: 000055fb61a4a8e0
[10809.845529] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[10809.845530] R13: 000055fb61a47bb0 R14: 000055fb61a47b90 R15: 000055fb61a47960
[10809.845534] XFS (sdb2): Corruption detected. Unmount and run xfs_repair
[10809.845537] XFS (sdb2): log has mismatched uuid - can't recover
[10809.845538] XFS (sdb2): xlog_header_check_dump:  SB : uuid = c0e1e1e5-cb9b-28cb-dd64-6ea0d694f892, fmt = 1
[10809.845542] XFS (sdb2):     log : uuid = 9cc07df5-0c35-4b1b-9e2d-979ae7373658, fmt = 1
[10809.845546] XFS (sdb2): failed to find log head
[10809.845547] XFS (sdb2): log mount/recovery failed: error -117
[10809.845700] XFS (sdb2): log mount failed
[10812.810123] XFS (sdb2): Mounting V5 Filesystem
[10812.818920] XFS (sdb2): Metadata corruption detected at xfs_agi_verify+0xee/0x1a0, xfs_agi block 0x2
[10812.818940] XFS (sdb2): Unmount and run xfs_repair
[10812.818943] XFS (sdb2): First 128 bytes of corrupted metadata buffer:
[10812.818946] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 00 19 f9 c0  XAGI............
[10812.818956] 00000010: 00 00 00 40 00 00 00 01 00 00 00 01 00 00 00 3d  ...@...........=
[10812.818959] 00000020: 00 00 00 80 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10812.818961] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10812.818963] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10812.818965] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10812.818967] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10812.818969] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[10812.818991] XFS (sdb2): metadata I/O error in "xfs_read_agi+0xa1/0x150" at daddr 0x2 len 1 error 117
[10812.819008] XFS (sdb2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117, agno 0
[10812.819021] XFS (sdb2): Failed to read root inode 0x80, error 117
[10815.029962] [U] + Fuzz logstart = zeroes
[10815.088293] XFS (sdb2): filesystem is marked as having an external log; specify logdev on the mount command line.
[10815.088326] XFS (sdb2): SB validate failed with error -22.
[10815.613735] XFS (sdb2): Mounting V5 Filesystem
[10815.627429] XFS (sdb2): Ending clean mount
[10815.629459] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10815.630051] [U] ++ Try to write filesystem again
[10816.384228] XFS (sdb2): Unmounting Filesystem
[10818.978187] [U] + Fuzz logstart = ones
[10819.032752] XFS (sdb2): Mounting V5 Filesystem
[10819.033157] attempt to access beyond end of device
               sdb2: rw=6144, want=58491819577586169, limit=54474752
[10819.033162] XFS (sdb2): log recovery read I/O error at daddr 0x0 len 1 error -5
[10819.033176] XFS (sdb2): empty log check failed
[10819.033178] XFS (sdb2): log mount/recovery failed: error -5
[10819.033325] XFS (sdb2): log mount failed
[10819.550932] XFS (sdb2): Mounting V5 Filesystem
[10819.561480] XFS (sdb2): Ending clean mount
[10819.565601] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10819.566107] [U] ++ Try to write filesystem again
[10820.341495] XFS (sdb2): Unmounting Filesystem
[10822.637888] [U] + Fuzz logstart = firstbit
[10822.686002] XFS (sdb2): Mounting V5 Filesystem
[10822.697651] XFS (sdb2): resetting quota flags
[10822.697664] XFS (sdb2): Ending clean mount
[10822.702308] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10822.710365] XFS (sdb2): Unmounting Filesystem
[10823.373870] XFS (sdb2): Mounting V5 Filesystem
[10823.382313] XFS (sdb2): Ending clean mount
[10823.387357] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10823.387835] [U] ++ Try to write filesystem again
[10824.156907] XFS (sdb2): Unmounting Filesystem
[10826.780461] [U] + Fuzz logstart = middlebit
[10826.834444] XFS (sdb2): Mounting V5 Filesystem
[10826.836224] attempt to access beyond end of device
               sdb2: rw=6144, want=13972773937, limit=54474752
[10826.836230] XFS (sdb2): log recovery read I/O error at daddr 0x0 len 1 error -5
[10826.836238] XFS (sdb2): empty log check failed
[10826.836240] XFS (sdb2): log mount/recovery failed: error -5
[10826.836365] XFS (sdb2): log mount failed
[10827.376596] XFS (sdb2): Mounting V5 Filesystem
[10827.388235] XFS (sdb2): Ending clean mount
[10827.392379] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10827.392890] [U] ++ Try to write filesystem again
[10828.168312] XFS (sdb2): Unmounting Filesystem
[10830.498435] [U] + Fuzz logstart = lastbit
[10830.550299] XFS (sdb2): Mounting V5 Filesystem
[10830.665039] XFS (sdb2): Internal error hlen <= 0 || hlen > bufsize at line 2909 of file fs/xfs/xfs_log_recover.c.  Caller xlog_valid_rec_header+0x126/0x160
[10830.665056] CPU: 23 PID: 1156261 Comm: mount Tainted: G           OE     5.12.0-rc2 #13
[10830.665060] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10830.665071] Call Trace:
[10830.665076]  dump_stack+0x7d/0x9c
[10830.665082]  xfs_corruption_error+0x81/0x90
[10830.665087]  ? xlog_valid_rec_header+0x126/0x160
[10830.665090]  xlog_valid_rec_header+0x151/0x160
[10830.665092]  ? xlog_valid_rec_header+0x126/0x160
[10830.665094]  xlog_do_recovery_pass+0x39f/0x7b0
[10830.665097]  ? xlog_alloc_buffer+0xd1/0xe0
[10830.665101]  xlog_verify_tail+0xa1/0x1a0
[10830.665104]  xlog_verify_head+0xcd/0x1a0
[10830.665107]  xlog_find_tail+0x2aa/0x370
[10830.665110]  xlog_recover+0x2f/0x160
[10830.665112]  xfs_log_mount+0x181/0x310
[10830.665116]  xfs_mountfs+0x468/0x940
[10830.665120]  xfs_fs_fill_super+0x3ac/0x760
[10830.665131]  get_tree_bdev+0x171/0x270
[10830.665137]  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
[10830.665139]  xfs_fs_get_tree+0x15/0x20
[10830.665142]  vfs_get_tree+0x2a/0xc0
[10830.665146]  path_mount+0x484/0xac0
[10830.665151]  __x64_sys_mount+0x108/0x140
[10830.665154]  do_syscall_64+0x38/0x90
[10830.665159]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10830.665163] RIP: 0033:0x7fd937888efe
[10830.665166] Code: 48 8b 0d 6d 8f 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 3a 8f 0c 00 f7 d8 64 89 01 48
[10830.665169] RSP: 002b:00007ffc21d766a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[10830.665172] RAX: ffffffffffffffda RBX: 00007fd9379b6264 RCX: 00007fd937888efe
[10830.665174] RDX: 000055b073c4bb90 RSI: 000055b073c4bbd0 RDI: 000055b073c4bbb0
[10830.665176] RBP: 000055b073c4b960 R08: 0000000000000000 R09: 000055b073c4e8e0
[10830.665177] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[10830.665179] R13: 000055b073c4bbb0 R14: 000055b073c4bb90 R15: 000055b073c4b960
[10830.665182] XFS (sdb2): Corruption detected. Unmount and run xfs_repair
[10830.665194] XFS (sdb2): failed to locate log tail
[10830.665196] XFS (sdb2): log mount/recovery failed: error -117
[10830.665374] XFS (sdb2): log mount failed
[10831.192081] XFS (sdb2): Mounting V5 Filesystem
[10831.204794] XFS (sdb2): Ending clean mount
[10831.209854] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
[10831.210452] [U] ++ Try to write filesystem again
[10832.074468] XFS (sdb2): Unmounting Filesystem
[10834.336322] [U] + Fuzz logstart = add
[10834.385491] XFS (sdb2): Mounting V5 Filesystem
[10834.394175] XFS (sdb2): Log inconsistent (didn't find previous header)
[10834.394180] XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 435
[10834.394201] ------------[ cut here ]------------
[10834.394202] kernel BUG at fs/xfs/xfs_message.c:110!
[10834.394210] invalid opcode: 0000 [#1] SMP NOPTI
[10834.394214] CPU: 0 PID: 1157634 Comm: mount Tainted: G           OE     5.12.0-rc2 #13
[10834.394218] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[10834.394220] RIP: 0010:assfail+0x27/0x2d
[10834.394233] Code: 0b 5d c3 0f 1f 44 00 00 55 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 d0 36 01 87 48 89 e5 e8 79 f9 ff ff 80 3d 2c 68 3b 01 00 74 02 <0f> 0b 0f 0b
5d c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89
[10834.394236] RSP: 0018:ffffb588d735bbc0 EFLAGS: 00010202
[10834.394240] RAX: 0000000000000000 RBX: 00000000000065b0 RCX: 0000000000000000
[10834.394242] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff86fa8dcf
[10834.394244] RBP: ffffb588d735bbc0 R08: 0000000000000000 R09: 000000000000000a
[10834.394246] R10: 000000000000000a R11: f000000000000000 R12: ffff9c7feb33fe00
[10834.394248] R13: ffff9c7e7a7f6800 R14: ffff9c7feb340000 R15: 00000000ffffff8b
[10834.394250] FS:  00007f7dc1152800(0000) GS:ffff9c853f600000(0000) knlGS:0000000000000000
[10834.394253] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10834.394255] CR2: 00007ffd2ebebfc8 CR3: 0000000189e12000 CR4: 00000000000506f0
[10834.394260] Call Trace:
[10834.394264]  xlog_find_verify_log_record+0x21d/0x2a0
[10834.394270]  xlog_find_head+0x1c4/0x470
[10834.394275]  xlog_find_tail+0x43/0x370
[10834.394278]  ? try_to_wake_up+0x257/0x5c0
[10834.394283]  xlog_recover+0x2f/0x160
[10834.394292]  ? xfs_trans_ail_init+0xbc/0xf0
[10834.394295]  xfs_log_mount+0x181/0x310
[10834.394299]  xfs_mountfs+0x468/0x940
[10834.394303]  xfs_fs_fill_super+0x3ac/0x760
[10834.394306]  get_tree_bdev+0x171/0x270
[10834.394311]  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
[10834.394314]  xfs_fs_get_tree+0x15/0x20
[10834.394318]  vfs_get_tree+0x2a/0xc0
[10834.394322]  path_mount+0x484/0xac0
[10834.394326]  __x64_sys_mount+0x108/0x140
[10834.394330]  do_syscall_64+0x38/0x90
[10834.394335]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10834.394338] RIP: 0033:0x7f7dc13a6efe
[10834.394342] Code: 48 8b 0d 6d 8f 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 3a 8f 0c 00 f7 d8 64 89 01 48
[10834.394350] RSP: 002b:00007ffd2ebed0a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[10834.394353] RAX: ffffffffffffffda RBX: 00007f7dc14d4264 RCX: 00007f7dc13a6efe
[10834.394355] RDX: 0000561878e65b90 RSI: 0000561878e65bd0 RDI: 0000561878e65bb0
[10834.394357] RBP: 0000561878e65960 R08: 0000000000000000 R09: 0000561878e688e0
[10834.394358] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[10834.394360] R13: 0000561878e65bb0 R14: 0000561878e65b90 R15: 0000561878e65960
[10834.394363] Modules linked in: dm_delay dm_zero dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio dm_flakey vboxvideo drm_vram_helper
drm_ttm_helper intel_rapl_msr intel_rapl_common binfmt_misc nls_iso8859_1 amd_energy crct10dif_pclmul ghash_clmulni_intel snd_intel8x0 aesni_intel
snd_ac97_codec crypto_simd cryptd ac97_bus snd_pcm nfsd snd_seq_midi snd_seq_midi_event snd_rawmidi sch_fq_codel snd_seq joydev snd_seq_device snd_timer snd
vmwgfx auth_rpcgss input_leds mac_hid vboxguest(OE) serio_raw soundcore nfs_acl lockd ttm drm_kms_helper grace cec rc_core sunrpc drm fb_sys_fops syscopyarea
sysfillrect sysimgblt parport_pc ppdev lp parport ip_tables x_tables autofs4 hid_generic usbhid hid ahci psmouse e1000 crc32_pclmul libahci i2c_piix4 video
pata_acpi [last unloaded: scsi_debug]
[10834.394441] ---[ end trace 48baa14fc702f45b ]---
[10834.394443] RIP: 0010:assfail+0x27/0x2d
[10834.394447] Code: 0b 5d c3 0f 1f 44 00 00 55 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 d0 36 01 87 48 89 e5 e8 79 f9 ff ff 80 3d 2c 68 3b 01 00 74 02 <0f> 0b 0f 0b
5d c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89
[10834.394449] RSP: 0018:ffffb588d735bbc0 EFLAGS: 00010202
[10834.394451] RAX: 0000000000000000 RBX: 00000000000065b0 RCX: 0000000000000000
[10834.394453] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff86fa8dcf
[10834.394455] RBP: ffffb588d735bbc0 R08: 0000000000000000 R09: 000000000000000a
[10834.394457] R10: 000000000000000a R11: f000000000000000 R12: ffff9c7feb33fe00
[10834.394458] R13: ffff9c7e7a7f6800 R14: ffff9c7feb340000 R15: 00000000ffffff8b
[10834.394461] FS:  00007f7dc1152800(0000) GS:ffff9c853f600000(0000) knlGS:0000000000000000
[10834.394463] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10834.394465] CR2: 00007ffd2ebebfc8 CR3: 0000000189e12000 CR4: 00000000000506f0

Darrick,

Is this the same error you are seeing?

Here is the latest version of this patch, with a couple of fixes (I found a couple of bugs yesterday):

https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/commit/?h=testing/xfs-fixed

I have run it on 5.12-rc2 and I see the same error with xfs/350 (the same error as on 5.12-rc2
without my changes). So, I'm not sure if this is somehow expected.

I'm running my tests on virtualbox with two partitions (test and scratch) of 25gb each.

I'm now going to run the fstests on 5.12-rc6. I'll send my results later.

Thanks
--
Gustavo
