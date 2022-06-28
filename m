Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6A8C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiF1W7i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiF1W7g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C9A36B4E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A53CBB82106
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 22:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5BAC341C8;
        Tue, 28 Jun 2022 22:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656457173;
        bh=Pd/v2h2X5CJoXzEayLSzb6dCkcGEPrnv4dMBv1Ejn1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pfGDiaM7Vgo1ObaxRk6ZWQLui3SekKV3ahzWoTFmNydqbIDHmBF2CUpmOzzDTEY0H
         bG/XHMDEIkcAAPGR/ZwkGTJELJ4j62RYhBzJrgFLH8wJvvUc0/+Uu0vVKixqa+i1aG
         kfC7EieMqi4f1F2UkQvpE/wt5J4JOnHtiQ0H/sNqxtH8NS2rlSHwzROHrqIs13JSCF
         DHDbH2We4JuwyqTpXQxAuMKnlzLZnhZ1L0+h+2bLdlQ8/D0slmjGcr0TvpCu06C1fe
         w/0UBvs+GmhdOo7pLP3PLHBSATjrOZhPd8rfqwrXfjpkofpMN6vQargzWc1FsFIhV9
         exFtL5/Ib/JRg==
Date:   Tue, 28 Jun 2022 15:59:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     corinhoad@gmail.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfsdump fails to build against xfsprogs 5.18.0
Message-ID: <YruH1JKxgybem3jw@magnolia>
References: <089bacd9-6213-d73f-f188-d4a31d91f447@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <089bacd9-6213-d73f-f188-d4a31d91f447@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 11:32:48PM +0100, corinhoad@gmail.com wrote:
> Hello,
> 
> I package xfsdump for NixOS, and I have found that a recent upgrade from
> xfsprogs 5.16.0 to 5.18.0 has caused a build failure for xfsprogs. See [1]
> for an excerpt from the build logs. My novice investigation of the issue and
> disccusion IRC indicates that the removal of DMAPI support is behind this.

Oops, we dropped the ball on this.  Does this patch[1] fix the problem?

--D

[1] https://lore.kernel.org/linux-xfs/20220203174540.GT8313@magnolia/

> 
> Best,
> Corin Hoad
> 
> [1]
> content.c: In function 'restore_complete_reg':
> content.c:7727:29: error: storage size of 'fssetdm' isn't known
>  7727 |                 fsdmidata_t fssetdm;
>       |                             ^~~~~~~
> content.c:7734:34: error: 'XFS_IOC_FSSETDM' undeclared (first use in this
> function); did you mean 'XFS_IOC_FSSETXATTR'?
>  7734 |                 rval = ioctl(fd, XFS_IOC_FSSETDM, (void *)&fssetdm);
>       |                                  ^~~~~~~~~~~~~~~
>       |                                  XFS_IOC_FSSETXATTR
> content.c:7734:34: note: each undeclared identifier is reported only once
> for each function it appears in
> content.c:7727:29: warning: unused variable 'fssetdm' [-Wunused-variable]
>  7727 |                 fsdmidata_t fssetdm;
>       |                             ^~~~~~~
> content.c: In function 'restore_symlink':
> content.c:8061:29: error: storage size of 'fssetdm' isn't known
>  8061 |                 fsdmidata_t fssetdm;
>       |                             ^~~~~~~
> content.c:8061:29: warning: unused variable 'fssetdm' [-Wunused-variable]
> content.c: In function 'setextattr':
> content.c:8867:9: warning: 'attr_set' is deprecated: Use setxattr or
> lsetxattr instead [-Wdeprecated-declarations]
>  8867 |         rval = attr_set(path,
>       |         ^~~~
> In file included from content.c:27:
> /nix/store/7b84p7877fl9p8aqx392drggj0jkqd0j-attr-2.5.1-dev/include/attr/attributes.h:139:12:
> note: declared here
>   139 | extern int attr_set (const char *__path, const char *__attrname,
>       |            ^~~~~~~~
> content.c: In function 'Media_mfile_next':
> content.c:4797:33: warning: ignoring return value of 'system' declared with
> attribute 'warn_unused_result' [-Wunused-result]
>  4797 |                                 system(media_change_alert_program);
>       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> content.c: In function 'restore_extent':
> content.c:8625:49: warning: ignoring return value of 'ftruncate' declared
> with attribute 'warn_unused_result' [-Wunused-result]
>  8625 |                                                 ftruncate(fd,
> bstatp->bs_size);
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> make[2]: *** [../include/buildrules:47: content.o] Error 1
> make[1]: *** [include/buildrules:23: restore] Error 2
> make: *** [Makefile:53: default] Error 2
