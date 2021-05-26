Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E518C2B9F7
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 05:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7D5613C1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 05:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhEZFFU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 01:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhEZFFU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 May 2021 01:05:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07C35613B9
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 05:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622005429;
        bh=VSmQUmqG1CRZl7R8Bsmq0PcHZ2KEhmWyR5IAfj1e/lc=;
        h=Date:From:To:Subject:From;
        b=HWvYy5sTPlv7xGFHi7t+qJVZz7NvPfa+w0UvgqziJufhufNipMIUqSi4ThQ7EDRSV
         nr8u2qEroiFeKHoOs1c20Nh22/6VbH4wsgq7HRbK1OYUWmTvqDYP0AKKR7576txTkI
         L6g5uj+wS9elJeXWBbW9apNoD7bJYAN1adKuV5R6piuihs2PU4LQiRuC/cskQzpf0j
         SwXxeAtN2MVCL4ZL7JA7hIGHxreJcCpi5AG46YJ++mwLMhhjvI7YZYve1zUotD7bzR
         +k9EX1mD2Ul1rEcwQMNUwzqROR9E2m/XliIShNXmDhKyscfgF4P0td9ACcYLuCzOvS
         yf7wqCW/GWo/g==
Date:   Tue, 25 May 2021 22:03:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: we moved #xfs to oftc
Message-ID: <20210526050348.GW202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

We've moved the #xfs IRC channel to OFTC due to all the recent freenode
drama.  Let us know if you can't join the new channel.  At some point we
might have to make the access stricter (like we did on freenode) to stop
the bot spam, but in theory it should be easy to get in the new channel.

Please do not continue to use the old freenode channel.

Some Q&A:

- Why not post a notice in #xfs, you ask?

A short while ago, the btrfs folks found out the hard way that if you
leave any /topic breadcrumbs pointing people from freenode to another
network, the new admins will declare a policy violation, strip everyone
of channel op privileges, kick everyone off the channel, and erase the
topic.  We'll see how long "10 GOTO OTFC" lasts.

- Why not post a notice on the XFS wiki, you ask?

AFAIK nobody don't have write privileges.

- Why not post a notice on the /new/ XFS wiki, you ask?

The Linux Foundation required us to use their SSO service, which they
are now transitioning to a new third party provider, which means that
nobody can log in anymore.

- Why not use Matrix or something?

The LF have hinted that they might set up an instance, but nothing
concrete has come of that.  We could in theory decide ultimately to move
there, but until they make a public announcement, there's nothing for
public to do.  Also see previous answer.

--D
