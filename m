Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DBCC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 14:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhLIPAX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Dec 2021 10:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239004AbhLIPAX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Dec 2021 10:00:23 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C8BC061746
        for <linux-xfs@vger.kernel.org>; Thu,  9 Dec 2021 06:56:49 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id b40so12439518lfv.10
        for <linux-xfs@vger.kernel.org>; Thu, 09 Dec 2021 06:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=wjIA4p4z5npV//i86WYjBl12uEZWuAVQuQj88TnBId0=;
        b=gbWm2iH/iaDkx2zqwmfg2yzlYYn7RKQYXTHqIIDIm8Y05dUbmmd/kup8v9pxQn7Axg
         uo9G1vZOn9UzZ8nwbx78p/qGz4P/6KLmJfnc+e34nAiD2xdAYpXFB+FXv3xCLs2kvsXL
         rFsE1+s0RzcpohXxl5JBP+/5ZJP2biharCsgWWez+f4pQYLo0M2dd71v0A0SMXLUS0rd
         zYXUnrxS4x6NAnZ4RM3J7FR9ZUm5b9VmUUvvFwawKMZKtODQYQsEhbDAHzY0spfQLWmS
         B7+pl+wj1EzoeKSEnV5Jx5DlO4b65TKYKcqPkBKL78d+7FY5Skx9+WDZuF6WhLPZWCDT
         tKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wjIA4p4z5npV//i86WYjBl12uEZWuAVQuQj88TnBId0=;
        b=U9+wx94UfKAezkYrVN7d1tfH2zIFKMbGRjvUHWeksintfWEqPL5sfaALkGlYuBioIX
         XySI0sFEjDQ2BzpMRjEhBjHsWeAaiyVEqtEa/CtISSJnduspNaJPVR749mo89zMwM24z
         iJMQXHIvqUk+p0HBQxdv0XBIhc7nqpmUGTCGsmMrYseqi4WTZtCMD6qSUiADMst6Xi3t
         mwDG8Xf6z1e6KBbukK0FhstDJXgfpX3ZctSoiU/ikEx20DXfZRycqV1VhONPRGklOrej
         qxoZvnOIlLWVrhXTirxthM5cWINdfsswMQ3xLAkW01Rs+WqI6e0mhOtsFvUNRNWigYFI
         DDvw==
X-Gm-Message-State: AOAM533qHJBUMsuQc6qpm2BusLd5gRjFQyu9PmB86GtjRnRv7iWi+r37
        uvqnsFonr/91hHqMc1+KznKBeGu2oeo=
X-Google-Smtp-Source: ABdhPJy/XzxpcPN3KzK26hlS2OBqBaTWjGxSvB4wDX7orTk6y7a0j4ClghJZZWK3v7utnExLxxIE4w==
X-Received: by 2002:a05:6512:e9f:: with SMTP id bi31mr1695241lfb.14.1639061807257;
        Thu, 09 Dec 2021 06:56:47 -0800 (PST)
Received: from [192.168.68.135] (user-94-254-232-26.play-internet.pl. [94.254.232.26])
        by smtp.gmail.com with ESMTPSA id l24sm5000ljg.35.2021.12.09.06.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 06:56:46 -0800 (PST)
Message-ID: <054e4e59-a585-5375-e80b-5db3ade2f633@gmail.com>
Date:   Thu, 9 Dec 2021 15:56:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: VMs getting into stuck states since kernel ~5.13
Content-Language: pl
To:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>
References: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
In-Reply-To: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

W dniu 08.12.2021 o 19:54, Chris Murphy pisze:
> Hi,
> 
> I'm trying to help progress a kernel regression hitting Fedora
> infrastructure in which dozens of VMs run concurrently to execute QA
> testing. The problem doesn't happen immediately, but all the VM's get
> stuck and then any new process also gets stuck, so extracting
> information from the system has been difficult and there's not a lot
> to go on, but this is what I've got so far.

Does qemu there have this fix?

https://github.com/qemu/qemu/commit/cc071629539dc1f303175a7e2d4ab854c0a8b20f

block: introduce max_hw_iov for use in scsi-generic
Linux limits the size of iovecs to 1024 (UIO_MAXIOV in the kernel
sources, IOV_MAX in POSIX).  Because of this, on some host adapters
requests with many iovecs are rejected with -EINVAL by the
io_submit() or readv()/writev() system calls.

In fact, the same limit applies to SG_IO as well.  To fix both the
EINVAL and the possible performance issues from using fewer iovecs
than allowed by Linux (some HBAs have max_segments as low as 128),
introduce a separate entry in BlockLimits to hold the max_segments
value from sysfs.  This new limit is used only for SG_IO and clamped
to bs->bl.max_iov anyway, just like max_hw_transfer is clamped to
bs->bl.max_transfer.


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
