Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5C8C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 05:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjARFNt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 00:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjARFNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 00:13:47 -0500
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF3B4FCC4;
        Tue, 17 Jan 2023 21:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1674018825; i=@fujitsu.com;
        bh=MHzST+uoBWBeoXgiQziOA51qFjMbDUiDZhahHL79+MA=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=LJwt6estj34PgE01TipNiwZHhQY/07DEd9wLw0fdwrqknS1htyaZa1fSfRL2nhcXb
         evn1UtjMS6lpGXogPiluQJIbQHo99AYs5zW4XroZpo7UXhoKWuZ761oEcR6EEDxrsZ
         wyi6Gzx4k7XGKfq6BGIr+1Tb0nSMHwf+9cPnXGDJ64TdoRfDzRU2HsmzhCpJsooXnX
         XYMSg7M2ulMCGjzQ7qEbvq+0YoW2VXnLC5N3H8XkU3xAMUs3o9vP0aPyPFifIFwsWG
         qhMS7DKtOZzA71A0+ilwmNTsZ74xOAErz0JE+8UxOGLLHhQNaFnGRgF3mmAj+Cv0yW
         jz3vq+jHlsJ6w==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRWlGSWpSXmKPExsViZ8ORqMvRcDz
  ZYPMvIYvLT/gsTrfsZbf4e+4Nu8WuPzvYLfae3MnqwOpx/qqKx6ZVnWwe7/ddZfP4vEkugCWK
  NTMvKb8igTWjf0lAwRypisnN9xgbGA+LdjFycggJbGGUuNDr0MXIBWSvYJJ4e38+I0RiO6PEh
  NksIDavgJ3Eom+32UFsFgFVidaju9kg4oISJ2c+AasRFUiSuLrhLiuILSzgLHGnuRVsjoiArc
  TMtk/MIDazgJfErQXXmCCWNTJKnF79CqyZTUBNYuf0l2A2p4CbxPH711khGiwkFr85yA5hy0t
  sfzsHbJCEgKJE25J/7BB2pUTrh18sELaaxNVzm5gnMArNQnLfLCSjZiEZtYCReRWjWXFqUVlq
  ka6hmV5SUWZ6RkluYmaOXmKVbqJeaqlueWpxia6RXmJ5sV5qcbFecWVuck6KXl5qySZGYKykF
  Ctu3cF4Y9kfvUOMkhxMSqK8r2OPJwvxJeWnVGYkFmfEF5XmpBYfYpTh4FCS4L1RC5QTLEpNT6
  1Iy8wBxi1MWoKDR0mE92QFUJq3uCAxtzgzHSJ1itGSY9vnfXuZOdY2HACSH/9c3MssxJKXn5c
  qJc57sw6oQQCkIaM0D24cLLVcYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTM+wtkCk9mXgnc
  1ldABzEBHeRRchTkoJJEhJRUA1ODWEawbyyHdcb2kwdrLtss57i2cvVjFRZBLmfDxhv2M8tfM
  MldFVv6suTY7hjuQ49uXE3WmLI95cr1AoulX0qiUnzDpxZz1v8rSNdV+T1jUt2TLPfgyeJZBq
  FPMibocZW2sHtqBK+zbnv37mDn2ogbgccYRa5ITiydrPo4UEFK/dPjudI9k9+LcfCyXhSxftt
  4x3L1iXW5sxbt5diXcrF/1Z7b0r/Wnqk/rzVtaeHqa5lWrlIHKg/EJbw8nKqjHHPOfckvhWmP
  Zu+p5lvVttfDnP3EoxRmVSPGIGHVbL2y7tUX9j/h6am415b1frPL1TPXn2W3NRSqqe/Tiun2f
  LJv4/v/Id96GKxDCmYnMCixFGckGmoxFxUnAgDGG7BoqAMAAA==
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-7.tower-571.messagelabs.com!1674018824!467380!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.102.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23787 invoked from network); 18 Jan 2023 05:13:44 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-7.tower-571.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jan 2023 05:13:44 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id F2FD210018D;
        Wed, 18 Jan 2023 05:13:43 +0000 (GMT)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id E5C38100195;
        Wed, 18 Jan 2023 05:13:43 +0000 (GMT)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Wed, 18 Jan 2023 05:13:41 +0000
