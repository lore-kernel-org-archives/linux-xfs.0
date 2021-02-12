Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA6EC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 819CF64EA1
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhBLWPr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 17:15:47 -0500
Received: from sandeen.net ([63.231.237.45]:49514 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhBLWPo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Feb 2021 17:15:44 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2714C15D6E;
        Fri, 12 Feb 2021 16:15:01 -0600 (CST)
To:     Markus Mayer <mmayer@broadcom.com>
Cc:     Linux XFS <linux-xfs@vger.kernel.org>
References: <20210212204849.1556406-1-mmayer@broadcom.com>
 <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
 <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net>
 <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
Message-ID: <5062240d-78a2-50f5-b966-493acff111e5@sandeen.net>
Date:   Fri, 12 Feb 2021 16:15:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/12/21 3:55 PM, Markus Mayer wrote:
> On Fri, 12 Feb 2021 at 13:29, Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 2/12/21 2:51 PM, Markus Mayer wrote:
>>>> To prevent issues when the ".o" extension appears in a directory path,
>>>> ensure that the ".o" -> ".lo" substitution is only performed for the
>>>> final file extension.
>>>
>>> If the subject should be "[PATCH] xfsprogs: ...", please let me know.
>>
>> Nah, that's fine, I noticed it.
>>
>> So did you have a path component that had ".o" in it that got substituted?
>> Is that what the bugfix is?
> 
> Yes and yes.
> 
> Specifically, I was asked to name the build directory in our build
> system "workspace.o" (or something else ending in .o) because that
> causes the automated backup to skip backing up temporary build
> directories, which is what we want. There is an existing exclusion
> pattern that skips .o files during backup runs, and they didn't want
> to create specialized rules for different projects. Hence the request
> for the oddly named directory to make it match the existing pattern.
>
> We also have a symlink without the ".o" extension (workspace ->
> workspace.o) which is commonly used to access the work space, but
> symlinks  frequently get expanded when scripts run. In the end, the
> xfsprogs build system saw the full path without the symlink
> (".../workspace.o/.../xfsprogs-5.8.0/...") and started substituting
> workspace.o with workspace.lo. And then the build died.

haha, no comment on the strategy ;)

But I agree that we should not be substituting anything but the root filename
suffix, so the patch is fine by me.

-Eric

> Like this:
> 
>>>> xfsprogs 5.8.0 Building
> PATH="/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/host/bin:/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
>  /usr/bin/make -j33  -C
> /local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/build/xfsprogs-5.8.0/
>    [HEADERS] include
>    [HEADERS] libxfs
> Building include
>     [LN]     disk
> make[3]: Nothing to be done for 'include'.
> Building libfrog
>     [CC]     gen_crc32table
>     [GENERATE] crc32table.h
> make[4]: *** No rule to make target
> '/local/users/jenkins/workspace.lo/buildroot_linux-5.4_llvm/output/arm64/target/usr/include/uuid/uuid.h',
> needed by 'bitmap.lo'.  Stop.
> make[4]: *** Waiting for unfinished jobs....
>     [CC]     avl64.lo
> include/buildrules:35: recipe for target 'libfrog' failed
> make[3]: *** [libfrog] Error 2
> Makefile:91: recipe for target 'default' failed
> make[2]: *** [default] Error 2
> package/pkg-generic.mk:247: recipe for target
> '/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/build/xfsprogs-5.8.0/.stamp_built'
> failed
> make[1]: *** [/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/build/xfsprogs-5.8.0/.stamp_built]
> Error 2
> 
> Regards,
> -Markus
> 
