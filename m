Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B99D37F50
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 15:35:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A9678F804B
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 13:35:38 -0700 (PDT)
Received: from mail-vb0-f44.google.com (mail-vb0-f44.google.com
	[209.85.212.44]) by cuda.sgi.com with ESMTP id AzuueWxuyVpfljGt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 May 2013 13:35:36 -0700 (PDT)
Received: by mail-vb0-f44.google.com with SMTP id e13so847256vbg.17
	for <xfs@oss.sgi.com>; Thu, 02 May 2013 13:35:36 -0700 (PDT)
Message-ID: <5182CE0D.8030502@gmail.com>
Date: Thu, 02 May 2013 16:35:25 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
References: <51827DDF.4050708@redhat.com>
	<1367509132.4098.86.camel@chandra-dt.ibm.com>
	<51828F84.3040508@sandeen.net>
	<1367516658.4098.87.camel@chandra-dt.ibm.com>
	<5182B0FE.4030301@sandeen.net>
In-Reply-To: <5182B0FE.4030301@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, sekharan@us.ibm.com, xfs-oss <xfs@oss.sgi.com>

On 05/02/2013 02:31 PM, Eric Sandeen wrote:
> On 5/2/13 12:44 PM, Chandra Seetharaman wrote:
>> On Thu, 2013-05-02 at 11:08 -0500, Eric Sandeen wrote:
>>> On 5/2/13 10:38 AM, Chandra Seetharaman wrote:
>>>> On Thu, 2013-05-02 at 09:53 -0500, Eric Sandeen wrote:
>>>>> Pull all of the old xfs_check script into common/rc:_xfs_check()
>>>>> so that it properly handles all options, including external log
>>>>> devices.
>>>>
>>>> I see changes only related to USAGE. iiuc, log devices are handled
>>>> properly by current code.
>>>
>>> also:
>>>
>>>>> +    set -- extra $@
>>>>> +    shift $OPTIND
>>>
>>> have you *tested* log devices w/ your original code?  It failed for
>>> Michael and for myself, so...  ;)
>>>
>>> -Eric
>>
>> yikes. sorry :(

No worries, Chandra.  I couldn't even get the echo line for Eric's 
patched version and execute the script in the same pass.  There's 
something about debugging the passing of arguments in bash that is 
simply evil.

> It's ok - I reviewed it, but I didn't test it.  ;)  It happens.
>
> -Eric
>

Oh, so leave it to me to hack my lone swap partition on this PC into a 
two-segment dm-linear device so I can test this...OK...that was 
successful for a change!  Even though `git am` complained about the 
whitespace (E-mail issue?), the patch worked as well.

Anyway, there are issues with these tests and whether the partitions are 
mounted at the time ./check is run, but that will be posted after my 
closing, just to put it out there that issues may exist in the mount 
checking.  [And I'm sure that I did an `export USE_EXTERNAL="yes"`, so 
it's surprising how the tests went about mounting.]

=====================================================================
This is how things went before using Eric's patch:

root@plbearer:/var/lib/xfstests# ./check generic/001
mount: wrong fs type, bad option, bad superblock on /dev/mapper/tData,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

common/rc: retrying test device mount with external set
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

_check_xfs_filesystem: filesystem on /dev/mapper/tData is inconsistent 
(c) (see .full)
Passed all 0 tests
root@plbearer:/var/lib/xfstests# cat .full
_check_xfs_filesystem: filesystem on /dev/mapper/tData is inconsistent
*** xfs_check output ***
Usage: xfs_check [-ifFrxV] [-p prog] [-l logdev] [-c cmd]... device
*** end xfs_check output
*** mount output ***
/dev/sda1 on / type xfs (rw,uquota)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
/dev/sda6 on /alt_sys type xfs (ro)
tmpfs on /dev/shm type tmpfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
/dev/sdb1 on /media/uGeneral type f2fs (rw)
*** end mount output

Here is the echo line of what command was run:
/usr/sbin/xfs_db -l /dev/mapper/tLog -F -i -p xfs_check -c check 
-l/dev/mapper/tLog

=====================================================================
This is how things went after using Eric's patch:

root@plbearer:/var/lib/xfstests# ./check generic/001
mount: wrong fs type, bad option, bad superblock on /dev/mapper/tData,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

common/rc: retrying test device mount with external set
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

generic/001      7s
Ran: generic/001
Passed all 1 tests

Here is the echo line of what command was run:
/usr/sbin/xfs_db -l /dev/mapper/tLog -F -i -p xfs_check -c check 
/dev/mapper/tData

=====================================================================

Anyway, thanks for the patch!  It will put me back on track.  This 
xfstests restructuring looks like a significant undertaking, and issues 
along the way are expected.

Good luck!

Michael

=====================================================================
P.S. - This is what three passes in a row looks like, using Eric's 
patched version of ./check:

RUN #1
root@plbearer:/var/lib/xfstests# mount | grep mapper

root@plbearer:/var/lib/xfstests# ./check -xfs generic/001 generic/002
mount: wrong fs type, bad option, bad superblock on /dev/mapper/tData,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

common/rc: retrying test device mount with external set
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

generic/001      7s
generic/002      0s
Ran: generic/001 generic/002
Passed all 2 tests

RUN #2
root@plbearer:/var/lib/xfstests# mount | grep mapper
/dev/mapper/tData on /mnt/testdir type xfs (rw,logdev=/dev/mapper/tLog)

root@plbearer:/var/lib/xfstests# ./check -xfs generic/001 generic/002
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

_check_xfs_filesystem: filesystem on /dev/mapper/tData has dirty log 
(see .full)
_check_xfs_filesystem: filesystem on /dev/mapper/tData is inconsistent 
(c) (see .full)
_check_xfs_filesystem: filesystem on /dev/mapper/tData is inconsistent 
(r) (see .full)
Passed all 0 tests

RUN #3
root@plbearer:/var/lib/xfstests# mount | grep mapper

root@plbearer:/var/lib/xfstests# ./check -xfs generic/001 generic/002
mount: wrong fs type, bad option, bad superblock on /dev/mapper/tData,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

common/rc: retrying test device mount with external set
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

generic/001      7s
generic/002      1s
Ran: generic/001 generic/002
Passed all 2 tests

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
