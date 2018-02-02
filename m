Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36840 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753352AbeBBRw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 12:52:57 -0500
Received: by mail-lf0-f65.google.com with SMTP id t79so32700734lfe.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Feb 2018 09:52:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2fa49e30-aed9-a023-ea8e-1d2e4907e7b9@sandeen.net>
References: <1517517463-99951-1-git-send-email-marco.antonio.780@gmail.com>
 <3c874559-f69f-c2c0-fb40-4c40621dd58b@sandeen.net> <20180201222804.GU4849@magnolia>
 <2fa49e30-aed9-a023-ea8e-1d2e4907e7b9@sandeen.net>
From: Marco Benatto <marco.antonio.780@gmail.com>
Date: Fri, 2 Feb 2018 15:52:54 -0200
Message-ID: <CADHkTqXAM5yvf+BG84zr2YFckpvyzFRoOQkiJu5W2t=CEiud5w@mail.gmail.com>
Subject: Re: [PATCH] xfs_mdrestore: Don't restore over a dump file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Thanks all for the feedback and nice catch regarding the rewind + stdin reading.

I'm currently working on a patch which should cover (following
Sandeen's suggestions) the items Darrick has brought.

I should send this soon.

Thanks,

On Thu, Feb 1, 2018 at 8:39 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/1/18 4:28 PM, Darrick J. Wong wrote:
>> On Thu, Feb 01, 2018 at 02:50:19PM -0600, Eric Sandeen wrote:
>>> On 2/1/18 2:37 PM, Marco A Benatto wrote:
>>>> Currently, if the user switch source and target parameters
>>>> position, xfs_mdrestore truncates the dumpfile before abort
>>>> the execution.
>>>>
>>>> This patch checks the target parameter and if XFS_MD_MAGIC is
>>>> found, it aborts execution and leave dump file intact.
>>>
>>> Yeah, I think this is a good idea.  It's pretty unforgiving
>>> to get it wrong and destroy your metadump in the process.
>>>
>>> (though tbh I usually get a compressed dump, and
>>> # bzcat dumpfile.bz2 | xfs_mdrestore - target
>>> works quite well and is more foolproof)
>>>
>>> So, despite the fact that I already talked with you about
>>> this a bit online, I think my subconscious was working on
>>> it in the meantime.  What you've got is generally ok, but
>>> I wonder if the goal is to detect switched arguments, if
>>> it might be simpler to first validate the given source, and
>>> stop if it's not a metadump file.  We've already got that in
>>> place, and it'd just be a question of checking the header
>>> unconditionally, something like this, which just moves some
>>> of the existing stuff work of the conditional:
>>>
>>>         xfs_metablock_t         mb;
>>>
>>>
>>>         /* validate that our source file is really a metadump */
>>>         if (fread(&mb, sizeof(mb), 1, src_f) != 1)
>>>                 fatal("error reading from source file: %s\n", strerror(errno));
>>>
>>>         if (be32_to_cpu(mb.mb_magic) != XFS_MD_MAGIC)
>>>                 fatal("specified source file is not a metadata dump\n");
>>>
>>>         if (show_info) {
>>>                 if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
>>>                         printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>>>                         argv[optind],
>>>                         mb.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
>>>                         mb.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
>>>                         mb.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
>>>                 } else {
>>>                         printf("%s: no informational flags present\n",
>>>                                 argv[optind]);
>>>                 }
>>>
>>>                 if (argc - optind == 1)
>>>                         exit(0);
>>>         }
>>>
>>>         /* Go back to the beginning for the restore function */
>>>         fseek(src_f, 0L, SEEK_SET);
>>
>> So now you got /me/ looking at mdrestore and wondering, if the metadump
>> source is a pipe (as in your example above), won't this seek fail?  We
>> already read the metadump super from the stream, so we can't seek
>> backwards and read it again:
>>
>> # cat foo.md | xfs_mdrestore -i - /dev/sda
>> -: not obfuscated, clean log, full metadata blocks
>> xfs_mdrestore: specified file is not a metadata dump
>>
>> Not to mention xfs_mdrestore --help doesn't tell you there's an -i
>> option.
>
> <there is no --help> ;)
>
> Neato!
>
>> Also, we already /do/ check that the source actually has a metadump
>> header, the problem is that we open the destination O_TRUNC before we
>> read the header and so if the target was a file, *poof* it's empty.
>
> hhmm yeah.
>
>> I think we'll need to fix both of those problems.  Maybe we solve it by
>> opening src_f, checking the magic, optionally printing the metadump
>> info, and then passing both src_f and the header into perform_restore?
>>
>> Separate patch, though.
>
> right, and make perform_restore know that we're already past the first
> header block, right.  Simply moving the first fread out of perform_restore
> would do the trick.  Would need to pass the read metablock into the
> restore function.
>
> yeah that makes sense.
>
>>> It's not explicitly checking the target, but it would probably serve
>>> the same purpose with fewer lines of new code.  Either is ok with me,
>>> really.  Any thoughts?
>>>
>>> Thanks,
>>> -Eric
>>>
>>>
>>>>
>>>> Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>
>>>> ---
>>>>  mdrestore/xfs_mdrestore.c | 16 +++++++++++++++-
>>>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>>>> index c49c13a..b4bf7b4 100644
>>>> --- a/mdrestore/xfs_mdrestore.c
>>>> +++ b/mdrestore/xfs_mdrestore.c
>>>> @@ -205,7 +205,7 @@ main(
>>>>     int             argc,
>>>>     char            **argv)
>>>>  {
>>>> -   FILE            *src_f;
>>>> +   FILE            *src_f, *dst_f;
>>>>     int             dst_fd;
>>>>     int             c;
>>>>     int             open_flags;
>>>> @@ -277,6 +277,7 @@ main(
>>>>
>>>>     optind++;
>>>>
>>>> +
>>>>     /* check and open target */
>>>>     open_flags = O_RDWR;
>>>>     is_target_file = 0;
>>>> @@ -285,6 +286,19 @@ main(
>>>>             open_flags |= O_CREAT;
>>>>             is_target_file = 1;
>>>>     } else if (S_ISREG(statbuf.st_mode))  {
>>>> +           xfs_metablock_t mb;
>>
>> dst_f could be declared here, right?
>>
>>>> +
>>>> +           dst_f = fopen(argv[optind], "rb");
>>>> +           if (dst_f == NULL)
>>>> +                   fatal("cannot open target\n");
>>>> +
>>>> +           if (fread(&mb, sizeof(mb), 1, dst_f) == 1) {
>>>> +                   if (be32_to_cpu(mb.mb_magic) == XFS_MD_MAGIC)
>>>> +                           fatal("target file is a xfs_metadump. switched arguments?\n");
>>>> +           }
>>
>> if (fread(&mb, sizeof(mb), 1, dst_f) == 1 &&
>>     mb.mb_magic == cpu_to_be32(XFS_MD_MAGIC))
>>       fatal("...");
>
> *nod*
>
> -Eric



-- 
Marco Antonio Benatto
Linux user ID: #506236
