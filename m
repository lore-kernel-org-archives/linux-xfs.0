Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 401D17FEF
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 11:52:33 -0500 (CDT)
Message-ID: <5214F050.7060402@sgi.com>
Date: Wed, 21 Aug 2013 11:52:32 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130816205409.976658624@sgi.com> <5213F6AF.8070107@sandeen.net>
	<5214CB5C.4050608@sgi.com> <5214EAAC.80800@sandeen.net>
In-Reply-To: <5214EAAC.80800@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 08/21/13 11:28, Eric Sandeen wrote:
> On 8/21/13 9:14 AM, Mark Tinguely wrote:
>>
>> This patch started as an xfstest to test Jeff's advanced seek_data features. The C code we had for that feature was deemed as an xfs_io feature.
>
> *nod*
>
> Forgive me for looking more carefully now than then, sorry.
>
> Argh, and for missing that you're already on V5, I missed
> the previous reviews.  Well, I did find at least one speling eror,
> so there's that.  But more below...

only 1?


>
>> On 08/20/13 18:07, Eric Sandeen wrote:
>>> On 8/16/13 3:54 PM, Mark Tinguely wrote:
>>>
>>>> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
>>>> The result from the lseek() call will be printed to the output.
>>>> For example:
>>>>
>>>> xfs_io>   lseek -h 609k
>>>> Type    Offset
>>>> hole    630784
>>>
>>> HOLE not hole, I guess.  ;)
>>>
>>> I was going to say that's a lot of verbosity for a single output,
>>> but I guess the other options might have many lines, so I suppose
>>> it makes sense.
>>>
>>> (I was just thinking about what xfstests might need to do to filter
>>> &   parse output...)
>>
>> parsing is a bear because there are multiple correct answers.
>> There is always a legal hole at EOF and that if SEEK_HOLE is not implemented that is the answer they give.
>>
>> Different versions of XFS seek_data code will give different answer to the same test depending on what is supported in that version.
>>
>>>
>>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>>> ---
>>>>    Not trying to be difficult. Dave wanted the single hole/data/hole and data
>>>>    seperated from the recursive loop, but doing it that way is basically unrolling
>>>>    the loop into a if-then-else and is really terrible. If this is still not
>>>>    acceptable, then we can throw this feature into /dev/null.
>>>>
>>>>    configure.ac          |    1
>>>>    include/builddefs.in  |    1
>>>>    io/Makefile           |    5 +
>>>>    io/init.c             |    1
>>>>    io/io.h               |    6 +
>>>>    io/seek.c             |  187 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    m4/package_libcdev.m4 |   15 ++++
>>>>    man/man8/xfs_io.8     |   35 +++++++++
>>>>    8 files changed, 251 insertions(+)
>>>>
>>>> Index: b/configure.ac
>>>> ===================================================================
>>>> --- a/configure.ac
>>>> +++ b/configure.ac
>>>> @@ -110,6 +110,7 @@ AC_HAVE_GETMNTINFO
>>>>    AC_HAVE_FALLOCATE
>>>>    AC_HAVE_FIEMAP
>>>>    AC_HAVE_PREADV
>>>> +AC_HAVE_SEEK_DATA
>>>>    AC_HAVE_SYNC_FILE_RANGE
>>>>    AC_HAVE_BLKID_TOPO($enable_blkid)
>>>>    AC_HAVE_READDIR
>>>> Index: b/include/builddefs.in
>>>> ===================================================================
>>>> --- a/include/builddefs.in
>>>> +++ b/include/builddefs.in
>>>> @@ -102,6 +102,7 @@ HAVE_GETMNTINFO = @have_getmntinfo@
>>>>    HAVE_FALLOCATE = @have_fallocate@
>>>>    HAVE_FIEMAP = @have_fiemap@
>>>>    HAVE_PREADV = @have_preadv@
>>>> +HAVE_SEEK_DATA = @have_seek_data@
>>>>    HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
>>>>    HAVE_READDIR = @have_readdir@
>>>>
>>>> Index: b/io/Makefile
>>>> ===================================================================
>>>> --- a/io/Makefile
>>>> +++ b/io/Makefile
>>>> @@ -85,6 +85,11 @@ CFILES += readdir.c
>>>>    LCFLAGS += -DHAVE_READDIR
>>>>    endif
>>>>
>>>> +ifeq ($(HAVE_SEEK_DATA),yes)
>>>> +LCFLAGS += -DHAVE_SEEK_DATA
>>>> +CFILES += seek.c
>>>
>>> see below; we should unconditionally compile, but conditionally
>>> locally define SEEK_DATA / SEEK_HOLE
>>>
>>
>> It was put in to check if SEEK_DATA is supported.
>>
>> Yes, it expects the user headers to reflect what the kernel is capable of doing.
>
> well, especially on a development system, the installed headers may not
> reflect or match the running kernel.
>
> So even if system headers don't have SEEK_DATA it, the running kernel may
> still be capable of it, right?
>
> We've done similar things for i.e. fallocate PUNCH_HOLE.
>
>> If you don't want it, then it will be removed.
>
> I think it makes sense to build it&  locally define if necessary.
> On my RHEL6 root w/ an upstream devel kernel seek.c wouldn't have
> built, even though it'd have worked perfectly w/ a local define.
>

