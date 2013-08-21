Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0F8B7FC8
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 14:20:07 -0500 (CDT)
Message-ID: <521512E3.7090301@sgi.com>
Date: Wed, 21 Aug 2013 14:20:03 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130816205409.976658624@sgi.com> <5213F6AF.8070107@sandeen.net>
	<5214CB5C.4050608@sgi.com> <5214EAAC.80800@sandeen.net>
	<5214F050.7060402@sgi.com> <52150775.1050705@sandeen.net>
In-Reply-To: <52150775.1050705@sandeen.net>
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

On 08/21/13 13:31, Eric Sandeen wrote:
> On 8/21/13 11:52 AM, Mark Tinguely wrote:
> ...
>
>>> I think it makes sense to build it&   locally define if necessary.
>>> On my RHEL6 root w/ an upstream devel kernel seek.c wouldn't have
>>> built, even though it'd have worked perfectly w/ a local define.
>>>
>>
>> yes, needed anyway if removing linux/fs.h
>
> lseek only should need:
>
>         #include<sys/types.h>
>         #include<unistd.h>
>
> right; those may internally get to linux/fs.h but it shouldn't be
> directly required, I'd expect.  Oh!  it needs
>
> #define _GNU_SOURCE
>
> first, to get it - but xfsprogs build does that already.
>
>>> So let me just think out loud here w/ examples.
>>>
>>> For a 1M 100% nonsparse file we get:
>>>
>>> # io/xfs_io -c "seek -ar 0" alldata
>>> Type    offset
>>> DATA    0
>>> HOLE    1048576
>>
>> or this could be HOLE EOF depends on the version.
>
> xfs version?  Just for my own education, which version does that?

yeah.

can't remember. I will eventually have to rebuild them all starting with 
Linux 3.0 (where seek_data was not supported), 3.1-3.3 used the vfs 
defaults. Linux 3.4 is where seek_data was introduced to XFS. There are 
3-4 incremental changes to the seek_data since then and they all change 
some output.

>
>>> DATA    EOF
>>>
>>> For a 1M 100% sparse file (i_size and no blocks at all) we get:
>>>
>>> # io/xfs_io -c "seek -ar 0" allsparse
>>> Type    offset
>>> HOLE    0
>>> DATA    EOF
>>>
>>> For a 1M file w/ only the first 512k w/ data, then hole,
>>> we get:
>>>
>>> # io/xfs_io -c "seek -ar 0" endhole
>>> Type    offset
>>> DATA    0
>>> HOLE    524288
>>> DATA    EOF
>>>
>>> For a 1M file w/ 512k of hole and then 512k w/ data, we get:
>>>
>>> # io/xfs_io -c "seek -ar 0" starthole
>>> Type    offset
>>> HOLE    0
>>> DATA    524288
>>> HOLE    1048576
>>> DATA    EOF
>>>
>>> So in each case, the "DATA  EOF" at the end seems odd to me.
>>>
>>> And in each case above, the output is unique w/o the EOF flag
>>> anwyway, right?
>>
>> ... or we will get "HOLE EOF"
>>
>> There are different versions of XFS seek_data and they will
>> detect/report the start of data and holes differently so output
>> parsing will be a bear. The existing C code sends the 2 different
>> value numbers that could be reported.
>
> are they ... both correct?  If one is a bug, it can just be a bug, right?
> I'm sorry I'm not up on the history.

Lets say we have a file
hole    0-4K
data    4K-8K
hole    8-12K
data    12-16K

for data/hole check starting at offset 0, valid response are
0K or 4K for data
0K or 16K or -1 for holes

This feature and test was for Jeff fine-tuned seek_data/seek_hole 
support. The tests would be more specific to that feature and output is 
specific.

>
>> The later, advance dirty page detection is more fine tuned. Jeff and
>> I had C tests for this feature that I turned into a xfstest; it was
>> suggested that the C test become xfs_io call, and then 5 versions
>> later, we have this ...
>
> 6 versions.  :D
>

auuuuugggh, even I lost count. :)

>>
>>>
>>> I'm probably missing it; in what cases is the EOF record
>>> useful?  It just seems beyond the scope of SEEK_HOLE/SEEK_DATA.
>>> (i.e. EOF is SEEK_END)
>>>
>>> If the EOF is really helpful, maybe it is possible instead to do something like:
>>>
>>> # io/xfs_io -c "seek -ar 0" starthole
>>> Type    offset
>>> HOLE    0
>>> DATA    524288
>>> EOF    1048575
>>> HOLE    1048576
>>>
>>> That makes more intuitive sense to me if you really need the EOF
>>> record, but I dunno, what do you think?
>>>
>> I can drop the table header.
>>
>> We can leave off the implied eof - there will be cases where there is no entries.
>
> Well, whatever you think, I guess.  Given that the interface is _defined_ as having
> an implicit hole past EOF, saying "DATA EOF" just hurts my brain.
>
> Maybe the guiding principle should be: this is a tool to exercise lseek for
> SEEK_DATA / SEEK_HOLE.  It should report the results of those ops, and no
> more; just present what the requested call(s) said.  If you really want to know
> where EOF is, use stat?
>
> (Since the command is just called "seek" maybe some day it will grow
> -e -s -c options for SEEK_END, SEEK_SET, and SEEK_CUR as well, to be
> able to exercise every "whence" - and then if you want to know EOF,
> just send it SEEK_END and see what it returns)
>

In one of my many versions, I made sure there was at least one entry - 
if there was no entry I put the EOF.

I can live with no output.


>>>>> I guess "DATA" doesn't get replaced by "0" ?  Sorry, I failed cpp 101.
>>>>> It prints the right thing so I guess not.  ;)
>>>>>
>>>>
>>>> :) no the defines are subscripts = see "current ="
>>>
>>> I did see that, I just wasn't sure if it'd replace it in literal
>>> strings, but apparently not.
>>>
>>
>> nope, strings are safe - did Coverity complain?
>
> No, just my dumb brain.
>
>
> -Eric

Igor fetched Abbie Normal's brain for me.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
