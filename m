Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:37112 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdG1Onj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2017 10:43:39 -0400
Received: by mail-wr0-f172.google.com with SMTP id 33so99431417wrz.4
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2017 07:43:39 -0700 (PDT)
Subject: Re: [PATCH 1/5 v2] mkfs: replace variables with opts table: -b,d,s
 options
References: <20170720095156.35417-2-jtulak@redhat.com>
 <20170721123448.6956-1-jtulak@redhat.com>
 <20170727163935.GL18884@wotan.suse.de>
 <08b84b1c-dbe9-8391-8c52-c7e7afbab27c@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <0573c58f-7759-d113-f8da-208d82321194@redhat.com>
Date: Fri, 28 Jul 2017 16:43:36 +0200
MIME-Version: 1.0
In-Reply-To: <08b84b1c-dbe9-8391-8c52-c7e7afbab27c@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On 28/07/2017 04:18, Eric Sandeen wrote:
> On 7/27/17 11:39 AM, Luis R. Rodriguez wrote:
>> On Fri, Jul 21, 2017 at 02:34:48PM +0200, Jan Tulak wrote:
>>> @@ -1609,6 +1593,7 @@ main(
>>>   			break;
>>>   		case 'b':
>>>   			p = optarg;
>>> +			uint64_t tmp;
>> Note:
>>
>> An extra variable added, just so we can get the current value parsed
>> so we can then convert it to also set similar collateral variables.
> Also, please don't declare variables in the middle of code like this,
> we generally stick to C89 rules.
>
> Thanks,
> -Eric
OK

Jan
