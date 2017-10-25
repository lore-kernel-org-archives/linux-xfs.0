Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from welcomes-you.com ([144.76.218.113]:32780 "EHLO
        smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbdJYLvR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 07:51:17 -0400
Subject: Re: Possible to mount this XFS at least temporarily to retrieve
 files?
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
 <CAAxjCEwEH-OsH_z=OWg0R7XoOzyWeUQsmTp1r8Fdp-JU11eX4Q@mail.gmail.com>
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Message-ID: <8d15394e-1dd6-ced0-7af1-fb538c60bb58@aei.mpg.de>
Date: Wed, 25 Oct 2017 13:51:13 +0200
MIME-Version: 1.0
In-Reply-To: <CAAxjCEwEH-OsH_z=OWg0R7XoOzyWeUQsmTp1r8Fdp-JU11eX4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

Hi

On 10/25/17 13:32, Stefan Ring wrote:
> Did the RAID rebuild complete at least?
> 

sorry, forgot to mention. Yes, the rebuild finished and the controller
did not mention anything wrong during the rebuild - only after it now
tells us about a fan failure and a dead battery:

* Rebuild done at Tue Oct 24 18:08:57 UTC 2017

* Fan failure at Tue Oct 24 18:16:33 UTC 2017

* Battery failure at Tue Oct 24 18:16:44 UTC 2017

So yes, this controller should probably be exchanged as well.

But on the other hand, given that this was a single disk rebuild in a
RAID6 (10+2) in theory it should not impact anything working on the
block device level or above except for timeouts/slowness ;)

Cheers

Carsten
