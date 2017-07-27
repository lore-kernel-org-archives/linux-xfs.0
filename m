Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35343 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdG0HvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 03:51:15 -0400
Received: by mail-wm0-f53.google.com with SMTP id c184so97577253wmd.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 00:51:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5b66fcad-4cd4-d1d2-611e-56bcb8004dd4@sandeen.net>
References: <20170720092932.32580-1-jtulak@redhat.com> <20170720092932.32580-4-jtulak@redhat.com>
 <20170720155404.GS4224@magnolia> <5b66fcad-4cd4-d1d2-611e-56bcb8004dd4@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 27 Jul 2017 09:50:53 +0200
Message-ID: <CACj3i73cMx9GvY=VQzVZyr5nvU-wiT-n4jweX=ccDUzOTzwY8w@mail.gmail.com>
Subject: Re: [PATCH 3/7] mkfs: remove intermediate getstr followed by getnum
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jul 26, 2017 at 10:49 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 7/20/17 10:54 AM, Darrick J. Wong wrote:
>> On Thu, Jul 20, 2017 at 11:29:28AM +0200, Jan Tulak wrote:
>>> Some options loaded a number as a string with getstr and converted it to
>>> number with getnum later in the code, without any reason for this
>>> approach.  (They were probably forgotten in some past cleaning.)
>>>
>>> This patch changes them to skip the string and use getnum directly in
>>> the main option-parsing loop, as do all the other numerical options.
>>> And as we now have two variables of the same type for the same value,
>>> merge them together. (e.g. former string dsize and number dbytes).
>>>
>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>> Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>
>>>
>>> ---
>>> In reply to Eric's comment, so it doesn't pop up again:
>>> This patch has to be applied after "mkfs: Save raw user input ...",
>>> because otherwise we would temporary lose the access to strings
>>> with user-given values and thus wouldn't be able to report them in
>>> case of any issue.
>>> ---
>>>  mkfs/xfs_mkfs.c | 90 ++++++++++++++++++++++++++-------------------------------
>>>  1 file changed, 41 insertions(+), 49 deletions(-)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index f2f6468e..127f14c3 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -1345,6 +1345,7 @@ getnum(
>>>      long long               c;
>>>
>>>      check_opt(opts, index, false);
>>> +    set_conf_raw(opts, index, str);
>>>      /* empty strings might just return a default value */
>>>      if (!str || *str == '\0') {
>>>              if (sp->flagval == SUBOPT_NEEDS_VAL)
>>> @@ -1432,12 +1433,12 @@ main(
>>>      char                    *dfile;
>>>      int                     dirblocklog;
>>>      int                     dirblocksize;
>>> -    char                    *dsize;
>>> +    int                     dbytes;
>
> <snip>
>
>
>>> @@ -2179,10 +2180,7 @@ _("rmapbt not supported with realtime devices\n"));
>>>      }
>>>
>>>
>>> -    if (dsize) {
>>> -            __uint64_t dbytes;
>>> -
>>> -            dbytes = getnum(dsize, &dopts, D_SIZE);
>>> +    if (dbytes) {
>>
>> Why has dbytes been demoted from uint64_t to int?  This eliminates the
>> ability to -d size=8G, right?
>
> That wasn't a problem in the version I reviewed.... pls don't keep reviewed-by's
> on patches that change from the reviewed version.  Further, best to indicate
> explicitly what has changed since the last version, under the "---"
>

Yes, I'm sorry about that. :( I forgot to remove the Reviewed-by after
rebasing it without the uint64 change. :(

Jan

> Thanks,
> -Eric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
