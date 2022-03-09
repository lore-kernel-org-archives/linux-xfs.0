Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D35C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 16:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiCIQBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCIQBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 11:01:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2B07664B
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 08:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550FFB8221F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E361CC340E8;
        Wed,  9 Mar 2022 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646841619;
        bh=13zKZ2ZW4HW//0AyRqp+gLFGeNWQ3wYjHsiJYYG2NEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gPaNPTZM6TdaoVndRl2JRCiv7zmy8jYsBDju8h5wlVayIlnXEr8KIdGVL5/o33gYD
         OdMWTQy3yLeev7eDEQceTySFmEI8/GiddgjK1n1JkbIet2Vw04lRzmE88rDy+1C52v
         RlzTfunw8SNmYNIRLEb7n4PpCraBdGitiaHuTNrGcx66zii8GbmNZhWVSuOkIz77MZ
         5NbDQEyFsO05AT1hYwiGyxGtr7fGKly+hQSW9Cxi6IqCxO9tjgO+W8NK1PfoejGqc8
         3rmK7Cc25TtXVb5FtMPsff6X/5qYXIlppvI2BXv1Z8/jAPPrfVtbXGjTKQagQaI62l
         gV75kUFZkImag==
Date:   Wed, 9 Mar 2022 08:00:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jonathan Woithe <jwoithe@just42.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Clarifying XFS behaviour for dates before 1901 and after 2038
Message-ID: <20220309160019.GB8224@magnolia>
References: <20220309072303.GE12332@marvin.atrad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309072303.GE12332@marvin.atrad.com.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 05:53:03PM +1030, Jonathan Woithe wrote:
> Hi all
> 
> Today I was running some file timestamping tests to get a feel for the
> bigtime XFS option and to confirm that it was doing what I expected. 
> Everything made sense until a certain point.
> 
> There are two systems:
> 
>  * PC-1: Slackware64 15.0, xfsprogs 5.13.0, 5.15.27 kernel
> 
>  * PC-2: Slackware64 14.2, xfsprogs 4.3.0, 4.4.19 kernel
> 
> On PC-1 with an xfs created many years ago, xfs_info reports bigtime=0 (as
> expected).  Two tests were run:
> 
>  * > touch -d '1800/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 jwoithe users 0 1901-12-14 06:15:52.000000000 +0930 foobar
> 
>  * > touch -d '2100/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 jwoithe users 0 2038-01-19 13:44:07.000000000 +1030 foobar
> 
> Both results are entirely as expected: the times are clamped to the minimum
> and maximum values.  The +0930 timezone in the 1901 date is due to there
> being no daylight saving in operation in 1901.
> 
> A newly created xfs is also on PC-1 where bigtime was requested during
> mkfs.xfs.  Bigtime is confirmed set according to xfs_info.  Three tests were
> run:
> 
>  * > touch -d '1800/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 radar users 0 1901-12-14 06:15:52.000000000 +0930 foobar
> 
>  * > touch -d '2100/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 radar users 0 2100-01-01 02:23:45.670000000 +1030 foobar
> 
>  * > touch -d '2800/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 radar users 0 2486-07-03 05:50:24.000000000 +0930 foobar
> 
> Again, everything is as expected.  Bigtime expands the maximum time out to
> 2486 as advertised.  The +0930 timezone in the last result is due to there
> being no daylight saving in July.
> 
> Turning to PC-2, things became confusing.  This older enviroment also has an
> xfs created many years ago.  Two tests were run:
> 
>  * > touch -d '1800/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 jwoithe users 0 1800-01-01 02:23:45.670000000 +0914 foobar
> 
>  * > touch -d '2100/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 jwoithe users 0 2100-01-01 02:23:45.670000000 +1030 foobar
> 
> Since the kernel on PC-2 is way earlier than 5.10 and its xfs filesystems
> predate bigtime, I would have expected the times to be clamped between
> 1901 and 2038.  However, it seems that the system somehow manages to store
> the out-of-bound years.  Doing so has an interesting effect on the timezone
> offset for the pre-1901 years, but for years beyond 2038 there is no
> directly observable problem.  Incidently, running
> 
>   stat foobar
> 
> happily reports the extended date in this case too:
> 
>   Access: 2100-01-01 02:23:45.670000000 +1030
>   Modify: 2100-01-01 02:23:45.670000000 +1030
> 
> For a giggle I tried
> 
>   > touch -d '21000/01/01 02:23:45.67' foobar
> 
> and the system still managed to store the 5-digit year:
> 
>   -rw-r--r-- 1 jwoithe users 0 21000-01-01 02:23:45.670000000 +1030 foobar
> 
> This isn't what I expected.  Given an old userspace with an old kernel and
> old xfs filesystem, dates outside the 1901-2038 range should not be
> possible.  Given the apparent corruption of the timezone field when a year
> before 1901 is set, one naive thought is that the apparent success of these
> extended years on PC-2 (the old system) is due to a lack of bounds checking
> on the time value and (presumedly) some overflow within on-disc structures
> as a result.  This would have been noticed way before now though.
> 
> I am therefore curious about the reason for the above behaviour.  What
> subtlety am I missing?

Older kernels (pre-5.4 I think?) permitted userspace to store arbitrary
64-bit timestamps in the in-memory inode.  The fs would truncate (== rip
off the upper bits) them when writing them to disk, and then you'd get
the shattered remnants the next time the inode got reloaded from disk.

Nowadays, filesystems advertise the timestamp range they support, and
the VFS clamps the in-memory timestamp to that range.

--D

> While this may be a well known quirk, it is rather difficult to search for
> online.  I've tried a few things but they haven't turned up any relevant
> matches.  Apologies if this is an FAQ that I can't locate.
> 
> Regards
>   jonathan
