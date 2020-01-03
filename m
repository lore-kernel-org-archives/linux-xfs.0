Return-Path: <SRS0=vgQ5=2Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70D6C00523
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 07:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A82A024649
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 07:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWD0Vd/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgACHEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 02:04:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38592 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725890AbgACHEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jan 2020 02:04:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578035085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=THuDoKQqA9mopRaf/n+nc9pFYs6eHChZ96kWbH3oCVk=;
        b=VWD0Vd/6E0nw8s6VzcgUM4TtmeS3+EXZYrRPgpcsQTittsxofJXflTixEj1NxlvNyrM4GJ
        PJhcNA8y3GzMmV4Wok8dTWq1yN2wyjfvkphK85ujyl1QFItM1hKFOZV2hdzO5MoKTC5Nhu
        FdXDgzhyixl0MAy625momfg7mW6VT2Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-aFrdj_0sNxuTtf4HcQUCNw-1; Fri, 03 Jan 2020 02:04:43 -0500
X-MC-Unique: aFrdj_0sNxuTtf4HcQUCNw-1
Received: by mail-wr1-f71.google.com with SMTP id v17so21071852wrm.17
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jan 2020 23:04:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=THuDoKQqA9mopRaf/n+nc9pFYs6eHChZ96kWbH3oCVk=;
        b=X+uyIy50Hy86rocwbx2DU91J64wnmly73Nibov3aioDEBu8/Css8KcRPljJsnFltNu
         zfbscCdbnmNoVupdFJVCYHvsH7B+hKWasBafp2g/6JB4ZIcXwOPGCfn/ochWsvL+pe/R
         oY/UiHhFmH/c1HOOOcU/IQuBhHXGtqh2PsGr5tu6+1ZtmHqcrnnMcFK8c68eCbbvjZiL
         7+41Xg9Y8z/fXemmVrcStkvImRJGZIG+RbXIMDClKhF5MoS/MlJREdXf/CFuTtf7qh2n
         tdRs0QOhjfZRADfohp0ecKUYhjEgvoBFjvsy+4rzxd3q3PleLIzjxijRc8Msw2fWKfY1
         ysew==
X-Gm-Message-State: APjAAAX1WbG+B2/3MMOaxCwq0Xxq2c2ggLOjNj8uI3xWeECUdMETtQ5B
        MrLnOYKbgLXlWkrNNPhhYMKFqRhDq014DzFtyo0pQ6uDVIyAnbsgtYJOUi744360oSdiHLli/vR
        jWtXtDoP3hB7oS63CODQ0
X-Received: by 2002:adf:ee92:: with SMTP id b18mr90049409wro.281.1578035082070;
        Thu, 02 Jan 2020 23:04:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqyF0Rgs3ugj89OPgtf+yS9tl4S4TZ5VTFM3d3DbAQZ0geyEskLRC5WRoJmBBuj/DjZH2tus8g==
X-Received: by 2002:adf:ee92:: with SMTP id b18mr90049378wro.281.1578035081775;
        Thu, 02 Jan 2020 23:04:41 -0800 (PST)
Received: from orion.redhat.com (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id n187sm11133414wme.28.2020.01.02.23.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 23:04:41 -0800 (PST)
Date:   Fri, 3 Jan 2020 08:04:38 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Daniel Storey <daniel.storey202@gmail.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_repair: superblock read failed, fatal error -- Input/output
 error
Message-ID: <20200103070438.wnyo3a6ubdccptz7@orion.redhat.com>
Mail-Followup-To: Daniel Storey <daniel.storey202@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <FF3D9678-1449-467B-AA27-DA8C4B6A6DA2@rededucation.com>
 <379BEB4C-D422-4EE8-8C1C-CDF8AA3016E0@rededucation.com>
 <6C0FFC4B-AE04-4C97-87FF-BD86E610F549@rededucation.com>
 <0D8F4E6F-CA2E-4032-BFD5-E87F651E2585@rededucation.com>
 <20200102160807.dsoozldhtq7glw6z@orion.redhat.com>
 <MN2PR07MB59347B8FC6B9E92D0107D9A1A4200@MN2PR07MB5934.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR07MB59347B8FC6B9E92D0107D9A1A4200@MN2PR07MB5934.namprd07.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Daniel.

>     Also on a vmware machine? On the same hypervisor? For sure not on the same host,
>     since UFS explorer (AFAIK) does not have a Linux version.
> 
> It does, actually (have a Linux version).  I'm running it on the same host.

Oh, I didn't know that, thanks for the information.


>     
>     And btw, UFS Explorer is built so that you can scan/recover data on very damaged
>     filesystems and disks, while filesystems won't let you mount a corrupted
>     filesystem to avoid doing even more damage. So, yeah, you might still see
>     filesystem data/metadata using UFS explorer with damaged filesystems or block
>     devices.
>     
> Okay.

Just adding to the information above, UFS (and basically most of the disaster
recovery tools), will ignore IO errors as much as it can, as an attempt to read
as much data as possible from the failing devices.

>     
>     So, again, I'd try to open these devices on a bare-metal machine and check the
>     device for errors. If the errors are still present, replace the devices.
>     
> Ok - I'll try opening these devices on a bare-metal (not a VMware host) and check them for errors. What do I do if there are no errors present?  As the SMART check revealed no problems with the disks.
> 

I did another look into the dmesg output you provided, and:

>     > [52819.637179] Buffer I/O error on dev dm-4, logical block 1610612731, async page read

This is an I/O error even below the vdo driver, so as much as XFS is only the
victim here, I am inclined to say again VDO is also one more victim here of a
failing device, even though I don't know much details about VDO driver.

So you really need to check your storage stack to know where the errors might
be.

The HDD itself, the storage enclosure, usb cable, VMWare hypervisor, etc. I
really can't say, I couldn't spot any errors pointing to anything specific other
than generic I/O errors, which essentially means kernel failed to issue I/O
commands to your device. It will require some investigation to determine where
the error lies, that's why I suggested plugging the usb HDD into a bare-metal
machine, so you can start by better isolating the problem.

But XFS there is just the messenger there of some problem with your device or
storage stack.

Cheers.

-- 
Carlos

