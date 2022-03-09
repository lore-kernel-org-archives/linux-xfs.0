Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FC0C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 07:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiCIHe1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 02:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiCIHe1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 02:34:27 -0500
X-Greylist: delayed 612 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 23:33:23 PST
Received: from server.atrad.com.au (server.atrad.com.au [150.101.241.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA4D10E56A
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 23:33:20 -0800 (PST)
Received: from marvin.atrad.com.au (IDENT:1008@marvin.atrad.com.au [192.168.0.2])
        by server.atrad.com.au (8.17.1/8.17.1) with ESMTPS id 2297N3pR026190
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 9 Mar 2022 17:53:05 +1030
Date:   Wed, 9 Mar 2022 17:53:03 +1030
From:   Jonathan Woithe <jwoithe@just42.net>
To:     linux-xfs@vger.kernel.org
Subject: Clarifying XFS behaviour for dates before 1901 and after 2038
Message-ID: <20220309072303.GE12332@marvin.atrad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-MIMEDefang-action: accept
X-Scanned-By: MIMEDefang 2.86 on 192.168.0.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all

Today I was running some file timestamping tests to get a feel for the
bigtime XFS option and to confirm that it was doing what I expected. 
Everything made sense until a certain point.

There are two systems:

 * PC-1: Slackware64 15.0, xfsprogs 5.13.0, 5.15.27 kernel

 * PC-2: Slackware64 14.2, xfsprogs 4.3.0, 4.4.19 kernel

On PC-1 with an xfs created many years ago, xfs_info reports bigtime=0 (as
expected).  Two tests were run:

 * > touch -d '1800/01/01 02:23:45.67' foobar
   > ls --full-time foobar
   -rw-r--r-- 1 jwoithe users 0 1901-12-14 06:15:52.000000000 +0930 foobar

 * > touch -d '2100/01/01 02:23:45.67' foobar
   > ls --full-time foobar
   -rw-r--r-- 1 jwoithe users 0 2038-01-19 13:44:07.000000000 +1030 foobar

Both results are entirely as expected: the times are clamped to the minimum
and maximum values.  The +0930 timezone in the 1901 date is due to there
being no daylight saving in operation in 1901.

A newly created xfs is also on PC-1 where bigtime was requested during
mkfs.xfs.  Bigtime is confirmed set according to xfs_info.  Three tests were
run:

 * > touch -d '1800/01/01 02:23:45.67' foobar
   > ls --full-time foobar
   -rw-r--r-- 1 radar users 0 1901-12-14 06:15:52.000000000 +0930 foobar

 * > touch -d '2100/01/01 02:23:45.67' foobar
   > ls --full-time foobar
   -rw-r--r-- 1 radar users 0 2100-01-01 02:23:45.670000000 +1030 foobar

 * > touch -d '2800/01/01 02:23:45.67' foobar
   > ls --full-time foobar
   -rw-r--r-- 1 radar users 0 2486-07-03 05:50:24.000000000 +0930 foobar

Again, everything is as expected.  Bigtime expands the maximum time out to
2486 as advertised.  The +0930 timezone in the last result is due to there
being no daylight saving in July.

Turning to PC-2, things became confusing.  This older enviroment also has an
xfs created many years ago.  Two tests were run:

 * > touch -d '1800/01/01 02:23:45.67' foobar
   > ls --full-time foobar
   -rw-r--r-- 1 jwoithe users 0 1800-01-01 02:23:45.670000000 +0914 foobar

 * > touch -d '2100/01/01 02:23:45.67' foobar
   > ls --full-time foobar
   -rw-r--r-- 1 jwoithe users 0 2100-01-01 02:23:45.670000000 +1030 foobar

Since the kernel on PC-2 is way earlier than 5.10 and its xfs filesystems
predate bigtime, I would have expected the times to be clamped between
1901 and 2038.  However, it seems that the system somehow manages to store
the out-of-bound years.  Doing so has an interesting effect on the timezone
offset for the pre-1901 years, but for years beyond 2038 there is no
directly observable problem.  Incidently, running

  stat foobar

happily reports the extended date in this case too:

  Access: 2100-01-01 02:23:45.670000000 +1030
  Modify: 2100-01-01 02:23:45.670000000 +1030

For a giggle I tried

  > touch -d '21000/01/01 02:23:45.67' foobar

and the system still managed to store the 5-digit year:

  -rw-r--r-- 1 jwoithe users 0 21000-01-01 02:23:45.670000000 +1030 foobar

This isn't what I expected.  Given an old userspace with an old kernel and
old xfs filesystem, dates outside the 1901-2038 range should not be
possible.  Given the apparent corruption of the timezone field when a year
before 1901 is set, one naive thought is that the apparent success of these
extended years on PC-2 (the old system) is due to a lack of bounds checking
on the time value and (presumedly) some overflow within on-disc structures
as a result.  This would have been noticed way before now though.

I am therefore curious about the reason for the above behaviour.  What
subtlety am I missing?

While this may be a well known quirk, it is rather difficult to search for
online.  I've tried a few things but they haven't turned up any relevant
matches.  Apologies if this is an FAQ that I can't locate.

Regards
  jonathan
