Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60778 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbdHOVJU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Aug 2017 17:09:20 -0400
Subject: Re: [PATCH 5/6] mkfs: move getnum within the file
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170811123037.15962-6-jtulak@redhat.com> <20170814230722.GI4796@magnolia>
 <CACj3i72vYNfPgPZkWn_UeL1fGmQv2YVTbe2=BkJxxevRd2+74w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <37b25b0f-6d8b-eed5-a16a-46e4ed2b6cd0@sandeen.net>
Date: Tue, 15 Aug 2017 16:09:19 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i72vYNfPgPZkWn_UeL1fGmQv2YVTbe2=BkJxxevRd2+74w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 8/15/17 5:14 AM, Jan Tulak wrote:
> On Tue, Aug 15, 2017 at 1:07 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
>> On Fri, Aug 11, 2017 at 02:30:36PM +0200, Jan Tulak wrote:
>>> Move getnum, check_opt and illegal_option within the file. We have to do
>>> this to avoid dependency issues with the following patch. There is no
>>> other change in this patch, just cut&paste of these functions.
>>>
>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>> ---
>>>  mkfs/xfs_mkfs.c | 236 ++++++++++++++++++++++++++++----------------------------
>>>  1 file changed, 118 insertions(+), 118 deletions(-)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index e3f7d345..3e7ba5f0 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -813,6 +813,124 @@ get_conf_raw_safe(const int opt, const int subopt)
>>>       return str;
>>>  }
>>>
>>> +static __attribute__((noreturn)) void
>>> +illegal_option(
>>
>> How about declaring the functions at the top and leaving the definitions
>> where they are?
> 
> If I remember, Eric thought the opposite. :-)

I don't remember, but at this point I'm ok with whatever, this part
just isn't that important.

Thanks,
-Eric
