Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C07C54EAA
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Jan 2023 15:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbjA3PSC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Jan 2023 10:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbjA3PRz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2023 10:17:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC10298C2
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jan 2023 07:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675091789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TM9pjuw2TQ3Boe7rzLGRkaUEaT/rl4HKH4FoyVS7oc=;
        b=eCyNjP2UpnWGmJUomvWvmB5vWI/+OUb2H2wiwmyjC766SwL2s7LZ6dZP/ULlZWs5zXV5Sg
        2Y1YRqfVrKURKlDSoQH2N0KT83+I9F24Mb2jCeK3kwBs/3cTJze7Rx5FvET//TJqhneBXw
        H/BQbLW3Mi68iOLrfHz10WeGbtQsIBQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-524-mMThq5V4Pkqkf1L7q7j4ug-1; Mon, 30 Jan 2023 10:16:28 -0500
X-MC-Unique: mMThq5V4Pkqkf1L7q7j4ug-1
Received: by mail-il1-f198.google.com with SMTP id x9-20020a056e021ca900b0030f177273c3so7387364ill.8
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jan 2023 07:16:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8TM9pjuw2TQ3Boe7rzLGRkaUEaT/rl4HKH4FoyVS7oc=;
        b=WWmlkseVhcbCG1egkFH8Zo6/5Nedth6jofYuexvY485VKiIo6gT2caMCdmoKIqjPLs
         dkgEQ4aiJfidBGLoL6kg0ZRdA7CuS6Ch1E1FKOTL7QfZeZlVmWe6lBJeEJ16Xb+riNGN
         c9GxBxt1vkEZQG1pwpZLpjr1Z7rf7lRDzXFgYF9/k47GAQesn8ourfd3CYbkxzawo1A4
         hX0yTM3IGQ0dXWjET91/6PfTPF9YdAfIOTID5sUk8WheikRN1UqLRX/ObKGqAX2/g6Wa
         p1fbNnN8AoMvoJ9BFn6Udnojjt1yK6+wwbc0/vgsLog7Cj2madSmB4JfFgJMc3Pf8gZP
         9/zw==
X-Gm-Message-State: AO0yUKWSk9Htes1s50xVtk/Laa2vj+w9PjNxWrum3RQffuIJbaaWiIff
        6hdMkHCcUbGtz6rKAczX6VRliumEuB+sChwTAiYaVwiC0uwSM4ER5alate7JLd6UwzBn7jTdvQ0
        5X+8V25bap73HNP5bs9dO
X-Received: by 2002:a05:6e02:1d0e:b0:310:fc22:725e with SMTP id i14-20020a056e021d0e00b00310fc22725emr2005835ila.27.1675091787054;
        Mon, 30 Jan 2023 07:16:27 -0800 (PST)
X-Google-Smtp-Source: AK7set/0IygChx7TZNDvZLHN7JHTC+nKp6rctAF76lruQpYFY82K0gZn3HD8hPtR/Rrm2o44fZwV0A==
X-Received: by 2002:a05:6e02:1d0e:b0:310:fc22:725e with SMTP id i14-20020a056e021d0e00b00310fc22725emr2005819ila.27.1675091786792;
        Mon, 30 Jan 2023 07:16:26 -0800 (PST)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id t11-20020a02ccab000000b0038a760ab9a4sm4728808jap.161.2023.01.30.07.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 07:16:26 -0800 (PST)
Message-ID: <a7c0ab82-7f6b-678f-387f-cdfbbd278471@redhat.com>
Date:   Mon, 30 Jan 2023 09:16:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: xfs_repair on filesystem stuck in "rebuild AG headers and trees"?
Content-Language: en-US
To:     =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <PAXPR03MB7856BE8E2D589B6A5FA2B84A8ACF9@PAXPR03MB7856.eurprd03.prod.outlook.com>
 <PAXPR03MB7856BFBFC10B60C0C92372878AD39@PAXPR03MB7856.eurprd03.prod.outlook.com>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <PAXPR03MB7856BFBFC10B60C0C92372878AD39@PAXPR03MB7856.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both your kernel and xfsprogs are older versions from your distro.

I would report this bug to your distro, or try upstream versions to see if
the problem has been resolved.

-Eric

On 1/30/23 4:57 AM, Libor Klepáč wrote:
> Hi,
> i breaked xfs_repair and lauched it again.
> On beginning of phase 6 i have
> failed to create prefetch thread: Resource temporarily unavailable
> https://download.bcom.cz/xfs/Screenshot_20230130_114707.jpeg
> 
> Also, there is dmesg, when it was trying to mount it and it was stuck
> https://download.bcom.cz/xfs/dmesg.txt
> 
> Libor
> 
> 
> From: Libor Klepáč <libor.klepac@bcom.cz>
> Sent: Thursday, January 26, 2023 11:46
> To: linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>
> Subject: xfs_repair on filesystem stuck in "rebuild AG headers and trees"? 
>  
> Hi,
> we have virtual machine with 8TB data disk with around 5TB of data in few large files (backup repository of nakivo backup solution - it contains snapshots of vmware machines - one file per snapshot).
> 
> We have recently upgraded VM from ubuntu 20.04 to ubuntu 22.04 and after reboot, mount of this filesystem took ages.
> 
> I started xfs_repair on it and now it spits line
> rebuild AG headers and trees - 16417 of 16417 allocation groups done
> 
> in 15 minutes interval for last two days.
> Is it in loop?
> Can i break it? 
> Data on disk is just remote copy of backup, so it can be lost, it will just take some time to transfer it again.
> 
> Kernel is probably from package 5.15.0-58.64  - sorry i don't know real version, cannot get it from ubuntu package.
> xfsprogs should be 5.13.0-1ubuntu2
> 
> Thanks for any info,
> 
> with regards,
> Libor
> 
> 

