Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43558 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfADXLw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 18:11:52 -0500
Subject: Re: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
References: <20181105213145.7560-1-stefanrin@gmail.com>
 <20181105213145.7560-3-stefanrin@gmail.com> <20190103175504.GD20475@magnolia>
 <CAAxjCEytZ4U8K6CPJFBguTSocH_bmxxoEvZ-HkZuFc=QwrZbBQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <704cb245-cc28-5c98-0418-e92b84d20f22@sandeen.net>
Date: Fri, 4 Jan 2019 17:11:49 -0600
MIME-Version: 1.0
In-Reply-To: <CAAxjCEytZ4U8K6CPJFBguTSocH_bmxxoEvZ-HkZuFc=QwrZbBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/4/19 4:27 PM, Stefan Ring wrote:
> On Thu, Jan 3, 2019 at 6:55 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> On Mon, Nov 05, 2018 at 10:31:42PM +0100, Stefan Ring wrote:
>>> Using basically the same code as in process_single_fsb_objects.
>>>
>>> Signed-off-by: Stefan Ring <stefanrin@gmail.com>
>>> ---
>>>  db/metadump.c | 19 ++++++++++++-------
>>>  1 file changed, 12 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/db/metadump.c b/db/metadump.c
>>> index 97d2a490..be7cf360 100644
>>> --- a/db/metadump.c
>>> +++ b/db/metadump.c
>>> @@ -1921,15 +1922,19 @@ process_multi_fsb_objects(
>>>
>>>                       }
>>>
>>> -                     if ((!obfuscate && !zero_stale_data) ||
>>
>> Hmmm, if we're not obfuscating or zeroing data, can we still jump to
>> write_buf()?
>>
>> --D
> 
> The call to write_buf() is always necessary, as without this, nothing
> would end up in the metadump. But while trying to argue the soundness
> of this patch, I have found deficiencies ;). It will always call
> process_dir_data_block, even without any zeroing/obfuscation flags
> set.

Right, I think that was Darrick's point.  (I had noticed this too but
have been woefully slow in replying.)

> I must have considered this harmless, since it does not actually
> "do" anything, but I'm not so sure anymore because it may complain
> about data inconsistencies, and this might make an otherwise dumpable
> image non-dumpable.

Yup, exactly.  You're good!  ;)

> It is also, at least in theory, able to reset the
> need_crc back to zero, contrary to all the other usages of this flag
> in this file. I don't think this is an actual problem, as the flag
> only seems to be set when zeroing or obfuscating in the first place,
> but it might become one if circumstances far removed from this
> location change. It is just too much of a mental burden.

I feel like the whole need_crc business could be cleaned up, TBH (later).

> I will redo this once again so that it will be more similar in
> structure to the code in process_single_fsb_objects _and_ the original
> code, I hope.

FWIW, I've been running all of xfstests in various permutations with a patch
to dump and restore and xfs_repair an image after each run, using each of
"" "-o" "-a" and "-oa" as metadump arguments.  Some corruptions have
appeared, but I don't yet know if they're regressions or not.
(i.e. the filesystem was intact but the restored metadump was not.)

I'll let the run finish and re-run the failed tests w/ stock code and see
what I find.

-Eric
