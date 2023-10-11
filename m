Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33458CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 20:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjJKUJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 16:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjJKUJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 16:09:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D0AAF
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 13:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697054931;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p07uv3VfqNYCu8gzNdk+z9OvzVunBM6VHOWnlS3vvR8=;
        b=cABg7sy4EFo0O+2R1F7DOBqwoXiN2NVYmEPiDyfVsgNaYgTXeEEVkaUQ+uyCMBfvK/WN/O
        /U4+QzW/eIR7apqqGW+o6UdoL3Mee5LbNDHVCGYM+q84Ld1kg0ow+WRuCOmpGKAqfEvWNm
        KmJB61hj2BaBi8MuePyfn7a9m04/Sc0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-ll-sF0P9OsmowmimOBid0A-1; Wed, 11 Oct 2023 16:08:50 -0400
X-MC-Unique: ll-sF0P9OsmowmimOBid0A-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-35742684eb0so994835ab.2
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 13:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697054929; x=1697659729;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p07uv3VfqNYCu8gzNdk+z9OvzVunBM6VHOWnlS3vvR8=;
        b=vtrrJnuIJhwgpNXdCrKI489j6mc3LHLqYpIqO9nq55OdlXmeCcNlTsjHcomFlwhwK/
         w1LrMQ1tuzQr8XfKRk0oiBv4j7BNgNPXneC31Kmnau0Rrsvo5XMK4utYBnzrP5GPLPFQ
         s4iHZZTPZtDra1an2GotVlM3G7BoAm31TMLHtYGG5bciqgEDvPFv3yb2IUY3D57NuLe0
         2w1qHXa+u8dOgNVg5nv4dw6Bd3za23+KTd3cnaedkh63J9apfqk23xlE2TDxGIQPsPRH
         0UPx8TX9xvE7mfrd3tBp/OJpDXHOsdXcyAQbraJUUiTxHculehdIxo5qevyTxNwhRVwJ
         x/zQ==
X-Gm-Message-State: AOJu0Yy4jm/W7Fqb7Gig2lu/oMhffnwfaaPR7j/YkoxQ5tBBdMpKUDyQ
        GL1Bmr5s+YWG73OnjL3no5nw5Le3eef+hkWOdORiGE/Bz6JPsdXh/1q+4p6shtoXwX9/+fI3r9t
        947BA8L08LgmM3oq6qHts
X-Received: by 2002:a92:d7cd:0:b0:34d:ee65:a8ca with SMTP id g13-20020a92d7cd000000b0034dee65a8camr22322873ilq.24.1697054929256;
        Wed, 11 Oct 2023 13:08:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEScCl6dk6MW+sVsBATxD3aPd21WlgR6b1Sm1y5VHtOWvNl8NWVimaRaZ8X/Huat+iSeWbBqA==
X-Received: by 2002:a92:d7cd:0:b0:34d:ee65:a8ca with SMTP id g13-20020a92d7cd000000b0034dee65a8camr22322866ilq.24.1697054928974;
        Wed, 11 Oct 2023 13:08:48 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id o9-20020a92d389000000b003574d091a7esm168325ilo.49.2023.10.11.13.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 13:08:48 -0700 (PDT)
Message-ID: <d211669e-96c9-6bd1-1578-574d6aa9812e@redhat.com>
Date:   Wed, 11 Oct 2023 15:08:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Reply-To: sandeen@redhat.com
Subject: Re: xfsprogs: bug feedback
Content-Language: en-US
To:     Nagisa BIOS <nagisa_bios@protonmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <UhgwTYrnwqvjARAbTicViFlwB7jumckp2WZwXoXAiKefRHO9XU46pADFybp14c1BTMWt8s4Ht0FY7aQq6QShFS7GUiScn1lwqo5Ytw0lUDo=@protonmail.com>
From:   Eric Sandeen <esandeen@redhat.com>
In-Reply-To: <UhgwTYrnwqvjARAbTicViFlwB7jumckp2WZwXoXAiKefRHO9XU46pADFybp14c1BTMWt8s4Ht0FY7aQq6QShFS7GUiScn1lwqo5Ytw0lUDo=@protonmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/11/23 1:07 PM, Nagisa BIOS wrote:
> Hi,
> 
> I found that if the xfs_fsr program defrag the large files, it may cause errors.
> 
> My recommend is, do not defrag the large files if the available disk space is not enough.

