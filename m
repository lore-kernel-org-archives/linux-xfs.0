Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4401DC004D4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 07:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjARHhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 02:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjARHgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 02:36:38 -0500
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D0D5DC01;
        Tue, 17 Jan 2023 22:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1674024929; i=@fujitsu.com;
        bh=QM3Bkd6tkhrEWZxgsL5X9rl00CmozpUJ4kJ7nkez1NA=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=y3XvXfaKV9wVy8dByOFqF4GTHu0CE3FmF35c514fvKDUWNEJulzHS/CtpRT/eSi/d
         x9ZAR2jwjGN9DS5Lc+ELV2Z1i7VfLvvwabAot/HMklM+pTsmBWzP+8yJRdlFTG8hKQ
         PMK6yNhoF2nr+N+OXuFZL1azZj0JQoajaZZ/FYDOX7njXvgIpw3RjcqY/F03rgyvPg
         F/d3WmiskDnyNoUr1Qo7vhL47pPFBVnzB6hUc+mWLZbv/O/Wo5KUV6RtvmK8uGFiHR
         KYZIX7dw6ArVEnpl0KKw4ZVBDqwui7quWISwnxWvSjkHEI2peXLz6Cim9kjGSwdjGC
         kjaXdsYQWDv3Q==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleJIrShJLcpLzFFi42Kxs+HYrPtg+vF
  kg4drVCwuP+GzON2yl93i77k37Ba7/uxgt9h7cierA6vH+asqHptWdbJ5vN93lc3j8ya5AJYo
  1sy8pPyKBNaMm1ffMBZM4KiY+aeNtYHxLlsXIxeHkMBGRokbLbvYIZwlTBLHbu1l7WLkBHK2M
  0r0ngeyOTh4Bewklq8qAQmzCKhKzJv9khnE5hUQlDg58wkLiC0qkCRxdcNdsFZhoPIb81aD1Y
  gI2ErMbPsEZjMLeEncWnCNCWJXI6PE/im9YAk2ATWJndNfgg3iFHCTeHxuE1SDhcTiNwfZIWx
  5ie1v54DFJQQUJdqW/GOHsCslWj/8YoGw1SSuAvVOYBSaheS+WUhGzUIyagEj8ypG0+LUorLU
  Il1LvaSizPSMktzEzBy9xCrdRL3UUt3y1OISXSO9xPJivdTiYr3iytzknBS9vNSSTYzAWEkpV
  lfdwXhu2R+9Q4ySHExKoryvY48nC/El5adUZiQWZ8QXleakFh9ilOHgUJLgNZ4IlBMsSk1PrU
  jLzAHGLUxagoNHSYQ3dDJQmre4IDG3ODMdInWK0ZhjbcOBvcwcH/9c3MssxJKXn5cqJc77fhp
  QqQBIaUZpHtwgWDq5xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUUmYtxRkCk9mXgncvldApzAB
  neJRchTklJJEhJRUA9MKPVnr67vtXp8J1j72KHvL5d2HZhX7tgv5BDy4w5v2aCIX+7Fr3nKvW
  S2y937+K7Q+j/e0zBu790wKn6fLKHE+SzM+4Wtpl75H+U3aXa2GHW2z5kbuXylzZd2Jpg21xq
  c4vFfNPHt098p7H7P7Zken7FapuyjXxuKw1S/14D6LjvIK77nT95x1rOOoYFPsdzv0VYPfLOh
  T4HKb2I2aC1/Z+PBJnDxxQUyoeZ+xUpjYNKHJLLyy/UUGq+r27lo457HIOubEGa/sDmafzsn+
  +V+/+oC1Ra6B7R/WHVPMnFwu8L9Q4T7yj11I9Ov0Rz7TTv/ib/8vctXbcfKnvMdu/7bLVaj95
  xC1W3BgVU4HQ5QSS3FGoqEWc1FxIgB1hvKgogMAAA==
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-5.tower-571.messagelabs.com!1674024928!470086!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.102.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 27290 invoked from network); 18 Jan 2023 06:55:28 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-5.tower-571.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jan 2023 06:55:28 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id 4652D150;
        Wed, 18 Jan 2023 06:55:28 +0000 (GMT)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id 3A75173;
        Wed, 18 Jan 2023 06:55:28 +0000 (GMT)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Wed, 18 Jan 2023 06:55:25 +0000
Message-ID: <c59abe2c-9c2f-1181-480e-40222b1f6886@fujitsu.com>
Date:   Wed, 18 Jan 2023 14:55:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/3] xfs: fix dax inode flag test failures
To:     "Darrick J. Wong" <djwong@kernel.org>, <zlang@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        <guan@eryu.me>
References: <167400102444.1914858.13132645140135239531.stgit@magnolia>
 <167400102458.1914858.6889539595788984119.stgit@magnolia>
From:   Xiao Yang <yangx.jy@fujitsu.com>
In-Reply-To: <167400102458.1914858.6889539595788984119.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

It looks good to me.
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>

Best Regards,
Xiao Yang

On 2023/1/18 8:42, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Filter out the DAX inode flag because it's causing problems with this
> test.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/xfs/128 |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/128 b/tests/xfs/128
> index 5591342d41..8c1663c6c5 100755
> --- a/tests/xfs/128
> +++ b/tests/xfs/128
> @@ -81,7 +81,7 @@ c13=$(_md5_checksum $testdir/file3)
>   c14=$(_md5_checksum $testdir/file4)
>   
>   echo "Defragment"
> -lsattr -l $testdir/ | _filter_scratch | _filter_spaces
> +lsattr -l $testdir/ | _filter_scratch | _filter_spaces | sed -e 's/DAX/---/g'
>   $XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
>   $XFS_FSR_PROG -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
>   $XFS_FSR_PROG -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
> 
