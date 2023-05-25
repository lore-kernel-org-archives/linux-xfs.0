Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA0AC77B7E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 03:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbjEYDvh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 23:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjEYDve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 23:51:34 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D318213A;
        Wed, 24 May 2023 20:51:28 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPS id 191135CC303;
        Wed, 24 May 2023 22:51:28 -0500 (CDT)
Message-ID: <f723cb17-ca68-4db9-c296-cf33b16c529c@sandeen.net>
Date:   Wed, 24 May 2023 22:51:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [Syzkaller & bisect] There is "soft lockup in __cleanup_mnt" in
 v6.4-rc3 kernel
Content-Language: en-US
To:     Pengfei Xu <pengfei.xu@intel.com>, dchinner@redhat.com
Cc:     djwong@kernel.org, heng.su@intel.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, lkp@intel.com
References: <ZG7PGdRED5A68Jyh@xpf.sh.intel.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ZG7PGdRED5A68Jyh@xpf.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/24/23 9:59 PM, Pengfei Xu wrote:
> Hi Dave,
> 
> Greeting!
> 
> Platform: Alder lake
> There is "soft lockup in __cleanup_mnt" in v6.4-rc3 kernel.
> 
> Syzkaller analysis repro.report and bisect detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230524_140757___cleanup_mnt
> Guest machine info: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/machineInfo0
> Reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/repro.c
> Reproduced syscall: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/repro.prog
> Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/bisect_info.log
> Kconfig origin: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/kconfig_origin

There was a lot of discussion yesterday about how turning the crank on 
syzkaller and throwing un-triaged bug reports over the wall at 
stressed-out xfs developers isn't particularly helpful.

There was also a very specific concern raised in that discussion:

> IOWs, the bug report is deficient and not complete, and so I'm
> forced to spend unnecessary time trying to work out how to extract
> the filesystem image from a weird syzkaller report that is basically
> just a bunch of undocumented blobs in a github tree.

but here we are again, with another undocumented blob in a github tree, 
and no meaningful attempt at triage.

Syzbot at least is now providing filesystem images[1], which relieves 
some of the burden on the filesystem developers you're expecting to fix 
these bugs.

Perhaps before you send the /next/ filesystem-related syzkaller report, 
you can at least work out how to provide a standard filesystem image as 
part of the reproducer, one that can be examined with normal filesystem 
development and debugging tools?

[1]
https://lore.kernel.org/lkml/0000000000001f239205fb969174@google.com/T/


