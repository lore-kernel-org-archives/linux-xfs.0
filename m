Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF07C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 20:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiCQUQE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCQUQE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 16:16:04 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C564F179B08
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 13:14:44 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g20so7932835edw.6
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 13:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datameer.com; s=google;
        h=date:to:subject:from:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=a8LWaz8JxkX02r3U4cynVBaGOGaKJ9fmBld3lxLDVWQ=;
        b=M/opsyC1lXLDF4ivhRU12VBwqdz8kt1/7dH2QKylBmuhrIm8yXm3D8siFZHKbKuL/c
         jJ5xobkOvXJOQWZ31c2cmBdkgPYQv8RbnDmFBEgyZwwrHNiUZVq7NNIsYTXwVlud4QSJ
         4y3CBJIKrtzBVuxOvDGd5SzTTvip8cx0ou8Tk/M8zYOPoGRP6dEelzbasAQJGE/0Mzm6
         +oNCb9ug8dhACTjZrbjNfQgwrG9dlRJcd8O0RYl0JF1NY2L5P5pP9AM2BF7H2JknCEjp
         04SSby7HWXn7ih8Wa3Yox39L+JpaIGxkpI0vdE8HaZ/xy52FqnEitaE3ZXPtuht9iBMv
         XMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:to:subject:from:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=a8LWaz8JxkX02r3U4cynVBaGOGaKJ9fmBld3lxLDVWQ=;
        b=EMVZH2mQ+jqbGfCoaCZwFL9tiBFApy2P/TEMcWpXNDUt/MwrdwrHDuh9slxXa1HhMj
         60FCMC+G+zZGCd3Bj3OP16KQBS5Ox5yuSKWko+Pz2AcDIBeGi572P99bfM2dsm/GyY1x
         2ogi2j47PomfED7dPt4Wy7LX3LusEw3Kv/O8DLqCfjoLif+vy266mT1qMqXigHZho7NQ
         eqIu+GrcfwkI06h1NbO+R9nI6W3B3dpMifxcSBcxCnGLyRzVPX5blYZ8wpCGckJRpWfO
         dCIULdsEvgu2SR9mn3Fc4AQksyqfTw1BduxXdWrb8h/omCKXggEG2Sr1C665U/u58Pwz
         lV1A==
X-Gm-Message-State: AOAM5315kNLaHJrnXgryc6cEo4T2theoMErHEwu1XXjl1D7LR129nIGJ
        qRXNcMg56X/R/1av1L8wAWQJbSLnyyIxB3CXfG9BHfQjurVuJWMsFKVAVsfpdS29O/LSIb0eR8g
        HAVnU4p18l7kkuvp8lLqVKX6Z17GmMoWgTNcb37o1n0nvsjey6QdAFp8MndNBEHKfad1MUg==
X-Google-Smtp-Source: ABdhPJz1RKJByo2aXYsYJ1EJDhXzHAOGEDsn2WjJxeXEyvgalzscWkMrlblgZ8MaWYST1aMIqwfoBQ==
X-Received: by 2002:a50:fe0d:0:b0:415:e2ee:65af with SMTP id f13-20020a50fe0d000000b00415e2ee65afmr6096279edt.383.1647548079184;
        Thu, 17 Mar 2022 13:14:39 -0700 (PDT)
Received: from localhost ([77.237.253.216])
        by smtp.gmail.com with ESMTPSA id l5-20020a170906644500b006ce6b73ffd2sm2837838ejn.84.2022.03.17.13.14.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:14:38 -0700 (PDT)
Date:   Thu, 17 Mar 2022 21:14:37 +0100
To:     linux-xfs@vger.kernel.org
Subject: cleanup inventory incl files
From:   mb@datameer.com
Message-Id: <2Q2P5H8L0VMZH.2OZ0ZSSMR64BA@datameer.com>
User-Agent: mblaze/1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,
I'm a new user of doing backups with xfs tools. so my questions are very
basic.
Anyway, I want to try to do daily incremental backups with xfsdump.

As far as I understood, after 10 days (or better after 9 levels) i have to =
start from scratch.
I'm able to clean my inventory based on media label / session id.
So far so good.
But the files behind the inventory still stay on disk.
I'm struggeling also to overwrite these files. So I assume I have to
delete the files by my own manually.

Or do you see any other convinient way to delete the dumps when
deleting the related entries from the inventory?

thx for any hint
marko


