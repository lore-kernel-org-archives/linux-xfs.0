Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB6AWgcq114517 for <xfs@oss.sgi.com>; Thu, 6 Dec 2012 04:32:42 -0600
Received: from relay01.pair.com (relay01.pair.com [209.68.5.15]) by
	cuda.sgi.com with SMTP id YGnxSYsIKT21QUjL for
	<xfs@oss.sgi.com>; Thu, 06 Dec 2012 02:35:06 -0800 (PST)
References: <CCE505AA.B05B7%jellis@dhnet.us>
	<50BFF726.6090006@hardwarefreak.com>
	<68036B67-6AE6-4056-89F5-9549B4E476FD@dhnet.us>
	<50C00583.6000804@hardwarefreak.com>
	<6F909666-9DFE-43F1-973D-170B892F9C5B@gmail.com>
	<50C0657D.5050903@hardwarefreak.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <50C0657D.5050903@hardwarefreak.com>
Message-Id: <FD803484-AADA-41D8-8BD7-D36CFF6F203E@dhnet.us>
From: Jeffrey Ellis <jellis@dhnet.us>
Subject: Re: xfsdump INTERRUPT issue
Date: Thu, 6 Dec 2012 05:35:07 -0500
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "stan@hardwarefreak.com" <stan@hardwarefreak.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> / isn't a suitable location to write a dump file.  Find a suitable
> location on another filesystem with enough free space to hold the dump.
> "xfsdump_file" is an example file name.  Use whatever file name you wish.

That was just an example. 

> My example XFS filesystem used for illustration purposes resides on
> /dev/sda6 on one of my machines.  /dev/sda6 is probably not the location
> of the filesystem you are dumping.  On what device does your XFS
> filesystem reside?

There are two. /dev/sda0 and /dev/sdb1, IIRC. The first is a blank drive however. 

>> xfsrestore -t -v /xfsdump_file
> 
> Just forget the "-v".  It'll make things easier.

So that command is good?

> BTW, if your goal in all of this is simply copying all the directories
> and files from one disk to another disk, you could have used "cp -a" and
> been done already.  It takes longer to execute than xfsdump/xfsrestore,
> but given you've been at this for many days now, "cp -a" would have
> already completed--long ago.

No, I wish it was. 

Best,
Jeffrey

