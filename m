Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791D2C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 03:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiBHDro (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 22:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245562AbiBHDrn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 22:47:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12975C0401E5
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 19:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644292062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klT/53A8c1bUi4id9s+Y7XAoQNoZYJUAjOGBvUpz/BA=;
        b=iIAvjtQMRtFfVCQ+dDA2K1LZBUiXDpp5efCg6x0B7jCwqV10A56CJmbeyTPnw6Me2b6qHD
        ecdXZRC3YBg037fZ/KkEKiz8AG8NT0vS4GiJdPHP2CspiMOT55dBrn2+rAq6TiHJHtArVb
        ByPsmuwqeQv8z+hlNXqhPM3Vdcun/EY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-Q3I_cMkmNpCB5ZywneDDCQ-1; Mon, 07 Feb 2022 22:47:40 -0500
X-MC-Unique: Q3I_cMkmNpCB5ZywneDDCQ-1
Received: by mail-il1-f197.google.com with SMTP id g14-20020a056e021e0e00b002a26cb56bd4so10398832ila.14
        for <linux-xfs@vger.kernel.org>; Mon, 07 Feb 2022 19:47:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=klT/53A8c1bUi4id9s+Y7XAoQNoZYJUAjOGBvUpz/BA=;
        b=CfkTcQF6P1o3NYtuWxTTC+Tuhmr8PetqT01BzJSLnmrjUTUvty9z69k8sztmZjM/0A
         zB1KQDyaj3TQRng3+rcP/Pkxn5SwOCV/QcUpyQYLHyzUdTMFI2fbJPm71Y/t+nlfVVL1
         xBpeTArvYCNjIND8ThQd3YytDnfjxOsMvUA08xVzHgcvg6vL5SZmcdSE36q0mZM6OQuU
         8O6GgKIiRYYIcDsgnDJFDXwR3sLuIKnFDWMyvRl9VNe3FWLQCiG7tdtDsGjDczdGy6H2
         MwAm6mxR6LZtumj0NAbJrYNnbakw8pDSVvZ35kDhW1761zDlcrMxBD0FBISFTBYDPmgq
         ufGg==
X-Gm-Message-State: AOAM531onwlvJwMmJeGz/8C3KCbYUzXC3DVpTOUi5qGmYu+Ns1znRXtm
        skhF2DtcU+DT++EZ6JhoAOXnQiTi5G9tV47JkNVb1vV7Cw22H8JCIdfPbhW4eNwXAiIY4ngBcyk
        POEZ4lujibyoPqhb/lznN
X-Received: by 2002:a05:6638:10e6:: with SMTP id g6mr1243702jae.135.1644292059991;
        Mon, 07 Feb 2022 19:47:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxz8ek82XvrcPJluU5iW4dr+8wfTkSybYlCZNgoPXLk0cKqZiIXDixltq9BZgfRikp5SZ4xng==
X-Received: by 2002:a05:6638:10e6:: with SMTP id g6mr1243699jae.135.1644292059762;
        Mon, 07 Feb 2022 19:47:39 -0800 (PST)
Received: from [10.0.0.147] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id u8sm6538011ilb.39.2022.02.07.19.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 19:47:39 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <6e68c345-8f08-7c16-107e-9e9dacc4f385@redhat.com>
Date:   Mon, 7 Feb 2022 21:47:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: Any guide to replace a xfs logdev?
Content-Language: en-US
To:     Wang Yugui <wangyugui@e16-tech.com>, linux-xfs@vger.kernel.org
References: <20220208112322.E7D4.409509F4@e16-tech.com>
In-Reply-To: <20220208112322.E7D4.409509F4@e16-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/7/22 9:23 PM, Wang Yugui wrote:
> Hi,
> 
> Any guide to replace a xfs logdev?
> 
> case 1: logdev device failed.
> case 2: replace the logdev with a new NVDIMM-N device.
> 
> but I failed to find out some guide to  replace a xfs logdev.

The external log is specified at mount time on the mount command line,
so all you should need to do is use the "-o logdev=/dev/XXX" option
to point at the new device, which must be at least as large as the old
device, and should be completely zeroed.

If the filesystem was cleanly unmounted, this should be all that is required.

If the log device failed during operation, the filesystem is probably
not consistent, and you will most likely need to run an xfs_repair,
zeroing out the log and repairing any inconsistencies, since your log
device has failed and no longer replayable. So, something like:

# xfs_repair -L -l /dev/newlogdevice /dev/xfsdevice

where /dev/xfsdevice is your data device holding the filesystem,
and /dev/newlogdevice is your new/replaced log device.

Before you actually do this, you might want to see if anyone corrects
my statements or notices anything I missed. ;)

-Eric

> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2022/02/08
> 
> 
> 

