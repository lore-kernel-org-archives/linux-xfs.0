Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13D9F7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 08:23:09 -0600 (CST)
Message-ID: <52F8E0CF.1000305@sgi.com>
Date: Mon, 10 Feb 2014 08:23:11 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: fix the setting of unaligned directory fields
References: <20140207210348.249387765@sgi.com>
	<20140207223327.GG13647@dastard> <52F56891.5020305@sgi.com>
	<20140208083012.GI13647@dastard> <52F669CA.7050000@sgi.com>
	<20140209232243.GL13647@dastard>
In-Reply-To: <20140209232243.GL13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/09/14 17:22, Dave Chinner wrote:
> On Sat, Feb 08, 2014 at 11:30:50AM -0600, Mark Tinguely wrote:
>> On 02/08/14 02:30, Dave Chinner wrote:
>>> On Fri, Feb 07, 2014 at 05:13:21PM -0600, Mark Tinguely wrote:
>>>> On 02/07/14 16:33, Dave Chinner wrote:
>>>>> On Fri, Feb 07, 2014 at 04:03:42PM -0600, Mark Tinguely wrote:
>>>>>> @@ -526,16 +527,20 @@ convert_arg(
>>>>>>   		 */
>>>>>>   		*value = strtoll(arg, NULL, 0);
>>>>>
>>>>> If we are touching this code, the return value here should be error
>>>>> checked.
>>>>>
>>>>> xfs_db>    write u3.bmx[0].startblock 3rgfdw
>>>>> u3.bmx[0].startblock = 52776558133248
>>>>
>>>> hmm, It should stop at 3. I will take a look.
>>>
>>> Even if it stops at 3, that's still wrong because it's failed to
>>> process the entire user input....
>>>
>>>>> xfs_db>    write u3.bmx[0].startblock x3rgfdw
>>>>> u3.bmx[0].startblock = 0
>>>>> xfs_db>
>>>>>
>>>>> i.e. it accepts garbage rather than erroring out.
>>>>
>>>> as does all the other writes ...
>>>> xfs_db>    write core.nblocks x3rgfdw
>>>> core.nblocks = 0
>>>>
>>>> Fixing convert_arg() is beyond the scope of just this patch.
>>>
>>> Sure, but I'm not asking you to fix all of convert_args in this
>>> patch, just asking you to do a complete job of fixing the bitval
>>> input processing in this patch.
>>>
>>> But, seeing as you've raised that convert_args() has other broken
>>> paths, can you also write new patches to address those issues? It
>>> won't take you long while all this code is fresh in your mind, and
>>> if you do it now it won't get dropped on the floor until somebody
>>> else hits it a couple of years down the track...
>>>
>>
>> It needs to be split up. write_string() needs string inputs,
>> write_struct() need numeric inputs.
>
> write_struct() handles every type of possible input -
> string varables, integers, UUIDs, etc. i.e. something like
>
> xfs_db>  write sb.uuid<xxxx-yyyy-....>
>
> runs through write_struct(), it finds the uuid field definition in
> the superblock description and then calls convert_args() on it to
> convert the uuid format input.
>
> IOWs, convert_args() needs to handle all the types of input. Hence
> you might like to factor convert_args, but it still needs to handle
> arbitrary input types.
>
>>   Who uses the UUID-style hex
>> blocks? It feels like a black hole of time.
>
> Obvious answer: UUIDs
>
> $ git grep FLDT_UUID
> db/agf.c:       { "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> db/agfl.c:      { "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> db/agi.c:       { "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> db/btblock.c:   { "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
> db/btblock.c:   { "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
> db/btblock.c:   { "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
> db/btblock.c:   { "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
> db/btblock.c:   { "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
> db/dir2.c:      { "uuid", FLDT_UUID, OI(DBH3OFF(uuid)), C1, 0, TYP_NONE },
> db/dir2.c:      { "uuid", FLDT_UUID, OI(DB3OFF(uuid)), C1, 0, TYP_NONE },
> db/dquot.c:     { "uuid", FLDT_UUID, OI(DDOFF(uuid)), C1, 0, TYP_NONE },
> db/field.c:     { FLDT_UUID, "uuid", fp_uuid, NULL, SI(bitsz(uuid_t)), 0, NULL, N
> db/field.h:     FLDT_UUID,
> db/inode.c:     { "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
> db/inode.c:     { "muuid", FLDT_UUID, NULL, inode_u_muuid_count, FLD_COUNT, TYP_N
> db/sb.c:        { "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> db/symlink.c:   { "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> $
>
> Slightly less obvious answer is writing arbitrary binary data to
> block regions in structures, such as writing multiple entries in an
> array in a single command (e.g. FLD_ARRAY structure sections). I've
> used this to move sections of directory blocks around in the past....
>
>> It goes on my 'off the clock' to do list.
>
> Ok, I'll just assume that means it'll never get done so I'll get a
> pleasent surprise when you send the patch tomorrow....
>
> Cheers,
>
> Dave.

Yes, realized that the types are all needed:
  write core.magic "IN"
does make sense. And the following is legal:
  write core.mode "IN"
but may not make a lot of sense.

My patch broke on little endian the ability to input 8-64 bit hex values:

   write core.magic #494e

it was always broke on big endian, so I fixed it for both.

I cleaned up the trailing junk characters.

The test has been written and it will be reposted once I get to the 
documentation changes.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