yes, needed anyway if removing linux/fs.h

>>>> +endif
>>>> +
>>>>    default: depend $(LTCOMMAND)
>>>>
>>>>    include $(BUILDRULES)
>>>> Index: b/io/init.c
>>>> ===================================================================
>>>> --- a/io/init.c
>>>> +++ b/io/init.c
>>>> @@ -64,6 +64,7 @@ init_commands(void)
>>>>        help_init();
>>>>        imap_init();
>>>>        inject_init();
>>>> +    seek_init();
>>>>        madvise_init();
>>>>        mincore_init();
>>>>        mmap_init();
>>>> Index: b/io/io.h
>>>> ===================================================================
>>>> --- a/io/io.h
>>>> +++ b/io/io.h
>>>> @@ -108,6 +108,12 @@ extern void        quit_init(void);
>>>>    extern void        shutdown_init(void);
>>>>    extern void        truncate_init(void);
>>>>
>>>> +#ifdef HAVE_SEEK_DATA
>>>> +extern void        seek_init(void);
>>>> +#else
>>>> +#define seek_init()    do { } while (0)
>>>> +#endif
>>>
>>> this can go when we unconditionally compile it in
>>>
>>>> +
>>>>    #ifdef HAVE_FADVISE
>>>>    extern void        fadvise_init(void);
>>>>    #else
>>>> Index: b/io/seek.c
>>>> ===================================================================
>>>> --- /dev/null
>>>> +++ b/io/seek.c
>>>> @@ -0,0 +1,187 @@
>>>> +/*
>>>> + * Copyright (c) 2013 SGI
>>>> + * All Rights Reserved.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or
>>>> + * modify it under the terms of the GNU General Public License as
>>>> + * published by the Free Software Foundation.
>>>> + *
>>>> + * This program is distributed in the hope that it would be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public License
>>>> + * along with this program; if not, write the Free Software Foundation,
>>>> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>>> + */
>>>> +
>>>> +#include<libxfs.h>
>>>
>>> hm, including this clashes w/ the min() define in io/init.h,
>>> which is maybe a separate problem down the line, but libxfs.h
>>> isn't required anyway for this file, so I'd just drop this include.
>>>
>>>> +#include<linux/fs.h>
>>
>> I think the previous review had a problem with this header which should be removed.
>
> oh yeah, Dave did ask (now that I'm caught up with the last 4 reviews) :(
>
> And yeah it builds fine w/o either libxfs.h or linux/fs.h, so I'd just yank
> 'em both.
>

yes, I missed them from Dave's review - my mistake.

>>>> +
>>>> +#include<sys/uio.h>
>>>> +#include<xfs/xfs.h>
>>>> +#include<xfs/command.h>
>>>> +#include<xfs/input.h>
>>>> +#include<ctype.h>
>>>> +#include "init.h"
>>>> +#include "io.h"
>>>
>>> #ifndef HAVE_SEEK_DATA
>>> #define SEEK_DATA       3       /* seek to the next data */
>>> #define SEEK_HOLE       4       /* seek to the next hole */
>>> #endif
>>>
>>>> +
>>>> +static cmdinfo_t seek_cmd;
>>>> +
>>>> +static void
>>>> +seek_help(void)
>>>> +{
>>>> +    printf(_(
>>>> +"\n"
>>>> +" returns the next hole and/or data offset at or after the specified offset\n"
>>>> +"\n"
>>>> +" Example:\n"
>>>> +" 'seek -d 512'   - offset of data at or following offset 512\n"
>>>> +" 'seek -a -r 0'  - offsets of all data and hole in entire file\n"
>>>> +"\n"
>>>> +" Returns the offset of the next data and/or hole. There is an implied hole\n"
>>>> +" at the end of file.
>>>
>>> is this expected, given the hole at the end of the file?  This is for a single
>>> non-sparse file:
>>>
>>> xfs_io>   seek -ar 0
>>> Type    offset
>>> DATA    0
>>> HOLE    3022
>>> DATA    EOF
>>>
>>> That last line doesn't make sense, does it?
>>
>> Parsing is the reason the entry is there so the output always has
>> consistent ending entry - some queries that is the only answer (or
>> now no message) no biggy one way or the other.
>
> Hm, ok, clearly you've thought about this more than I have.
> It just surprised me...
>
> So let me just think out loud here w/ examples.
>
> For a 1M 100% nonsparse file we get:
>
> # io/xfs_io -c "seek -ar 0" alldata
> Type	offset
> DATA	0
> HOLE	1048576

or this could be HOLE EOF depends on the version.

> DATA	EOF
>
> For a 1M 100% sparse file (i_size and no blocks at all) we get:
>
> # io/xfs_io -c "seek -ar 0" allsparse
> Type	offset
> HOLE	0
> DATA	EOF
>
> For a 1M file w/ only the first 512k w/ data, then hole,
> we get:
>
> # io/xfs_io -c "seek -ar 0" endhole
> Type	offset
> DATA	0
> HOLE	524288
> DATA	EOF
>
> For a 1M file w/ 512k of hole and then 512k w/ data, we get:
>
> # io/xfs_io -c "seek -ar 0" starthole
> Type	offset
> HOLE	0
> DATA	524288
> HOLE	1048576
> DATA	EOF
>
> So in each case, the "DATA  EOF" at the end seems odd to me.
>
> And in each case above, the output is unique w/o the EOF flag
> anwyway, right?

... or we will get "HOLE EOF"

There are different versions of XFS seek_data and they will 
detect/report the start of data and holes differently so output parsing 
will be a bear. The existing C code sends the 2 different value numbers
that could be reported.

The later, advance dirty page detection is more fine tuned. Jeff and I 
had C tests for this feature that I turned into a xfstest; it was 
suggested that the C test become xfs_io call, and then 5 versions later, 
we have this ...

>
> I'm probably missing it; in what cases is the EOF record
> useful?  It just seems beyond the scope of SEEK_HOLE/SEEK_DATA.
> (i.e. EOF is SEEK_END)
>
> If the EOF is really helpful, maybe it is possible instead to do something like:
>
> # io/xfs_io -c "seek -ar 0" starthole
> Type	offset
> HOLE	0
> DATA	524288
> EOF	1048575
> HOLE	1048576
>
> That makes more intuitive sense to me if you really need the EOF
> record, but I dunno, what do you think?
>
I can drop the table header.

We can leave off the implied eof - there will be cases where there is no 
entries.

>>>
>>>> If the specified offset is past end of file, or there\n"
>>>> +" is no data past the specied offset, EOF is returned.\n"
>>>
>>> "specified"
>>>
>>>> +" -a   -- return the next data and hole starting at the specified offset.\n"
>>>> +" -d   -- return the next data starting at the specified offset.\n"
>>>> +" -h   -- return the next hole starting at the specified offset.\n"
>>>> +" -r   -- return all remaining type(s) starting at the specified offset.\n"
>>>> +"\n"));
>>>> +}
>>>> +
>>>> +#define    SEEK_DFLAG    (1<<   0)
>>>> +#define    SEEK_HFLAG    (1<<   1)
>>>> +#define    SEEK_RFLAG    (1<<   2)
>>>> +#define    DATA        0
>>>> +#define    HOLE        1
>>>> +
>>>> +struct seekinfo {
>>>> +    char        *name;
>>>> +    int        seektype;
>>>> +    int        mask;
>>>> +} seekinfo[] = {
>>>> +        {"DATA", SEEK_DATA, SEEK_DFLAG},
>>>> +        {"HOLE", SEEK_HOLE, SEEK_HFLAG}
>>>
>>> I guess "DATA" doesn't get replaced by "0" ?  Sorry, I failed cpp 101.
>>> It prints the right thing so I guess not.  ;)
>>>
>>
>> :) no the defines are subscripts = see "current ="
>
> I did see that, I just wasn't sure if it'd replace it in literal
> strings, but apparently not.
>

