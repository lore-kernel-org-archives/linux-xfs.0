Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D03C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 09:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7AC6146D
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 09:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCWJcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 05:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhCWJb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 05:31:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5BEC061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 02:31:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1lOdOG-000347-1z; Tue, 23 Mar 2021 10:31:56 +0100
Message-ID: <3ffb0db477970d6dfc5fbf170fa8afdb03f71061.camel@pengutronix.de>
Subject: Re: memory requirements for a 400TB fs with reflinks
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Ralf =?ISO-8859-1?Q?Gro=DF?= <ralf.gross+xfs@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 23 Mar 2021 10:31:55 +0100
In-Reply-To: <CANSSxy=d2Tihu8dXUFQmRwYWHNdcGQoSQAkZpePD-8NOV+d5dw@mail.gmail.com>
References: <CANSSxym1ob76jW9i-1ZLfEe4KSHA5auOnZhtXykRQg0efAL+WA@mail.gmail.com>
         <CANSSxy=d2Tihu8dXUFQmRwYWHNdcGQoSQAkZpePD-8NOV+d5dw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Ralf,

Am Montag, dem 22.03.2021 um 17:50 +0100 schrieb Ralf Groß:
> No advice or rule of thumb regarding needed memory for xfs_repair?

xfs_repair can be quite a memory hog, however the memory requirements
are mostly related to the amount of metadata in the FS, not so much
with the overall size of the FS. So a small FS with a ton of small
files will require much more RAM on a repair run than a big FS with
only a few big files.

However, xfs_repair makes linear passes over its workingset, so it
works really well with swap. Our backupservers are handling filesystems
with ~400GB of metadata (size of the metadump) and are only equipped
with 64GB RAM. For the worst-case where a xfs_repair run might be
needed they simply have a 1TB SSD to be used as swap for the repair
run.

Regards,
Lucas

> Ralf
> 
> 
> Am Sa., 20. März 2021 um 19:01 Uhr schrieb Ralf Groß <ralf.gross+xfs@gmail.com>:
> > 
> > Hi,
> > 
> > I plan to deploy a couple of Linux (RHEL 8.x) server as Veeam backup
> > repositories. Base for this might be high density server with 58 x
> > 16TB disks, 2x  RAID 60, each with its own raid controller and 28
> > disks. So each RAID 6 has 14 disks, + 2 globale spare.
> > 
> > I wonder what memory requirement such a server would have, is there
> > any special requirement regarding reflinks? I remember that xfs_repair
> > has been a problem in the past, but my experience with this is from 10
> > years ago. Currently I plan to use 192GB RAM, this would be perfect as
> > it utilizes 6 memory channels and 16GB DIMMs are not so expensive.
> > 
> > Thanks - Ralf


