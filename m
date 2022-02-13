Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E142C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Feb 2022 03:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiBMDAy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Feb 2022 22:00:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiBMDAy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Feb 2022 22:00:54 -0500
X-Greylist: delayed 784 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Feb 2022 19:00:49 PST
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C185A60074
        for <linux-xfs@vger.kernel.org>; Sat, 12 Feb 2022 19:00:49 -0800 (PST)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 21D2kp2F069401;
        Sat, 12 Feb 2022 18:46:53 -0800
Message-ID: <62087125.2020704@tlinx.org>
Date:   Sat, 12 Feb 2022 18:47:01 -0800
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     Eric Sandeen <sandeen@sandeen.net>
CC:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsdump 3.1.10 released
References: <f2ce57bd-8558-b7dc-8379-9cf97f07f578@sandeen.net>
In-Reply-To: <f2ce57bd-8558-b7dc-8379-9cf97f07f578@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2022/02/11 12:59, Eric Sandeen wrote:
> Hi folks,

> because I don't want to stall on getting the fix for the root inode
> problems out there any longer. It's been ... quite long enough.
> 
> Next release we can think about the dmapi junk, and possibly the
> workaround for the broken dumps with the root inode problem.
> 
> This should at least be generating valid dumps on those filesystems
> with "interesting" geometry, again.
----

Thanks for the Cc.

  As near as I understand your comments, this should generate new dumps that won't
have the problem I'm seeing, but will still leave previous dumps in the old format
that may show problems upon restoration.

  FWIW, xfs/restore-dump aren't the only util to have problems with little-used geometries.

 The BSD-DB libs of 10-15 years ago used in in perl have problems with a RAID50 setup. AFAIK, the problem was never fixed, because the perl punted the problem to the bsdlib.  Unfortunately, no one was supporting that lib anymore. I think a new db-lib was added
(mariadb?, I forget) that replaced the older format), so newer perls may not
have that bug.

  It only appeared when the "POSIX-Optimal-I/O" size was NOT a *power*-of-2.
The lib confused *factor*-of-2 alignment with Pow-of-2 for use in db-internal
size-allocations provided resulting in some internal allocations being of size-0, which doesn't work very well.
 
  Of course perl doesn't check for this error case, since the problem isn't considered
to be a problem in the perl-code.
