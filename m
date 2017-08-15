Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:38668 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753276AbdHOKPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 06:15:17 -0400
Received: by mail-wr0-f174.google.com with SMTP id m57so1726074wrm.5
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 03:15:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170814230722.GI4796@magnolia>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170811123037.15962-6-jtulak@redhat.com>
 <20170814230722.GI4796@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 15 Aug 2017 12:14:55 +0200
Message-ID: <CACj3i72vYNfPgPZkWn_UeL1fGmQv2YVTbe2=BkJxxevRd2+74w@mail.gmail.com>
Subject: Re: [PATCH 5/6] mkfs: move getnum within the file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 15, 2017 at 1:07 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Aug 11, 2017 at 02:30:36PM +0200, Jan Tulak wrote:
>> Move getnum, check_opt and illegal_option within the file. We have to do
>> this to avoid dependency issues with the following patch. There is no
>> other change in this patch, just cut&paste of these functions.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 236 ++++++++++++++++++++++++++++----------------------------
>>  1 file changed, 118 insertions(+), 118 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index e3f7d345..3e7ba5f0 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -813,6 +813,124 @@ get_conf_raw_safe(const int opt, const int subopt)
>>       return str;
>>  }
>>
>> +static __attribute__((noreturn)) void
>> +illegal_option(
>
> How about declaring the functions at the top and leaving the definitions
> where they are?

If I remember, Eric thought the opposite. :-)

Jan
