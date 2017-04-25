Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33009 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176055AbdDYHqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2017 03:46:14 -0400
Received: by mail-ua0-f172.google.com with SMTP id j59so82518943uad.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Apr 2017 00:46:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170425030421.GH28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-5-jtulak@redhat.com>
 <20170425030421.GH28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 25 Apr 2017 09:45:53 +0200
Message-ID: <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 5:04 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Sun, Apr 23, 2017 at 08:54:55PM +0200, Jan Tulak wrote:
>> Merge separate instances of opt_params into one indexable table. Git
>> makes this patch looks a bit more complicated, but it does not change
>> values or structure of anything else. It only moves all the "struct
>> opt_params dopts = {...}", changes indentation for these substructures
>> and replaces their usage (dopts -> opts[OPT_D]).
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 1316 +++++++++++++++++++++++++++++--------------------------
>>  1 file changed, 683 insertions(+), 633 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 7a72b11..513e106 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -42,6 +42,7 @@ static int  ispow2(unsigned int i);
>>  uint64_t             blocksize;
>>  uint64_t             sectorsize;
>>
>> +#define MAX_OPTS     16
>
> This is fragile, every time a new opt is added this needs to be updated
> and so is the index, and we should be pedantic over not going out of bounds.
> We could instead use a flexible array and compute the max opts at run time
> as a global. This way the max opts is always updated automatically.


Mmm, that is a good idea and I see no issue with it. But I'm not sure
if it is worth of rewriting this patch as we already use MAX_SUBOPTS
anyway. Rather I see it as a standalone patch in the next set. What do
you think?

>
>>  #define MAX_SUBOPTS  16
>>  #define SUBOPT_NEEDS_VAL     (-1LL)
>>  #define MAX_CONFLICTS        8
>> @@ -60,6 +61,10 @@ uint64_t           sectorsize;
>>   *
>>   * Description of the structure members follows:
>>   *
>> + * index MANDATORY
>> + *   An integer denoting the position of the specific option in opts array,
>> + *   counting from 0 up to MAX_OPTS.
>> + *
>>   * name MANDATORY
>>   *   Name is a single char, e.g., for '-d file', name is 'd'.
>>   *
>> @@ -132,6 +137,7 @@ uint64_t          sectorsize;
>>   * !!! END OF NOTE ===========================================================
>>   */
>>  struct opt_params {
>> +     int             index;
>
>
>>       const char      name;
>>       const char      *subopts[MAX_SUBOPTS];
>>
>> @@ -147,584 +153,592 @@ struct opt_params {
>>               uint64_t        flagval;
>>               const char      *raw_input;
>>       }               subopt_params[MAX_SUBOPTS];
>> -};
>> -
>> -struct opt_params bopts = {
>> -     .name = 'b',
>> -     .subopts = {
>> +}
>
> Do we really need to mesh the struct with the opts below ? I think it would
> make your patch easier to read if we kept the old tradition of splitting it,
> its not clear to me what the advantage is.
>
>> opts[MAX_OPTS] = {
>> +#define OPT_B        0
>
> I find these defines blinding on reading the struct declaration, we could
> instead just stuff them into an enum, which would also enable us to shift all
> the documentation into the header of the enum using whatever doc format we use.

The grouping is here to keep the style as it is with suboptions
index/string. However, all these defines (OPT_X and X_FOO) are
separated and moved into a single place later on in one patch anyway.
I just didn't include that patch in this set as I had to make the line
somewhere if I want to make multiple smaller and easier to review and
merge sets rather than the one big monster as before.

There is one point I'm not sure about, though. We have to restart the
counting for suboptions, like this:

enum subopts {
  B_size = 0,
  B_LOG,
  D_AGCOUNT = 0,
  D_...,
  L_xxx = 0,
  L_...,
}

I didn't found anywhere if it is a good practice or not. But again, I
just submitted it as it was with a note in my TODOs to find out more
out it and update the patch changing it later on.

Jan

>
> Below is a simple demo using a basic limited opt just to be clear about what I
> am suggesting, modulo, I think we want max_opts to be a global.
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <errno.h>
>
> #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
>
> enum opt_idx {
>         OPT_ZERO = 0,
>         OPT_ONE,
>         OPT_TWO,
> };
>
> struct opt {
>         unsigned int idx;
>         unsigned int val;
> };
>
> struct opt opts[] = {
>         {
>                 .idx = OPT_ZERO,
>                 .val = 0,
>         },
>         {
>                 .idx = OPT_ONE,
>                 .val = 1,
>         },
>         {
>                 .idx = OPT_TWO,
>                 .val = 2,
>         },
> };
>
> int main(int argc, char *argv[])
> {
>         unsigned int max_opts = ARRAY_SIZE(opts);
>         unsigned int i;
>
>         printf("Max size: %lu\n", max_opts);
>
>         for (i = 0; i < max_opts; i++) {
>                 printf("Val: %lu\n", opts[i].val);
>         }
>
>         return 0;
> }



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
