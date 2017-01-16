Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:38672 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdAPMoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2017 07:44:25 -0500
Received: by mail-it0-f41.google.com with SMTP id c7so20649840itd.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2017 04:44:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170113173637.GF23576@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-17-git-send-email-jtulak@redhat.com> <20170113173637.GF23576@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 16 Jan 2017 13:44:03 +0100
Message-ID: <CACj3i703NGM6ZAe6pBmjMic8MsF5gSmZmCEBxLk8aZHYNZKC_w@mail.gmail.com>
Subject: Re: [PATCH 16/22] mkfs: Change all value fields in opt structures
 into unions
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 6:36 PM, Bill O'Donnell <billodo@redhat.com> wrote:
> On Wed, Dec 07, 2016 at 02:27:23PM +0100, Jan Tulak wrote:
>> Trying to cover all possible values in a single data type is impossible,
>> so convert the field from long long type to union. This requires
>> also some small changes in supporting code, otherwise it would not compile.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 812 +++++++++++++++++++++++++++++++++++---------------------
>>  1 file changed, 504 insertions(+), 308 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 7ffe8ff..afc63d1 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -121,6 +121,231 @@ unsigned int            sectorsize;
>>  #define M_RMAPBT     3
>>  #define M_REFLINK    4
>>
>> [snip]
>>
>> @@ -576,13 +831,15 @@ struct opt_params {
>>               },
>>               .subopt_params = {
>>                       { .index = L_AGNUM,
>> +                       /* FIXME custom type xfs_agnumber_t? */
>
> Does something really need to be fixed here?
>

Maybe: xfs_agnumber_t is defined as __uint32_t, while the code there
is using unsigned int. Which could possibly cause some issues if a
compiler would not treat int as 32 bits. Though we have a lot of other
custom/generic types mismatches around in the code, and it seems
unlikely that GCC or Clang would ever change how big int is... so
perhaps we can let it be. Or maybe let's change the definition of the
union so instead of unsigned int it is __uint32_t?

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
