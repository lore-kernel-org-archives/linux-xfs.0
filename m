Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:38721 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbdHPJZb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 05:25:31 -0400
Received: by mail-wr0-f176.google.com with SMTP id m57so10788364wrm.5
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 02:25:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37b25b0f-6d8b-eed5-a16a-46e4ed2b6cd0@sandeen.net>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170811123037.15962-6-jtulak@redhat.com>
 <20170814230722.GI4796@magnolia> <CACj3i72vYNfPgPZkWn_UeL1fGmQv2YVTbe2=BkJxxevRd2+74w@mail.gmail.com>
 <37b25b0f-6d8b-eed5-a16a-46e4ed2b6cd0@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 16 Aug 2017 11:25:09 +0200
Message-ID: <CACj3i71-dUpnQmUeem_hqSn5fcD9-5rf9UAYEwzO9odhU91HHw@mail.gmail.com>
Subject: Re: [PATCH 5/6] mkfs: move getnum within the file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 15, 2017 at 11:09 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 8/15/17 5:14 AM, Jan Tulak wrote:
>> On Tue, Aug 15, 2017 at 1:07 AM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>>> On Fri, Aug 11, 2017 at 02:30:36PM +0200, Jan Tulak wrote:
>>>> Move getnum, check_opt and illegal_option within the file. We have to do
>>>> this to avoid dependency issues with the following patch. There is no
>>>> other change in this patch, just cut&paste of these functions.
>>>>
>>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>>> ---
>>>>  mkfs/xfs_mkfs.c | 236 ++++++++++++++++++++++++++++----------------------------
>>>>  1 file changed, 118 insertions(+), 118 deletions(-)
>>>>
>>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>>> index e3f7d345..3e7ba5f0 100644
>>>> --- a/mkfs/xfs_mkfs.c
>>>> +++ b/mkfs/xfs_mkfs.c
>>>> @@ -813,6 +813,124 @@ get_conf_raw_safe(const int opt, const int subopt)
>>>>       return str;
>>>>  }
>>>>
>>>> +static __attribute__((noreturn)) void
>>>> +illegal_option(
>>>
>>> How about declaring the functions at the top and leaving the definitions
>>> where they are?
>>
>> If I remember, Eric thought the opposite. :-)
>
> I don't remember, but at this point I'm ok with whatever, this part
> just isn't that important.
>

Just for the record, from the previous run:

On Thu, Jul 27, 2017 at 1:27 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 7/20/17 4:29 AM, Jan Tulak wrote:
>> Move getnum, check_opt and illegal_option within the file. We have to do
>> this to avoid dependency issues with the following patch. There is no
>> other change in this patch, just cut&paste of these functions.
>
> Yeah, nice to have these up at the top of the file anyway.
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

:-)

Jan