Message-ID: <dcb548b0-0050-77a7-7b66-a483cb4c8046@fujitsu.com>
Date:   Wed, 18 Jan 2023 13:13:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] xfs/182: fix spurious direct write failure
To:     "Darrick J. Wong" <djwong@kernel.org>, <zlang@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        <guan@eryu.me>
References: <167400102444.1914858.13132645140135239531.stgit@magnolia>
 <167400102485.1914858.8399289411855614483.stgit@magnolia>
From:   Xiao Yang <yangx.jy@fujitsu.com>
In-Reply-To: <167400102485.1914858.8399289411855614483.stgit@magnolia>
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

It looks good to me. It actually fixed the failure of xfs/182 with 
enabled fsdax and reflink.
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>

Best Regards,
Xiao Yang

On 2023/1/18 8:42, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test has some weird behavior that causes regressions when fsdax and
> reflink are enabled.  The goal of this test is to set a cow extent size
> hint, perform some random directio writes, perform a directio rewrite of
> the entire file, and make sure that the file content (and extent count)
> are sane afterwards.
> 
> Most of the time, the random directio writes will never touch the
> 8388609th byte, though if they do randomly select that EOF block, they'd
> end up extending the file by $real_blksz bytes and causing spurious test
> failures.
> 
> Then, the rewrite does this:
> 
> pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))
> 
> Note that we previously set filesize=8388608, which means that we're
> asking for a series of direct writes that fill the first 8388608 bytes
> with 'c'.  The last write in the series becomes a single byte direct
> write.  For regular file access mode, this last write will fail with
> EINVAL, since block devices do not support byte granularity writes and
> XFS does not fall back to the pagecache for unaligned direct wites.
> Hence we never wrote the 8388609th byte of the file.
> 
> However, fsdax *does* allow byte-granularity direct writes, which means
> that the single-byte write succeeds.  There is no EINVAL return code,
> and the 8388609th byte of the file is now 'c' instead of 'a'.  As a
> result, the md5 of file2 is different.
> 
> Since fsdax+reflink is the newcomer, amend the direct writes in this
> test so that they always end at the 8388608th byte, since we were never
> really testing that last byte anyway.  This makes the test behavior
> consistent across both access modes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/xfs/182     |    4 ++--
>   tests/xfs/182.out |    1 -
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/xfs/182 b/tests/xfs/182
> index ec3f7dc026..696b933e60 100755
> --- a/tests/xfs/182
> +++ b/tests/xfs/182
> @@ -55,9 +55,9 @@ md5sum $testdir/file2 | _filter_scratch
>   
>   echo "CoW and unmount"
>   $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
> -$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((filesize + 1))" \
> +$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" \
>   	$testdir/file2 2>&1 >> $seqres.full | _filter_xfs_io_error
> -$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" \
> +$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $real_blksz 0 $filesize" \
>   	$testdir/file2 2>&1 >> $seqres.full | _filter_xfs_io_error
>   _scratch_cycle_mount
>   
> diff --git a/tests/xfs/182.out b/tests/xfs/182.out
> index 41384437ad..8821bcd5bd 100644
> --- a/tests/xfs/182.out
> +++ b/tests/xfs/182.out
> @@ -5,7 +5,6 @@ Compare files
>   2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file1
>   2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file2
>   CoW and unmount
> -pwrite: Invalid argument
>   Compare files
>   2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file1
>   c6ba35da9f73ced20d7781a448cc11d4  SCRATCH_MNT/test-182/file2
> 
