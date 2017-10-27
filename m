Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932428AbdJ0MtB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 08:49:01 -0400
Subject: Re: [PATCH 2/2] generic: Adjust generic test ouputs for new fiemap
 implementation
References: <1509107832-22286-1-git-send-email-nborisov@suse.com>
 <1509107832-22286-5-git-send-email-nborisov@suse.com>
 <20171027124604.GY3235@eguan.usersys.redhat.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e8c6a659-6131-7f10-827c-32fdb744e3d8@suse.com>
Date: Fri, 27 Oct 2017 15:48:58 +0300
MIME-Version: 1.0
In-Reply-To: <20171027124604.GY3235@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org



On 27.10.2017 15:46, Eryu Guan wrote:
> On Fri, Oct 27, 2017 at 03:37:12PM +0300, Nikolay Borisov wrote:
>>  Since xfs_io's fiemap implementation was changed to explicitly show a whole
>>  when a file consists only of it adjust the output of various test accordingly. 
>>  Essentially only test 1 and 10 of _test_generic_punch require changes
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  tests/generic/012.out | 1 +
>>  tests/generic/016.out | 1 +
>>  tests/generic/021.out | 2 ++
>>  tests/generic/022.out | 2 ++
>>  tests/generic/058.out | 1 +
>>  tests/generic/060.out | 1 +
>>  tests/generic/061.out | 1 +
>>  tests/generic/063.out | 1 +
>>  tests/generic/255.out | 6 ++++++
>>  tests/generic/316.out | 6 ++++++
>>  10 files changed, 22 insertions(+)
>>
>> diff --git a/tests/generic/012.out b/tests/generic/012.out
>> index ffbf8a3..8045471 100644
>> --- a/tests/generic/012.out
>> +++ b/tests/generic/012.out
>> @@ -1,5 +1,6 @@
>>  QA output created by 012
>>  	1. into a hole
>> +0: [0..95]: hole
> 
> I suspect this will break test runs with old xfs_io too (and again, I
> haven't confirmed yet..). Perhaps we need some kind of filter?

You are right it will indeed break with old xfs_io so some solution need
to be created. At this time I'm more interested to see if people will
accept the fiemap code and if there is agreement I will focus on
creating such a filter.

> 
> Thanks,
> Eryu
> 
