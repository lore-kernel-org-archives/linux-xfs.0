Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A70C48BE5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 05:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C8B61410
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 05:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhFOFsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 01:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhFOFsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 01:48:15 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7B6C061574
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jun 2021 22:46:10 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id f10so27606559iok.6
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jun 2021 22:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bujYkvahA9pdALBPohebAeETbBhe69gpmgZv1ffMXwQ=;
        b=Ie3aLBr6jN99Y/JcnE3Uq8nOAlWs1Vs6LAz0zGxuVhQxW5gL+aiQ435fTRdf+rjY+B
         nlfVKuirs5Mq3V6QB/Khxbo4e7iwdWGesd7QOZYP1O7J7mtBnvwOPiSZFw72P6Jv+obj
         wp70W3q2zSFPz/sS96uke6m2dFiEPdAvfm24gB3g1CvUyrGR+IRyJ6YdIwS43vX1339I
         bbliOpqBQ+09ze6xnQFeOCBwTEzdoQh2TWAuLCFhLHuuZpWGE8lmMfJ5xa21pW8wkfSi
         s4TxOcU9xgTGgBr26DTv2fx6S83nPfzSovXzSoIOb8sCLvygo+TJnkUegFgyCn8t+2aS
         Ae3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bujYkvahA9pdALBPohebAeETbBhe69gpmgZv1ffMXwQ=;
        b=XfxIWFdvkifHSpK5tO0wtSOhMGtFrHaD9adBQkkAhMeO4MaLROt6QgYxqz5zUZlb3T
         b9ekjpPSfxUjHT2gbIMjKRa1FOT+Eg1+EdflmgYkrQoGmi+2On2FFzuQz7HNMxtVwnu/
         r9siupA+0dBF+/t7KCEsP95Nxo/scyjS/naf+n9vAJUzkzbcJzg5D0jH9YbIHrr6a4aH
         XRUzxgXUcYqWC7Nbb+3J6nfsb2vTx0jmYwx92tkm7pqy1V6c18/Gis7RXH2YymeabSLI
         hZSSkmZp0vMthssLeGYDed50wrXscnOCXsCDu/SMPyV5SKfEtAslWFpXHGP34/UtIe2U
         JREw==
X-Gm-Message-State: AOAM532n7d5upJ7g7MN6tD14wakhIO1LxqE1gI1dk1cwV6JZ4D+MVpkP
        oL3EpT2q83ntkuNjaby/JX1WuUaZ/yCeumny8ao+2vUj7YFWpA==
X-Google-Smtp-Source: ABdhPJylF5Ej23dAF07axE8nkr3/zRHZohNGSCcYhxrBcWQ8QEM+nJBIY/iSBcADs6OnNi2x/7kGaL8clKSYpH4+QL8=
X-Received: by 2002:a05:6602:1348:: with SMTP id i8mr938592iov.208.1623735970196;
 Mon, 14 Jun 2021 22:46:10 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Ralf_Gro=C3=9F?= <ralf.gross+xfs@gmail.com>
Date:   Tue, 15 Jun 2021 07:45:59 +0200
Message-ID: <CANSSxykVgGj5PHzfPm_xvJi_dpooS_vBpO14-S3KhM6BZfBFtA@mail.gmail.com>
Subject: copy / move reflink files to new filesystem / or whole fs
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

is there any way to copy or move data between 2 xfs fs with reflinks
on the same host, so that the data is not rehydrated (I guess cp
--reflink will not be working)? If this is not possible, would it be
able to clone the existing fs to a new one and then continue to use
both?

Background: I've backup data on a 350 TB reflink xfs fs, now a second
fs will be added to the server and parts of existing data should be
moved to it. If it's possible to clone the whole fs I could delete
parts of it afterwards, but copying/moving single directories would be
easier.

Ralf