The only slight problem I really see here is that the "full filesystem
defrag" mode keeps trying and failing on the same file - a 21G file, on
a filesystem with only 15G free.

(xfs_fsr works by allocating new space, and moving data if the new space
is less fragmented than the original, then swapping extents from the new
inode to the old, and vice versa. If you're trying to defrag a file
which is larger than your available free space, it will fail.)

While full-filesystem defrag is rarely recommended, it might be nice to
not loop like this, and perhaps someone can look into that behavior.

On the other hand, the default is to keep trying for 2 hours and/or 10
passes, so perhaps this is working as designed. There are several
reasons a file might fail to be defragged, so stopping on failure may
not be desired.

-Eric

> Computer Setup (My Mini PC):
> 1135G7 CPU Mini PC
> 8GB DDR4 DRAM
> 500GB NVMe SSD
>  200GB NTFS Partition: Windows 11
>  200GB NTFS Partition
>  75GB  XFS Partition: Ubuntu (GNOME) 22.04
> 
> Pastebin:
> 
> ubuntu@minipc:~$ xfs_fsr -V
> xfs_fsr version 5.13.0
> 
> # nvme0n1p6 is XFS filesystem
> ubuntu@minipc:~$ sudo df -h
> Filesystem      Size   Used   Avail   Use%    Mounted
> tmpfs           772M   2.3M    770M     1%    /run
> /dev/nvme0n1p6   74G    55G    19G     75%    /
> tmpfs           3.8G      0    3.8G     0%    /dev/shm
> tmpfs           5.0M   4.0K    5.0M     1%    /run/lock
> tmpfs           3.8G      0    3.8G     0%    /run/qemu
> /dev/nvme0n1p1  256M    90M    167M    35%    /boot/efi
> tmpfs           772M   120K    772M     1%    /run/user/1000
> 
> # win10.qcow2 file size is 21GB
> ubuntu@minipc:~$ sudo ls -hs /var/lib/libvirt/images
> total 26G
> 2.5G debian12-1.qcow2   1.7G debian12-2.qcow2   34M win10-1.qcow2   34M win10-2.qcow2
> 21G win10.qcow2   595M win2003-1.qcow2   502M win2003.qcow2
> 
> # Loop and stuck
> ubuntu@minipc:~$ sudo xfs_fsr
> xfs_fsr -m /proc/mountfs -t 7200 -f /var/tmp/.fsrlast_xfs ...
> / start inode=151308975
> / start inode=0
> XFS_IOC_SWAPEXT failed: ino=117672225: Invalid argument
> insufficient freespace for: ino=117681809: size=21608017920: ignoring
> / start inode=0
> XFS_IOC_SWAPEXT failed: ino=117672225: Invalid argument
> insufficient freespace for: ino=117681809: size=21608017920: ignoring
> / start inode=0
> XFS_IOC_SWAPEXT failed: ino=117672225: Invalid argument
> insufficient freespace for: ino=117681809: size=21608017920: ignoring
> / start inode=0
> XFS_IOC_SWAPEXT failed: ino=117672225: Invalid argument
> insufficient freespace for: ino=117681809: size=21608017920: ignoring
> / start inode=0
> XFS_IOC_SWAPEXT failed: ino=117672225: Invalid argument
> insufficient freespace for: ino=117681809: size=21608017920: ignoring
> 
> Pastebin (another Debian KVM):
> 
> # vda1 is XFS filesystem
> debian@kvm:~$ sudo df -h
> Filesystem      Size   Used   Avail   Use%    Mounted
> udev            440M      0    448M     0%    /dev
> tmpfs            94M   656K     94M     1%    /run
> /dev/vda1       9.3G   1.4G    7.9G    15%    /
> tmpfs           470M      0    470M     0%    /dev/shm
> tmpfs           5.0M      0    5.0M     0%    /run/lock
> /dev/vda2       121M   5.9M    115M     5%    /boot/efi
> tmpfs            94M      0     94M     0%    /run/user/1000
> 
> # Normal case
> debian@kvm:~$ sudo xfs_fsr
> xfs_fsr -m /proc/mountfs -t 7200 -f /var/tmp/.fsrlast_xfs ...
> / start inode=0
> / start inode=0
> / start inode=0
> / start inode=0
> / start inode=0
> / start inode=0
> / start inode=0
> / start inode=0
> / start inode=0
> / start inode=0
> Completed all 10 passes
> 
> 

