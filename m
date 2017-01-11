Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38562 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752292AbdAKDAn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 22:00:43 -0500
Subject: Re: Generic/389 xfs_io segfault on btrfs and ext4
References: <ca7ae533-8d7f-9783-1900-bdfb17d6a32c@cn.fujitsu.com>
 <d5116871-0bb3-46b0-c9e3-def74bd57967@sandeen.net>
 <5c56afcd-13b0-d3b3-e18c-0b902691d8f4@cn.fujitsu.com>
 <c5ea839d-1962-e363-d83b-936328f985df@redhat.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8e1e082b-11c0-e597-cd38-744938537c2e@cn.fujitsu.com>
Date: Wed, 11 Jan 2017 11:00:29 +0800
MIME-Version: 1.0
In-Reply-To: <c5ea839d-1962-e363-d83b-936328f985df@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, agruenba@redhat.com, btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org



At 01/11/2017 10:53 AM, Eric Sandeen wrote:
> On 1/10/17 8:45 PM, Qu Wenruo wrote:
>>
>>
>> At 01/11/2017 10:40 AM, Eric Sandeen wrote:
>
> ...
>
>>> What version of kernel and xfsprogs were you testing, and what was the segfault?
>>
>> Kernel is mainline v4.10-rc1.
>> No debuginfo installed, so no backtrace, but since there is so many
>>
>> So the problem is the old xfsprogs, I'll update or compile xfsprogs.
>> Thanks for your kind info.
>
> Just FWIW, I always have latest xfsprogs in rawhide, but I don't usually push
> to other fedoras.
>
> It should be easy to grab
> https://kojipkgs.fedoraproject.org/packages/xfsprogs/4.9.0/1.fc26/src/xfsprogs-4.9.0-1.fc26.src.rpm
> and rebuild & install.

Thanks for the info.

I have already compiled latest version and it works perfectly.

BTW, just wonder if or when Fedora will do rolling release, which should 
avoid such problem.

Thanks,
Qu
>
> -Eric
>
>
>


