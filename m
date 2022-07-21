Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3944C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jul 2022 03:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiGUD3w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 23:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUD3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 23:29:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953D561D97
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 20:29:50 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bf13so443095pgb.11
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 20:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=d7G8IAlW0jT//sna30rwsZ7OL53uO+4+vHfrmyAXBeg=;
        b=XGc9PCaKL+DnU++PAsO2+HnILnuf4dMs7XeOnXMpH73b+BnDbrrM7OOj03L+6SVKFq
         UbID2nlaCmaHQktgkdQ+ngO06vuxXciJd+a9SZHeihJt1Zw5z98P5DlXZGLOx9Ux7oiv
         7aSPLZE5XIULe4ZvIyGyN4T0vajEZJP/PI0CH3UA7byNGs6eQ1URqSfLFURUTCh7v7en
         VbOiTnPj3uOmQfJL91rEiHmKYIbHJFMJFK+Uk4aFC83SPHNRllhPoYZyGl/XYBf63QzJ
         2pFRSTEO6adzZ5mjhJTR6nS1yCEzKSL0/rFjyHnkyofIx5KGLXqRqwsgAS6iFoVBmpec
         MZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d7G8IAlW0jT//sna30rwsZ7OL53uO+4+vHfrmyAXBeg=;
        b=kyIxxQEcARR9vhVBgHffTVqVf179b/HTCyG3doIQ5HFlDHLADKwdHqnSlOmTMwSAa2
         y8wU9sb0V98BAf+yUxdCQGAzCBB50/6R8efn3d9robjtkS9ouuIX1y8+UEXDj8thUi2p
         yWKKOi4Ad/L03ceb6rmzFArpRDMLZfo+Gqxh/sKEqpoQmjLlDh+s22o5Vf7ThCEizlCe
         I2RR/Db2zLZX1AoveEH3eZB5kpQF37mz/dgUeRxhYgChAbJyxLJJvUiaSrpzl5hwa2w+
         DpfbCvDcC6McArKW/gc65+Y88+BAyCCxU96CaRl15VF368DOGuj4aKGF/toxVDkZ0Pi6
         Fg1w==
X-Gm-Message-State: AJIora9ug1XgLnMRqPsu1ARYfKokirSMWy7EQylDxLSBVQHI3xuDO5pr
        m1whFMv5zo3Z2TUZ3KBkgJE=
X-Google-Smtp-Source: AGRyM1v1WL6FzTlCkBHNJYYzL4hcBG36SeXioIRr1lVPKa5F29HWVT6vCZFReLPGT5n9tMP2pO8oew==
X-Received: by 2002:a65:6b8a:0:b0:3fc:4c06:8a8d with SMTP id d10-20020a656b8a000000b003fc4c068a8dmr35996187pgw.83.1658374190030;
        Wed, 20 Jul 2022 20:29:50 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h2-20020a17090a054200b001f0ade18babsm2411527pjf.55.2022.07.20.20.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 20:29:49 -0700 (PDT)
Message-ID: <dae3e881-ae1b-8140-783f-a3a04317199e@gmail.com>
Date:   Wed, 20 Jul 2022 20:29:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [RFC PATCH] libxfs: stop overriding MAP_SYNC in publicly exported
 header files
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Cc:     info@mobile-stream.com,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>
References: <YtiPgDT3imEyU2aF@magnolia>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YtiPgDT3imEyU2aF@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/20/2022 4:28 PM, Darrick J. Wong wrote:
> Can one of you please apply this patch and see if it'll build in musl on
> mips, please?  Sorry it's taken so long to address this. :/
> 
> --D
> 
> ---
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Florian Fainelli most recently reported that xfsprogs doesn't build with
> musl on mips:
> 
> "MIPS platforms building with recent kernel headers and the musl-libc
> toolchain will expose the following build failure:
> 
> mmap.c: In function 'mmap_f':
> mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
>    196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>        |            ^~~~~~~~
>        |            MS_SYNC
> mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [../include/buildrules:81: mmap.o] Error 1"
> 
> At first glance, the build failure here is caused by the fact that:
> 
> 1. The configure script doesn't detect MAP_SYNC support
> 2. The build system doesn't set HAVE_MAP_SYNC
> 2. io/mmap.c includes input.h -> projects.h -> xfs.h and later sys/mman.h
> 3. include/linux.h #define's MAP_SYNC to 0 if HAVE_MAP_SYNC is not set
> 4. musl's sys/mman.h #undef MAP_SYNC on platforms that don't support it
> 5. io/mmap.c tries to use MAP_SYNC, not realizing that libc undefined it
> 
> Normally, xfs_io only exports functionality that is defined by the libc
> and/or kernel headers on the build system.  We often make exceptions for
> new functionality so that we have a way to test them before the header
> file packages catch up, hence this '#ifndef HAVE_FOO #define FOO'
> paradigm.
> 
> MAP_SYNC is a gross and horribly broken example of this.  These support
> crutches are supposed to be *private* to xfsprogs for benefit of early
> testing, but they were instead added to include/linux.h, which we
> provide to user programs in the xfslibs-dev package.  IOWs, we've been
> #defining MAP_SYNC to zero for unsuspecting programs.
> 
> Worst yet, gcc 11.3 doesn't even warn about overriding a #define to 0:
> 
> #include <stdio.h>
> #include <sys/mman.h>
> #ifdef STUPID
> # include <xfs/xfs.h>
> #endif
> 
> int main(int argc, char *argv[]) {
> 	printf("MAP_SYNC 0x%x\n", MAP_SYNC);
> }
> 
> $ gcc -o a a.c -Wall
> $ ./a
> MAP_SYNC 0x80000
> $ gcc -DSTUPID -o a a.c -Wall
> $ ./a
> MAP_SYNC 0x0
> 
> Four years have gone by since the introduction of MAP_SYNC, so let's get
> rid of the override code entirely -- any platform that supports MAP_SYNC
> has had plenty of chances to ensure their header files have the right
> bits.  While we're at it, fix AC_HAVE_MAP_SYNC to look for MAP_SYNC in
> the same header file that the one user (io/mmap.c) uses -- sys/mman.h.
> 
> Annoyingly, I had to test this by hand because the sole fstest that
> exercises MAP_SYNC (generic/470) requires dm-logwrites and dm-thinp,
> neither of which support fsdax on current kernels.
> 
> Reported-by: info@mobile-stream.com
> Reported-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
