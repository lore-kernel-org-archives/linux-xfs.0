Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2860F7F50
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 15:48:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9550AC002
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 13:48:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RMS5pZKa7H93pQgO for
	<xfs@oss.sgi.com>; Thu, 02 May 2013 13:48:38 -0700 (PDT)
Message-ID: <5182D123.80005@redhat.com>
Date: Thu, 02 May 2013 15:48:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
References: <51827DDF.4050708@redhat.com>
	<1367509132.4098.86.camel@chandra-dt.ibm.com>
	<51828F84.3040508@sandeen.net>
	<1367516658.4098.87.camel@chandra-dt.ibm.com>
	<5182B0FE.4030301@sandeen.net> <5182CE0D.8030502@gmail.com>
In-Reply-To: <5182CE0D.8030502@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sekharan@us.ibm.com, xfs-oss <xfs@oss.sgi.com>

On 5/2/13 3:35 PM, Michael L. Semon wrote:
> On 05/02/2013 02:31 PM, Eric Sandeen wrote:
>> On 5/2/13 12:44 PM, Chandra Seetharaman wrote:
>>> On Thu, 2013-05-02 at 11:08 -0500, Eric Sandeen wrote:
>>>> On 5/2/13 10:38 AM, Chandra Seetharaman wrote:
>>>>> On Thu, 2013-05-02 at 09:53 -0500, Eric Sandeen wrote:
>>>>>> Pull all of the old xfs_check script into common/rc:_xfs_check()
>>>>>> so that it properly handles all options, including external log
>>>>>> devices.
>>>>>
>>>>> I see changes only related to USAGE. iiuc, log devices are handled
>>>>> properly by current code.
>>>>
>>>> also:
>>>>
>>>>>> +    set -- extra $@
>>>>>> +    shift $OPTIND
>>>>
>>>> have you *tested* log devices w/ your original code?  It failed for
>>>> Michael and for myself, so...  ;)
>>>>
>>>> -Eric
>>>
>>> yikes. sorry :(
> 
> No worries, Chandra.  I couldn't even get the echo line for Eric's patched version and execute the script in the same pass.  There's something about debugging the passing of arguments in bash that is simply evil.
> 
>> It's ok - I reviewed it, but I didn't test it.  ;)  It happens.
>>
>> -Eric
>>
> 
> Oh, so leave it to me to hack my lone swap partition on this PC into a two-segment dm-linear device so I can test this...OK...that was successful for a change!  Even though `git am` complained about the whitespace (E-mail issue?), the patch worked as well.
> 
> Anyway, there are issues with these tests and whether the partitions are mounted at the time ./check is run, but that will be posted after my closing, just to put it out there that issues may exist in the mount checking.  [And I'm sure that I did an `export USE_EXTERNAL="yes"`, so it's surprising how the tests went about mounting.]
> 
> =====================================================================
> This is how things went before using Eric's patch:
> 
> root@plbearer:/var/lib/xfstests# ./check generic/001
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/tData,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> common/rc: retrying test device mount with external set
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/i686 plbearer 3.8.11
> 
> _check_xfs_filesystem: filesystem on /dev/mapper/tData is inconsistent (c) (see .full)
> Passed all 0 tests
> root@plbearer:/var/lib/xfstests# cat .full
> _check_xfs_filesystem: filesystem on /dev/mapper/tData is inconsistent
> *** xfs_check output ***
> Usage: xfs_check [-ifFrxV] [-p prog] [-l logdev] [-c cmd]... device
> *** end xfs_check output
> *** mount output ***
> /dev/sda1 on / type xfs (rw,uquota)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> /dev/sda6 on /alt_sys type xfs (ro)
> tmpfs on /dev/shm type tmpfs (rw)
> debugfs on /sys/kernel/debug type debugfs (rw)
> /dev/sdb1 on /media/uGeneral type f2fs (rw)
> *** end mount output
> 
> Here is the echo line of what command was run:
> /usr/sbin/xfs_db -l /dev/mapper/tLog -F -i -p xfs_check -c check -l/dev/mapper/tLog
> 
> =====================================================================
> This is how things went after using Eric's patch:
> 
> root@plbearer:/var/lib/xfstests# ./check generic/001
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/tData,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

Yeah this seems . . . suboptimal, I haven't looked into it.

If TEST_LOGDEV is set it seems like that should be the *first* thing
to try.  I don't recall if it did this before the reorganization.

FWIW, I've seen problems in the past when using devicemapper devices.
One never knows what's a symlink ;)

If you specify /dev/dm-X instead of the pretty name, does it go any
better for you?

(I don't remember if that helped; I remember chasing dm issues before.
I just don't use dm in my testing anymore, TBH) :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