On Dec 6, 2012, at 4:29 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 12/5/2012 9:01 PM, Jeffrey Ellis wrote:
>> Ok. 
>> 
>> xfsdump -J -f /xfsdump_file /dev/sda6
> 
> / isn't a suitable location to write a dump file.  Find a suitable
> location on another filesystem with enough free space to hold the dump.
> "xfsdump_file" is an example file name.  Use whatever file name you wish.
> 
> My example XFS filesystem used for illustration purposes resides on
> /dev/sda6 on one of my machines.  /dev/sda6 is probably not the location
> of the filesystem you are dumping.  On what device does your XFS
> filesystem reside?
> 
>> xfsrestore -t -v /xfsdump_file
> 
> Just forget the "-v".  It'll make things easier.
> 
>> Then I post the results?
> 
> After you get all of the above straightened out.
> 
> BTW, if your goal in all of this is simply copying all the directories
> and files from one disk to another disk, you could have used "cp -a" and
> been done already.  It takes longer to execute than xfsdump/xfsrestore,
> but given you've been at this for many days now, "cp -a" would have
> already completed--long ago.
> 
> -- 
> Stan
> 
> 
>> Best,
>> J. 
>> 
>> On Dec 5, 2012, at 9:40 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> 
>>> On 12/5/2012 8:08 PM, Jeffrey Ellis wrote:
>>>> Hi, Stan--
>>>> 
>>>> You're right. I didn't want to look stupid. Sorry. I'll keep it all on the list from now on. 
>>>> 
>>>> Thank you for the example. I hope I have this right. So including the -t and -v would be 
>>>> 
>>>> ~$ xfsdump -J -f -t -v /xfsdump_file /dev/sda0
>>> 
>>> No.  That's not right.  I gave you concise separate instructions for
>>> xfsdump and for xfsrestore, and you've commingled the two.
>>> 
>>> Please thoroughly and thoughtfully re-read my last email.
>>> 
>>> -- 
>>> Stan
>>> 
>>> 
>>>> Repeat for each mount point, and post the result here?
>>>> 
>>>> Thanks again. 
>>>> Jeffrey
>>>> 
>>>>> ~$ xfsdump -J -f /some_filesystem_path/test_dump /dev/sda6
>>>> 
>>>> 
>>>> 
>>>> Best,
>>>> J. 
>>>> 
>>>> On Dec 5, 2012, at 8:38 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>>> 
>>>>> On 12/5/2012 1:07 PM, J. Ellis wrote:
>>>>> 
>>>>> This should never have gone off list so I'm copying back.  If you'd have
>>>>> kept this on list you'd have likely already had an answer to this.
>>>>> Going off list for fear of looking ignorant is not a valid reason to do
>>>>> so.  In fact there are very few reasons to ever go off list.  All it
>>>>> does is take people out of the loop who are watching the thread and may
>>>>> be willing to jump in at some point to help.  You've short circuited
>>>>> that by going off list.
>>>>> 
>>>>>> I just read the man page again. There doesn't seem to be any examples I can
>>>>>> find to write the dump to a file. I couldn't find a -t option in the man at
>>>>>> all, so maybe the ones I'm finding aren't up to date. Here's the only
>>>>>> example I can find, and I don't know if this would actually work:
>>>>>> 
>>>>>> xfsdump -f /usr/tmp/monday_backup -v silent -J -s \ people/fred/Makefile -s
>>>>>> people/fred/Source /usr
>>>>> 
>>>>> This is really simple.  Using my previous example, we want to dump to a
>>>>> test file and not update the inventory.  So we have something like:
>>>>> 
>>>>> ~$ xfsdump -J -f /some_filesystem_path/test_dump /dev/sda6
>>>>> 
>>>>> This dumps the XFS filesystem on /dev/sda6 to a file.  Don't write the
>>>>> dump file to the filesystem you're dumping.  Preferably the XFS you're
>>>>> dumping is on one disk or array and the target file will be written to a
>>>>> different disk or array.  Dumps are IO intensive.
>>>>> 
>>>>> I clearly stated the "-t" option in the context of xfsrestore:
>>>>> 
>>>>>     -t   Displays  the  contents of the dump, but does not create or
>>>>>          modify any files or directories.  It may be desirable to
>>>>>          set the verbosity level to silent when using this option.
>>>>> 
>>>>> This allows you to do a test run without actually writing any files
>>>>> during the restore.  The goal here is to test xfsdump and xfsrestore on
>>>>> your system to see where errors are cropping up.  You don't actually
>>>>> want to restore the dumped filesystem at this point.
>>>>> 
>>>>> The "-v" option simply keeps the "-t" from spamming a million file names
>>>>> to your console during the restore operation.
>>>>> 
>>>>> -- 
>>>>> Stan
>>>>> 
>>>>> 
>>>>>> on 12/4/12 10:32 PM, Stan Hoeppner at stan@hardwarefreak.com wrote:
>>>>>> 
>>>>>>> On 12/4/2012 7:18 PM, J. Ellis wrote:
>>>>>>>> Hi, Stan--
>>>>>>>> 
>>>>>>>> Ok, I truly apologize for my ignorance, but I don't know how to dump the
>>>>>>>> contents to a file. Is it something like:
>>>>>>>> 
>>>>>>>> xfsdump -J - somefile_xfsdump.txt
>>>>>>> 
>>>>>>> ~$ man xfsdump
>>>>>>> 
>>>>>>> Look at option "-f".
>>>>>>> 
>>>>>>>> xfsrestore -J - somefile_xfsrestore.txt
>>>>>>> 
>>>>>>> ~$ man xfsrestore
>>>>>>> 
>>>>>>> See options "-f" "-t" and "-v".
>>>>>>> 
>>>>>>> The point of this exercise I believe is to see what errors are thrown by
>>>>>>> xfsdump or xfsrestore when they are executed independently, vs through a
>>>>>>> pipe.  Do note that this may not be the final step in testing before you
>>>>>>> have an answer.  Post any errors or informational output that results
>>>>>>> from these commands.
>>>>>>> 
>>>>>>> Note that the file written by xfsdump is going to be about the same size
>>>>>>> as the filesystem being dumped.  I.e. if the filesystem being dumped is
>>>>>>> 1TB then you need 1TB of free space on the device where the target
>>>>>>> directory resides--you're dumping an entire XFS filesystem into a single
>>>>>>> file.  Also, be sure to use "-t" so xfsrestore doesn't actually write
>>>>>>> anything.  Did you read "-v"?
>>>> 
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>> 
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
