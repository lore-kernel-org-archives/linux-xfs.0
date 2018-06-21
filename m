Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36406 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933331AbeFUVuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 17:50:13 -0400
Received: by mail-oi0-f68.google.com with SMTP id 14-v6so4340762oie.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 14:50:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia> <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de> <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 21 Jun 2018 15:50:11 -0600
Message-ID: <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
Subject: Re: Mounting xfs filesystem takes long time
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Jun 21, 2018 at 1:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 6/21/18 2:15 PM, Luis R. Rodriguez wrote:
>> On Tue, Jun 19, 2018 at 02:21:15PM -0500, Eric Sandeen wrote:
>>> On 6/19/18 11:18 AM, Darrick J. Wong wrote:
>>>> On Tue, Jun 19, 2018 at 02:27:29PM +0200, swadmin - levigo.de wrote:
>>>>> Hi @all
>>>>> I have a problem with mounting a large XFS filesystem which takes about
>>>>> 8-10 minutes.
>>>>>
>>>>>
>>>>>
>>>>> :~# df -h /graylog_data
>>>>> Filesystem                       Size  Used Avail Use% Mounted on
>>>>> /dev/mapper/vgdata-graylog_data   11T  5.0T  5.1T  50% /graylog_data
>>>>>
>>>>> ----
>>>>>
>>>>> :~# xfs_info /dev/mapper/vgdata-graylog_data
>>>>> meta-data=/dev/mapper/vgdata-graylog_data isize=512    agcount=40805,
>>>>> agsize=65792 blks
>>>>
>>>> 41,000 AGs is a lot of metadata to load.  Did someone growfs a 1G fs
>>>> into a 11T fs?
>>>
>>> <answer: yes, they did>
>>>
>>> Let me state that a little more clearly: this is a badly mis-administered
>>> filesystem; 40805 x 256MB AGs is nearly unusable, as you've seen.
>>>
>>> If at all possible I would start over with a rationally-created filesystem
>>> and migrate the data.
>>
>> Considering *a lot* of folks may typically follow the above "trap", wouldn't it
>> be wise for userspace to complain or warn when the user may want to do
>> something stupid like this? Otherwise I cannot see how we could possibly
>> conceive that this is badly administered filesystem.
>
> Fair point, though I'm not sure where such a warning would go.  growfs?
> I'm not a big fan of the "you asked for something unusual, continue [y/N]?"
> type prompts.
>
> To people who know how xfs is laid out it's "obvious" but it's not fair to
> assume every admin knows this, you're right.  So calling it mis-administered
> was a bit harsh.
>

The extreme case is interesting to me, but even more interesting are
the intermediate cases. Is it straightforward to establish a hard and
fast threshold? i.e. do not growfs more than 1000% from original size?
Do not growfs more than X times?

Or is it a linear relationship between performance loss and each
additional growfs?


-- 
Chris Murphy
