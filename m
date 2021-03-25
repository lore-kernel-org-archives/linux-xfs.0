Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9385C433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6BA8619DC
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbhCYAoC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:44:02 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:51044 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbhCYAnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 20:43:42 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 12P0he3O020726
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 17:43:42 -0700
Message-ID: <605BDCBB.6070607@tlinx.org>
Date:   Wed, 24 Mar 2021 17:43:39 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re:  xfsdump | xfsrestore resulting in files->orphanage
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

oops, forgot to cc list.

-------- Original Message --------

On 2021/03/24 16:58, Eric Sandeen wrote:
> 
> This is a bug in root inode detection that Gao has fixed, and I really
> need to merge.
> 
> In the short term, you might try an older xfsdump version, 3.1.6 or earlier.
---
	In the short term -- I was dumping from a dumpdir
for a partition (just to make a copy of it on the new disk), but 
there was no real requirement to do so, so I just dumped from
the "source" dir, which for whatever reason didn't have the problem.

	My final try would have been to use rsync or such.
> 
> (Assuming you don't actually have a bind mount)
---
Not on that partition...
3.1.6?  Hasn't 318 been out for quite a while?

I looked through my bins only have 312 and 314 (and 318)...
tried 314, but it started out with the same inode confusion -- didn't
wait until it started spitting out any other errors.

 
> Sorry about that.
> 
> -Eric
---
	No prob.  Hey, one thing else you might wanna fix in 
xfsdump/restore that was fixed in xfs_fsr, is to 
put a posix_fadvise64(file->fd, offset, len, POSIX_FADV_DONTNEED)
before the read in xfsdump and on the write in xfs_restore.

	That way they'll let go of memory and won't end up
with pegged memory through-out the 'copy' - unless it is already
there, and then I have some other problem :-( .  But used all
8M of my swap (normally doesn't swap at all), shows a cpu
load of 3.4, and over 100% in wait-state.

	Just a hopeful suggestion.  I _think_ Dave put the
call in xfs_fsr (it would clear out memory everytime it ran, like
xfsdump/restore does now ;^)).


Thanks again for the possible cause...





