Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36164 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdIJASx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 20:18:53 -0400
Received: by mail-pg0-f68.google.com with SMTP id d8so2977187pgt.3
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 17:18:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9ba360ec-ef78-ad8d-c83e-9b95f7d60e60@sandeen.net>
References: <20170909150230.44139-1-raj.khem@gmail.com> <9ba360ec-ef78-ad8d-c83e-9b95f7d60e60@sandeen.net>
From: Khem Raj <raj.khem@gmail.com>
Date: Sat, 9 Sep 2017 17:18:22 -0700
Message-ID: <CAMKF1soFadOi=4EEAZgV4ufmPeFqKRbfMJmUr0W9hCjqPq1YZQ@mail.gmail.com>
Subject: Re: [PATCH] xfsdump: Use c99 defined int64_t instead of __int64_t
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 9, 2017 at 12:09 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Seems fine, but are the __uint32_t instances in the code not a problem?
>

yes they are and I had a seprate patch for them, which I will send
once  I have fixed the tab formatting issues with it. May be I should squash
then into one

> Thanks,
> -Eric
>
> On 9/9/17 10:02 AM, Khem Raj wrote:
>> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>> ---
>>  common/hsmapi.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/common/hsmapi.c b/common/hsmapi.c
>> index 6054773..0709dbe 100644
>> --- a/common/hsmapi.c
>> +++ b/common/hsmapi.c
>> @@ -585,7 +585,7 @@ HsmModifyExtentMap(
>>       struct getbmapx *bmap)
>>  {
>>       dmf_f_ctxt_t    *dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
>> -     __int64_t       length;
>> +     int64_t         length;
>>
>>       if (bmap[0].bmv_entries <= 0) {
>>               return 1;       /* caller must already be at EOF */
>>
