Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB61aPCh074800 for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 19:36:25 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id fV6IpQc8IEoovK4R
	for <xfs@oss.sgi.com>; Wed, 05 Dec 2012 17:38:49 -0800 (PST)
Message-ID: <50BFF726.6090006@hardwarefreak.com>
Date: Wed, 05 Dec 2012 19:38:46 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfsdump INTERRUPT issue
References: <CCE505AA.B05B7%jellis@dhnet.us>
In-Reply-To: <CCE505AA.B05B7%jellis@dhnet.us>
Reply-To: stan@hardwarefreak.com
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
To: "J. Ellis" <jellis@dhnet.us>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/5/2012 1:07 PM, J. Ellis wrote:

This should never have gone off list so I'm copying back.  If you'd have
kept this on list you'd have likely already had an answer to this.
Going off list for fear of looking ignorant is not a valid reason to do
so.  In fact there are very few reasons to ever go off list.  All it
does is take people out of the loop who are watching the thread and may
be willing to jump in at some point to help.  You've short circuited
that by going off list.

> I just read the man page again. There doesn't seem to be any examples I can
> find to write the dump to a file. I couldn't find a -t option in the man at
> all, so maybe the ones I'm finding aren't up to date. Here's the only
> example I can find, and I don't know if this would actually work:
> 
> xfsdump -f /usr/tmp/monday_backup -v silent -J -s \ people/fred/Makefile -s
> people/fred/Source /usr

This is really simple.  Using my previous example, we want to dump to a
test file and not update the inventory.  So we have something like:

~$ xfsdump -J -f /some_filesystem_path/test_dump /dev/sda6

This dumps the XFS filesystem on /dev/sda6 to a file.  Don't write the
dump file to the filesystem you're dumping.  Preferably the XFS you're
dumping is on one disk or array and the target file will be written to a
different disk or array.  Dumps are IO intensive.

I clearly stated the "-t" option in the context of xfsrestore:

       -t   Displays  the  contents of the dump, but does not create or
            modify any files or directories.  It may be desirable to
            set the verbosity level to silent when using this option.

This allows you to do a test run without actually writing any files
during the restore.  The goal here is to test xfsdump and xfsrestore on
your system to see where errors are cropping up.  You don't actually
want to restore the dumped filesystem at this point.

The "-v" option simply keeps the "-t" from spamming a million file names
to your console during the restore operation.

-- 
Stan


> on 12/4/12 10:32 PM, Stan Hoeppner at stan@hardwarefreak.com wrote:
> 
>> On 12/4/2012 7:18 PM, J. Ellis wrote:
>>> Hi, Stan--
>>>
>>> Ok, I truly apologize for my ignorance, but I don't know how to dump the
>>> contents to a file. Is it something like:
>>>
>>> xfsdump -J - somefile_xfsdump.txt
>>
>> ~$ man xfsdump
>>
>> Look at option "-f".
>>
>>> xfsrestore -J - somefile_xfsrestore.txt
>>
>> ~$ man xfsrestore
>>
>> See options "-f" "-t" and "-v".
>>
>> The point of this exercise I believe is to see what errors are thrown by
>> xfsdump or xfsrestore when they are executed independently, vs through a
>> pipe.  Do note that this may not be the final step in testing before you
>> have an answer.  Post any errors or informational output that results
>> from these commands.
>>
>> Note that the file written by xfsdump is going to be about the same size
>> as the filesystem being dumped.  I.e. if the filesystem being dumped is
>> 1TB then you need 1TB of free space on the device where the target
>> directory resides--you're dumping an entire XFS filesystem into a single
>> file.  Also, be sure to use "-t" so xfsrestore doesn't actually write
>> anything.  Did you read "-v"?
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
