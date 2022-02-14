Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7CAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Feb 2022 14:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354933AbiBNO3J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Feb 2022 09:29:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiBNO3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Feb 2022 09:29:08 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2C1A403CD
        for <linux-xfs@vger.kernel.org>; Mon, 14 Feb 2022 06:29:00 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 49F6F504DFD;
        Mon, 14 Feb 2022 08:28:22 -0600 (CST)
Message-ID: <31eec545-8d42-2147-59bf-5eaffaa230d1@sandeen.net>
Date:   Mon, 14 Feb 2022 08:28:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-Language: en-US
To:     L A Walsh <xfs@tlinx.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <f2ce57bd-8558-b7dc-8379-9cf97f07f578@sandeen.net>
 <62087125.2020704@tlinx.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [ANNOUNCE] xfsdump 3.1.10 released
In-Reply-To: <62087125.2020704@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/12/22 8:47 PM, L A Walsh wrote:
> 
> 
> On 2022/02/11 12:59, Eric Sandeen wrote:
>> Hi folks,
> 
>> because I don't want to stall on getting the fix for the root inode
>> problems out there any longer. It's been ... quite long enough.
>>
>> Next release we can think about the dmapi junk, and possibly the
>> workaround for the broken dumps with the root inode problem.
>>
>> This should at least be generating valid dumps on those filesystems
>> with "interesting" geometry, again.
> ----
> 
> Thanks for the Cc.
> 
>  As near as I understand your comments, this should generate new dumps that won't
> have the problem I'm seeing, but will still leave previous dumps in the old format
> that may show problems upon restoration.

Correct, I want to spend more time on the workaround to be sure we have confidence
in it, sorry.

>  FWIW, xfs/restore-dump aren't the only util to have problems with little-used geometries.
> 
> The BSD-DB libs of 10-15 years ago used in in perl have problems with a RAID50 setup. AFAIK, the problem was never fixed, because the perl punted the problem to the bsdlib.  Unfortunately, no one was supporting that lib anymore. I think a new db-lib was added
> (mariadb?, I forget) that replaced the older format), so newer perls may not
> have that bug.
> 
>  It only appeared when the "POSIX-Optimal-I/O" size was NOT a *power*-of-2.
> The lib confused *factor*-of-2 alignment with Pow-of-2 for use in db-internal
> size-allocations provided resulting in some internal allocations being of size-0, which doesn't work very well.
> 
>  Of course perl doesn't check for this error case, since the problem isn't considered
> to be a problem in the perl-code.

Funky ;)

-Eric
