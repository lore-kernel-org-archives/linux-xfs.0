Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751925AbdAKCxg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 21:53:36 -0500
Subject: Re: Generic/389 xfs_io segfault on btrfs and ext4
References: <ca7ae533-8d7f-9783-1900-bdfb17d6a32c@cn.fujitsu.com>
 <d5116871-0bb3-46b0-c9e3-def74bd57967@sandeen.net>
 <5c56afcd-13b0-d3b3-e18c-0b902691d8f4@cn.fujitsu.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <c5ea839d-1962-e363-d83b-936328f985df@redhat.com>
Date: Tue, 10 Jan 2017 20:53:34 -0600
MIME-Version: 1.0
In-Reply-To: <5c56afcd-13b0-d3b3-e18c-0b902691d8f4@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, agruenba@redhat.com, btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On 1/10/17 8:45 PM, Qu Wenruo wrote:
> 
> 
> At 01/11/2017 10:40 AM, Eric Sandeen wrote:

...

>> What version of kernel and xfsprogs were you testing, and what was the segfault?
> 
> Kernel is mainline v4.10-rc1.
> No debuginfo installed, so no backtrace, but since there is so many
> 
> So the problem is the old xfsprogs, I'll update or compile xfsprogs.
> Thanks for your kind info.

Just FWIW, I always have latest xfsprogs in rawhide, but I don't usually push
to other fedoras.

It should be easy to grab
https://kojipkgs.fedoraproject.org/packages/xfsprogs/4.9.0/1.fc26/src/xfsprogs-4.9.0-1.fc26.src.rpm
and rebuild & install.

-Eric

