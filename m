Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58640 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdKIRiw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 12:38:52 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 457DD8A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2017 11:38:52 -0600 (CST)
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 8743fab / 4.14.0-rc1
From: Eric Sandeen <sandeen@sandeen.net>
References: <50f1c0a1-c0d7-5ac8-f584-88cb13e06461@sandeen.net>
Message-ID: <61a078a9-7aca-e85b-ac5e-0963b6384586@sandeen.net>
Date: Thu, 9 Nov 2017 11:38:51 -0600
MIME-Version: 1.0
In-Reply-To: <50f1c0a1-c0d7-5ac8-f584-88cb13e06461@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On 11/9/17 11:12 AM, Eric Sandeen wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated and tagged with 4.14.0-rc1
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> Goldwyn, I'd like to get your pwritev2 stuff in for 4.14.0-rc2, sorry
> for the late review on that.
> 
> I don't expect much more for 4.14.0, hope to get it out soon and then
> pull in all the exciting new stuff on the list.
> 
> The new head of the master branch is commit:
> 
> 1480ecc xfs_repair: always release btree buffers when refcountbt checks fail

Make that:

8743fab xfs_repair: always release btree buffers when refcountbt checks fail

Sorry, had a stray bit sneak in so did a quick forced update to fix it.
Hopefully that only affects djwong who eagerly pulls everything ASAP.  :)

-Eric
