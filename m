Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:28792 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727097AbfEJIwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 04:52:21 -0400
Message-ID: <5CD53BBD.1050605@cn.fujitsu.com>
Date: Fri, 10 May 2019 16:52:13 +0800
From: xuyang <xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] fstests: various fixes
References: <155724821034.2624631.4172554705843296757.stgit@magnolia> <5CD38E98.8000705@cn.fujitsu.com> <20190510084720.GG15846@desktop>
In-Reply-To: <20190510084720.GG15846@desktop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

on 2019/05/10 16:47, Eryu Guan wrote:

> On Thu, May 09, 2019 at 10:21:12AM +0800, xuyang wrote:
>> on 2019/05/08 0:56, Darrick J. Wong wrote:
>>> Hi all,
>>>
>>> Here are three patches fixing various regressions in xfstests when
>>> mkfs.xfs defaults to enabling reflink and/or rmap by default.  Most of
>>> the changes deal with the change in minimum log size requirements.  They
>>> weren't caught until now because there are a number of tests that call
>>> mkfs on a loop device or a file without using MKFS_OPTIONS.
>>>
>>> If you're going to start using this mess, you probably ought to just
>>> pull from my git trees, which are linked below.
>>>
>>> This is an extraordinary way to destroy everything.  Enjoy!
>>> Comments and questions are, as always, welcome.
>>>
>>> --D
>>>
>>> fstests git tree:
>>> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
>>>
>>>
>>>
>> Hi
>>
>> Tested-by: Yang Xu<xuyang2018.jy@cn.fujitsu.com>
> Thanks for the testing! Just want to make sure that you tested all the
> three patches so that I can add your Tested-by tag too all of them?
>
> Thanks,
> Eryu
Hi Eryu

Yes.  I tested all the three patches.

>
>
