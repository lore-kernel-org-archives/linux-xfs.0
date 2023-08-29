Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD10C6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbjH2XmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbjH2Xlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF7EC2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E25DC62163
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48735C433C7;
        Tue, 29 Aug 2023 23:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693352497;
        bh=W0S/+CJROE9+iLV/+wO1v2kslNVffhNw2yRnke9bdjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PgLiekxAAaAu2ZUpiMjWBMNfasnVkQ6dDLtzqXmNiV+fpSeXsg1MampG8nKZb0awY
         WxhW61lryKRU+a1+Tuy29pVi0TO8tMFlYy6s1pII7hO4RheBwrB4r/oMxVZgapjsM+
         oP/XfyzpBtAPngbKuegpoC7bky/Zmm948OEICMp9u5QeYedpIaJgre1ImxHOLhF1c0
         E63JPFgkzJHgE6Xjb+u0rx6QLfkzke5wcb02PU7vGRsz0HXLKWplB5K6ydan9b958z
         S0L00K5AF/1+/cOj+Bk0zlbtEpuJWrxIiQMRJlc9T/7/U9l2J8l10uSA097BkqZHZa
         qTMZZku26spZg==
Date:   Tue, 29 Aug 2023 16:41:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jose M Calhariz <jose.calhariz@tecnico.ulisboa.pt>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Data corruption with XFS on Debian 11 and 12 under heavy load.
Message-ID: <20230829234136.GF28186@frogsfrogsfrogs>
References: <ZO4nuHNg+KFzZ2Qz@calhariz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZO4nuHNg+KFzZ2Qz@calhariz.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 06:15:36PM +0100, Jose M Calhariz wrote:
> 
> Hi,
> 
> I have been chasing a data corruption problem under heavy load on 4
> servers that I have at my care.  First I thought of an hardware
> problem because it only happen with RAID 6 disks.  So I reported to Debian: 
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1032391
> 
> Further research pointed to be the XFS the common pattern, not an
> hardware issue.  So I made an informal query to a friend in a software
> house that relies heavily on XFS about his thought on this issue.  He
> made reference to several problems fixed on kernel 6.2 and a
> discussion on this mailing list about back porting the fixes to 6.1
> kernel.
> 
> With this information I have tried the latest kernel at that time on
> Debian testing over Debian v12 and I could not reproduce the
> problem.  So I made another bug report:
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1040416
> 
> My questions to this mailing list:
> 
>   - Have anyone experienced under Debian or with vanilla kernels
>   corruption under heavy load on XFS?

Yes.  There were a rash of corruption problems that got fixed in 6.2:
https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/tag/?h=xfs-6.2-merge-8

My guess with no other information is either the write invalidation
problem in iomap; or maybe COW extent allocations racing with the log.

Most of these haven't been backported to 6.1 because our only choices as
a community were (a) let a dumb bot shovel in patches with zero QA or
(b) try to scare up volunteers to backport things to LTS kernels.  (a)
wasn't acceptable, but then with (b)...

>   - Should I stop waiting for the fixes being back ported to vanilla
>   6.1 and run the latest kernel from Debian testing anyway?  Taking
>   notice that kernels from testing have less security updates on time
>   than stable kernels, specially security issues with limited
>   disclosure.

...there isn't really a designated 6.1 LTS backport engineer right now.
A couple folks from Cloudflare; Amir Goldstein; and Ted Ts'o have been
sharing the work when they have spare time.

--D

> I am happy to provide more info about my setup or my stability tests
> that fail under XFS.
> 
> 
> Kind regards
> Jose M Calhariz
> 
> -- 
> --
> Um falso amigo nunca o xinga
> 
> Um verdadeiro amigo já o xingou de tudo quanto é
> palavrão que existe - e até inventou alguns novos


