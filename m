Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B7FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Dec 2021 22:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345742AbhLBWzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 17:55:22 -0500
Received: from sandeen.net ([63.231.237.45]:33006 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241825AbhLBWzW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Dec 2021 17:55:22 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7668E793D
        for <linux-xfs@vger.kernel.org>; Thu,  2 Dec 2021 16:51:58 -0600 (CST)
Message-ID: <3d19d9c1-9d21-7d43-de7f-9e54cc4d2da8@sandeen.net>
Date:   Thu, 2 Dec 2021 16:51:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [ANNOUNCE] xfsprogs xfsprogs 5.14.2 released
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>
References: <40e4f1bd-2e97-1a04-dfd2-74dfed249f52@sandeen.net>
In-Reply-To: <40e4f1bd-2e97-1a04-dfd2-74dfed249f52@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It just wouldn't be a release announcement w/o a typo.

It really is 5.14.1.

-Eric

On 12/2/21 4:47 PM, Eric Sandeen wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
>      git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> This is a minor update to fix up build issues on unique architectures
> and cross-builds.  Thanks Darrick!
> 
> Tarballs are available at:
> 
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.14.1.tar.gz
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.14.1.tar.xz
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.14.1.tar.sign
> 
> The new head of the master branch is commit:
> 
> The new head of the master branch is commit:
> 
> 0e0de366 xfsprogs: Release v5.14.1
> 
> New Commits:
> 
> Darrick J. Wong (2):
>        [27aa8086] libfrog: fix crc32c self test code on cross builds
>        [7448af58] libxfs: fix atomic64_t poorly for 32-bit architectures
> 
> Eric Sandeen (1):
>        [0e0de366] xfsprogs: Release v5.14.1
> 
> 
> Code Diffstat:
> 
>   VERSION              |  2 +-
>   configure.ac         |  3 ++-
>   debian/changelog     |  6 ++++++
>   doc/CHANGES          |  4 ++++
>   include/atomic.h     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>   include/builddefs.in |  4 ++++
>   include/libxlog.h    |  4 ++--
>   libfrog/crc32.c      |  7 ++++++-
>   libxfs/init.c        |  4 ++++
>   m4/package_urcu.m4   | 19 +++++++++++++++++++
>   repair/phase2.c      |  2 +-
>   11 files changed, 95 insertions(+), 6 deletions(-)
