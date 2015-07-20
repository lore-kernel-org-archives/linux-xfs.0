Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0F83F7F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 03:52:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84583AC003
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 01:52:55 -0700 (PDT)
Received: from mail-wg0-f51.google.com (mail-wg0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id uWjkV60jiAE9Tg5J
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2015 01:52:53 -0700 (PDT)
Received: by wgmn9 with SMTP id n9so125067454wgm.0
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 01:52:51 -0700 (PDT)
Message-ID: <55ACB6D6.2000100@gmail.com>
Date: Mon, 20 Jul 2015 11:52:38 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>	<55AA5FCE.4080702@sandeen.net>	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>	<55AAF73A.4040903@mygrande.net>
	<20150719232754.GS7943@dastard> <55ACA615.10501@mygrande.net>
	<55ACABD7.8000500@gmail.com> <55ACB2BD.6050601@mygrande.net>
In-Reply-To: <55ACB2BD.6050601@mygrande.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


Just wanted to make sure since I didn't catch any mention of these
checks. And based on your thoroughness I assume you ran memtest after
the ram replacement. What I'd try next in your situation is to boot a
different version of the kernel (possibly a different distro) and see
if the errors are the same, I'd try something bootable from a DVD or a
USB stick. What do you think?

On 07/20/2015 11:35 AM, Leslie Rhorer wrote:
> On 7/20/2015 3:05 AM, Martin Papik wrote:
> 
> Since you've already found one HW related fault, would you consider
> booting into memtest for a couple of passes just to be on the safe
> side.
> 
>> I did that after confirming the one stick of memory was bad. 
>> Twice.  I got over 20,000 errors on the bad stick, and 0 on the 
>> good one.  I also swapped the locations on the motherboard, and 
>> the bad stick still failed while the good one passed 100%.
> 
> And did you by any chance look at SMART if applicable and possibly 
> running a test on the drives.
> 
>> Yes. SMART found no errors, but think about it.  Every time tar 
>> tries to create a directory when untarring that file in that 
>> location, the file system croaks when it tries to create a 
>> directory. Not when reading and not when writing other than when 
>> it creates a directory. When I create the directory manualy, the 
>> process quits failing at that point and fails later on during a 
>> different directory create.  The array remains intact when 
>> reading, and dmesg shows no drive errors.  I've re-synced the 
>> array, which reads every byte on all 8 drives without a single 
>> mismatch - several times.  To my knowledge, no read has ever 
>> failed except after the filesystem goes offline.  I thought
>> reads were failing during the CRC checks, but that was a red
>> herring.
> 
> Another test I sometimes do when I'm unsure about disks is "cat 
> /dev/sda > /dev/null" (i.e. a whole disk read test)
> 
>> echo repair > /sys/block/md0/md/sync_action reads not one drive, 
>> but every byte on all 8 drives.
> 
> and see (dmesg) if any errors show up, unless
> 
>> 'Nary one, and no mismatches.
> 
> you're willing to run badblocks in a read-write nondestructive 
> mode. In my experience the read test or badblocks can be run 
> simultaneously with smartctl -t long. But as a start I'd look at 
> smartctl --all /dev/sd? and see if there are any bad signs. I hope 
> this helps. Good luck
> 
> 
> On 07/20/2015 10:41 AM, Leslie Rhorer wrote:
>>>> On 7/19/2015 6:27 PM, Dave Chinner wrote:
>>>>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer 
>>>>> wrote:
>>>>>> 
>>>>>> I found the problem with md5sum (and probably nfs, as 
>>>>>> well). One of the memory modules in the server was bad. 
>>>>>> The problem with XFS persists.  Every time tar tried to 
>>>>>> create the directory:
>>>>> 
>>>>> Now you need to run xfs_repair.
>>>> 
>>>> I do that every time the array implodes.  It makes no 
>>>> difference. It never mentions cleaning the structure tar
>>>> says needs cleaning, and the next time I run tar on that
>>>> file, the filesystem craters.
>>>> 
>>>> _______________________________________________ xfs mailing 
>>>> list xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 
>> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVrLbVAAoJELsEaSRwbVYr/JoQAKGcNBTtswnSJ9SYpBQMc8aO
m2WQaHzLDPkSPLWYeWSGc3clPuf4FdP3A9bDcclCnVV/Ex0WJiCalYfa1Zqpnq5P
BinRp1w/cbfTTazLspFT9ySuoloOqNXTPz0MB4uxRTnIDb3Hcahw0O6HhOuZixW3
ocaEOXqVs1cc4YzPwT4Z9aWBEX3ZutMvxNKM4VWT1m8aoRZ3eJMPUKHN04PDUKyT
4Mwilypg9R6r6iberZ9zVwFy0LerElg9Cb90AGLNpyGCutGbOZH7VsoBUTnAmh2E
dz4uruFU0x8n87MQccXfSvZQIWG16UDxwjQjEiD4EHtRhYYTNVgq2V8ak94u8w99
0p5WG5+dEnVV0Qgjk2DaZy305LP+5oc2D9GkXJgGTFjMPVV3+9Tnq/XDlm2Hgxn8
hq2q0DoPDQVFMzNLxpGCJfuIdAO3o7z/1rjHpeP2Ol6pPw+hT8SQMehTBU4vMlcp
SeZzg485rVtQrWtXVJaRhITAQWSvQxjm9QqLAMdon0oxdKAPZIOtQgr8oEGKgfr7
mknqFPon7sa0c4nAZT7DtTOS+OATbTnYAoUqIuxRf4NCD7dbFUQrccU4/peEE4/H
SPzOfgOiAArOVZwWEc7JvydpcKqaEUzYb2KyzsGJFuJHZodrSTzXmUMg/Muc+iQ5
Ao/NeFe/1flevZ060ZEX
=1/q4
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