nope, strings are safe - did Coverity complain?

>>
>>>> +};
>>>> +
>>>> +void
>>>> +seek_output(
>>>> +    char    *type,
>>>> +    off64_t    offset)
>>>> +{
>>>> +    if (offset == -1) {
>>>> +        if (errno == ENXIO)
>>>> +            printf("%s    EOF\n", type);
>>>> +        else
>>>> +            printf("%s    ERR %d\n", type, errno);
>>>> +    } else
>>>> +        printf("%s    %ld\n", type, offset);
>
> one more; for 32-bit systems I think this should be
>
> printf("%s    %lld\n", type, (long long)offset);
>
> to avoid a warning; that's what i.e. the pwrite printf's do.
>

okay, thanks.

>>>> +}
>>>> +
>>>> +static int
>>>> +seek_f(
>>>> +    int    argc,
>>>> +    char    **argv)
>>>> +{
>>>> +    off64_t        offset, result;
>>>> +    size_t          fsblocksize, fssectsize;
>>>> +    int        flag;
>>>> +    int        current;    /* specify data or hole */
>>>> +    int        c;
>>>> +
>>>> +    flag = 0;
>>>> +    init_cvtnum(&fsblocksize,&fssectsize);
>>>> +
>>>> +    while ((c = getopt(argc, argv, "adhr")) != EOF) {
>>>> +        switch (c) {
>>>> +        case 'a':
>>>> +            flag |= (SEEK_HFLAG | SEEK_DFLAG);
>>>> +            break;
>>>> +        case 'd':
>>>> +            flag |= SEEK_DFLAG;
>>>> +            break;
>>>> +        case 'h':
>>>> +            flag |= SEEK_HFLAG;
>>>> +            break;
>>>> +        case 'r':
>>>> +            flag |= SEEK_RFLAG;
>>>> +            break;
>>>> +        default:
>>>> +            return command_usage(&seek_cmd);
>>>> +        }
>>>> +    }
>>>> +        /* must have hole or data specified and an offset */
>
> super-nitpick, extra tab before the comment.
>

not a problem.

>>>> +    if (!(flag&   (SEEK_DFLAG | SEEK_HFLAG)) ||
>>>> +             optind != argc - 1)
>>>> +        return command_usage(&seek_cmd);
>>>> +
>>>> +    offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>>>
>>> need to error check that:
>>>
>>> xfs_io>   seek -a 8x8
>>> Type    offset
>>> HOLE    EOF
>>>
>>
>> Some version of XFS seek_data will treat it as a 0, but okay.
>
> but I mean the error from cvtnum, if you don't give it a valid string;
> nothing to do w/ seek_data ...
>

duh me. okay.

> Thanks,
> -Eric

Thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
