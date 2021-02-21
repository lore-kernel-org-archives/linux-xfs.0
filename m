Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A53FC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 07:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C43AC64F04
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 07:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhBUHRq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 02:17:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57405 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhBUHRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Feb 2021 02:17:46 -0500
Received: from [207.224.24.214] (helo=[192.168.13.65])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <steve.langasek@canonical.com>)
        id 1lDizG-0003S9-4W; Sun, 21 Feb 2021 07:17:02 +0000
Date:   Sat, 20 Feb 2021 23:16:57 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20210221041139.GL4662@dread.disaster.area>
References: <20210220121610.3982-1-bastiangermann@fishpost.de> <20210220121610.3982-4-bastiangermann@fishpost.de> <20210221041139.GL4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH 3/4] debian: Regenerate config.guess using debhelper
To:     Dave Chinner <david@fromorbit.com>,
        Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org,
        Steve Langasek <steve.langasek@ubuntu.com>
From:   Steve Langasek <steve.langasek@canonical.com>
Message-ID: <840CCF3D-7A20-4E35-BA9C-DEC9C05EE70A@canonical.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On February 20, 2021 8:11:39 PM PST, Dave Chinner <david@fromorbit.com> wrote:
>On Sat, Feb 20, 2021 at 01:16:08PM +0100, Bastian Germann wrote:
>> This is a change introduced in 5.10.0-2ubuntu2 with the changelog:
>> 
>> > xfsprogs upstream has regressed config.guess, so use
>> > dh_update_autotools_config.
>
>What regression?
>
>The xfsprogs build generates config.guess with the libtool
>infrastructure installed on the build machine. So I'm not sure
>how/what we've regressed here, because AFAIK we haven't changed
>anything here recently...

This upstream release ended up with an older version of config.guess in the tarball.  Specifically, it was too old to recognize RISC-V as an architecture.

>> Reported-by: Steve Langasek <steve.langasek@ubuntu.com>
>> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
>> ---
>>  debian/changelog | 3 +++
>>  debian/rules     | 1 +
>>  2 files changed, 4 insertions(+)
>> 
>> diff --git a/debian/changelog b/debian/changelog
>> index c77f04ab..6cc9926b 100644
>> --- a/debian/changelog
>> +++ b/debian/changelog
>> @@ -4,6 +4,9 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
>>    * Drop trying to create upstream distribution
>>    * Enable CET on amd64
>>  
>> +  [ Steve Langasek ]
>> +  * Regenerate config.guess using debhelper
>> +
>>   -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021
>11:57:31 +0100
>>  
>>  xfsprogs (5.10.0-3) unstable; urgency=medium
>> diff --git a/debian/rules b/debian/rules
>> index dd093f2c..1913ccb6 100755
>> --- a/debian/rules
>> +++ b/debian/rules
>> @@ -49,6 +49,7 @@ config: .census
>>  	@echo "== dpkg-buildpackage: configure" 1>&2
>>  	$(checkdir)
>>  	AUTOHEADER=/bin/true dh_autoreconf
>> +	dh_update_autotools_config
>>  	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
>
>Why would running at tool that does a search-n-replace of built
>config.guess files do anything when run before the build runs
>libtoolize to copy in the config.guess file it uses? I'm a bit
>confused by this...

Autoreconf was not copying in a newer version of config.guess from the system, because of the specific subset of autotools used by this project.

-- 
Steve Langasek
