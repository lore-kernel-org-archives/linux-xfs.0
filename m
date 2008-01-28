Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Jan 2008 23:21:42 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0S7LRKM003413
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2008 23:21:32 -0800
Message-ID: <479D825F.5060305@mpigani.org>
Date: Mon, 28 Jan 2008 02:21:03 -0500
From: Dragos <dragos@mpigani.org>
MIME-Version: 1.0
Subject: Re: assemble vs create an array.......
Content-Type: multipart/mixed;
 boundary="------------050705000404000303010802"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: David Greaves <david@dgreaves.com>, mjt@tls.msk.ru, sandeen@sandeen.net, dgc@sgi.com

This is a multi-part message in MIME format.
--------------050705000404000303010802
Content-Type: multipart/alternative;
 boundary="------------040600020304090402010209"

--------------040600020304090402010209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
Have a Happy New and Prosperous Year.

First of all, thank you again for all your previous answers.

The last message I received regarding my issue was on 12.06 so I should 
refresh your memories. I passed a --create option instead of --assemble 
on top of an existing  raid 5 array formatted with xfs.

I followed your advice and here is a table of my results so far. I also 
attached the results of the first combination (w/ -c128 option). A quick 
diff on the 3 combinations with the least number of errors (abm, amc, 
mbc) showed few differences. Do you need to see the other reports?

At this point it seems that doing a xfs_repair on the first combination 
would be ok. What do you think? Are there any options I should pass to 
xfs_repair to increase my chances?

I hope you can continue to enlighten me with your knowledge and experience.

Thank you in advance for your time and help,
Dragos


mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sda1 /dev/sdb1 
missing

--------- without and with --chunk=128

mount /dev/md0 t

xfs_repair -n /dev/md0 2> xfs_repair-abm.txt

mdadm --stop /dev/md0

*combination*

	

*mount response*

	

*xfs_repair: **size of report file & tty output w/o & w/ -c128*

a b m

	

structure needs cleaning

	

7.9Mb

No modify flag set, skipping phase 5

56.2kb

No modify flag set, skipping phase 5

a m b

	

structure needs cleaning

	

4.9Mb

No modify flag set, skipping phase 5

1.9Gb

No modify flag set, skipping phase 5

m a b

	

you must specify the filesystem type

	


a c m

	

structure needs cleaning

	

4.9Mb

nothing

1.9Gb

No modify flag set, skipping phase 5

a m c

	

structure needs cleaning

	

7.9Mb

No modify flag set, skipping phase 5

56.2kb

No modify flag set, skipping phase 5

m a c

	

you must specify the filesystem type

	


b c m

	

you must specify the filesystem type

	


b m c

	

you must specify the filesystem type

	


m b c

	

structure needs cleaning

	

7.9Mb

No modify flag set, skipping phase 5

56.2kb

No modify flag set, skipping phase 5

b a m

	

you must specify the filesystem type

	


b m a

	

you must specify the filesystem type

	


m b a

	

you must specify the filesystem type

	


c a m

	

you must specify the filesystem type

	


c m a

	

you must specify the filesystem type

	


m c a

	

you must specify the filesystem type

	


c b m

	

you must specify the filesystem type

	


c m b

	

you must specify the filesystem type

	


m c b

	

structure needs cleaning

	

4.9Mb

No modify flag set, skipping phase 5

1.9Gb

No modify flag set, skipping phase 5


--------------040600020304090402010209
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
Hello,<br>
Have a Happy New and Prosperous Year.<br>
<br>
First of all, thank you again for all your previous answers.<br>
<br>
The last message I received regarding my issue was on 12.06 so I should
refresh your memories. I passed a --create option instead of --assemble
on top of an existing&nbsp; raid 5 array formatted with xfs.<br>
<br>
I followed your advice and here is a table of my results so far. I also
attached the results of the first combination (w/ -c128 option). A
quick diff on the 3 combinations with the least number of errors (abm,
amc, mbc) showed few differences. Do you need to see the other reports?<br>
<br>
At this point it seems that doing a xfs_repair on the first combination
would be ok. What do you think? Are there any options I should pass to
xfs_repair to increase my chances?<br>
<br>
I hope you can continue to enlighten me with your knowledge and
experience.<br>
<br>
Thank you in advance for your time and help,<br>
Dragos<br>
<br>
<br>
<table border="1" bordercolor="#000000" cellpadding="5" cellspacing="0"
 width="100%">
  <col width="40*"> <col width="90*"> <col width="126*"> <tbody>
    <tr>
      <td colspan="3" valign="top" width="100%">
      <p>mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sda1
/dev/sdb1 missing</p>
      <p>--------- without and with &#8211;chunk=128</p>
      <p>mount /dev/md0 t</p>
      <p>xfs_repair -n /dev/md0 2&gt; xfs_repair-abm.txt </p>
      <p>mdadm &#8211;stop /dev/md0</p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p><b>combination</b></p>
      </td>
      <td width="35%">
      <p><b>mount response</b></p>
      </td>
      <td width="49%">
      <p><b>xfs_repair: </b><b>size of report file &amp; tty output
w/o &amp; w/ -c128</b></p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">a
b m</span></p>
      </td>
      <td width="35%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">structure
needs cleaning</span></p>
      </td>
      <td width="49%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">7.9Mb<br>
      </span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5 </span> </p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">56.2kb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">a
m b</span></p>
      </td>
      <td width="35%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">structure
needs cleaning</span></p>
      </td>
      <td width="49%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">4.9Mb<br>
      </span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5 </span> </p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">1.9Gb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>m a b</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">a
c m</span></p>
      </td>
      <td width="35%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">structure
needs cleaning</span></p>
      </td>
      <td width="49%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">4.9Mb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">nothing</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">1.9Gb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">a
m c</span></p>
      </td>
      <td width="35%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">structure
needs cleaning</span></p>
      </td>
      <td width="49%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">7.9Mb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5 </span> </p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">56.2kb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>m a c</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>b c m</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>b m c</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">m
b c</span></p>
      </td>
      <td width="35%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">structure
needs cleaning</span></p>
      </td>
      <td width="49%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">7.9Mb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">56.2kb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>b a m</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>b m a</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>m b a</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>c a m</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>c m a</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>m c a</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>c b m</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p>c m b</p>
      </td>
      <td width="35%">
      <p>you must specify the filesystem type</p>
      </td>
      <td width="49%">
      <p><br>
      </p>
      </td>
    </tr>
    <tr valign="top">
      <td width="16%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">m
c b</span></p>
      </td>
      <td width="35%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">structure
needs cleaning</span></p>
      </td>
      <td width="49%">
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">4.9Mb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">1.9Gb</span></p>
      <p><span
 style="background: rgb(255, 255, 0) none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">No
modify flag set, skipping phase 5</span></p>
      </td>
    </tr>
  </tbody>
</table>
</body>
</html>

--------------040600020304090402010209--

--------------050705000404000303010802
Content-Type: text/plain;
 name="xfs_repair-abm-128.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_repair-abm-128.txt"

        - creating 4 worker thread(s)
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - 16:11:50: scanning filesystem freespace - 16 of 16 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 16:11:50: scanning agi unlinked lists - 16 of 16 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
bad magic number 0xfeed on inode 1074266624
bad version number 0x0 on inode 1074266624
bad inode format in inode 1074266624
bad magic number 0x0 on inode 1074266625
bad version number 0x0 on inode 1074266625
bad (negative) size -7746721568139339722 on inode 1074266625
bad magic number 0xfeed on inode 1074266626
bad version number 0x0 on inode 1074266626
bad inode format in inode 1074266626
bad magic number 0x0 on inode 1074266627
bad version number 0x0 on inode 1074266627
bad (negative) size -7746721568139339722 on inode 1074266627
bad magic number 0xfeed on inode 1074266628
bad version number 0x0 on inode 1074266628
bad inode format in inode 1074266628
bad magic number 0x0 on inode 1074266629
bad version number 0x0 on inode 1074266629
bad (negative) size -7746721568139339722 on inode 1074266629
bad magic number 0xfeed on inode 1074266630
bad version number 0x0 on inode 1074266630
bad inode format in inode 1074266630
bad magic number 0x0 on inode 1074266631
bad version number 0x0 on inode 1074266631
bad (negative) size -7746721568139339722 on inode 1074266631
bad magic number 0xfeed on inode 1074266632
bad version number 0x0 on inode 1074266632
bad inode format in inode 1074266632
bad magic number 0x0 on inode 1074266633
bad version number 0x0 on inode 1074266633
bad (negative) size -7746721568139339722 on inode 1074266633
bad magic number 0xfeed on inode 1074266634
bad version number 0x0 on inode 1074266634
bad inode format in inode 1074266634
bad magic number 0x0 on inode 1074266635
bad version number 0x0 on inode 1074266635
bad (negative) size -7746721568139339722 on inode 1074266635
bad magic number 0xfeed on inode 1074266636
bad version number 0x0 on inode 1074266636
bad inode format in inode 1074266636
bad magic number 0x0 on inode 1074266637
bad version number 0x0 on inode 1074266637
bad (negative) size -7746721568139339722 on inode 1074266637
bad magic number 0xfeed on inode 1074266638
bad version number 0x0 on inode 1074266638
bad inode format in inode 1074266638
bad magic number 0x0 on inode 1074266639
bad version number 0x0 on inode 1074266639
bad (negative) size -7746721568139339722 on inode 1074266639
bad magic number 0xfeed on inode 1074266640
bad version number 0x0 on inode 1074266640
bad inode format in inode 1074266640
bad magic number 0x0 on inode 1074266641
bad version number 0x0 on inode 1074266641
bad (negative) size -7746721568139339722 on inode 1074266641
bad magic number 0xfeed on inode 1074266642
bad version number 0x0 on inode 1074266642
bad inode format in inode 1074266642
bad magic number 0x0 on inode 1074266643
bad version number 0x0 on inode 1074266643
bad (negative) size -7746721568139339722 on inode 1074266643
bad magic number 0xfeed on inode 1074266644
bad version number 0x0 on inode 1074266644
bad inode format in inode 1074266644
bad magic number 0x0 on inode 1074266645
bad version number 0x0 on inode 1074266645
bad (negative) size -7746721568139339722 on inode 1074266645
bad magic number 0xfeed on inode 1074266646
bad version number 0x0 on inode 1074266646
bad inode format in inode 1074266646
bad magic number 0x0 on inode 1074266647
bad version number 0x0 on inode 1074266647
bad (negative) size -7746721568139339722 on inode 1074266647
bad magic number 0xfeed on inode 1074266648
bad version number 0x0 on inode 1074266648
bad inode format in inode 1074266648
bad magic number 0x0 on inode 1074266649
bad version number 0x0 on inode 1074266649
bad (negative) size -7746721568139339722 on inode 1074266649
bad magic number 0xfeed on inode 1074266650
bad version number 0x0 on inode 1074266650
bad inode format in inode 1074266650
bad magic number 0x0 on inode 1074266651
bad version number 0x0 on inode 1074266651
bad (negative) size -7746721568139339722 on inode 1074266651
bad magic number 0xfeed on inode 1074266652
bad version number 0x0 on inode 1074266652
bad inode format in inode 1074266652
bad magic number 0x0 on inode 1074266653
bad version number 0x0 on inode 1074266653
bad (negative) size -7746721568139339722 on inode 1074266653
bad magic number 0xfeed on inode 1074266654
bad version number 0x0 on inode 1074266654
bad inode format in inode 1074266654
bad magic number 0x0 on inode 1074266655
bad version number 0x0 on inode 1074266655
bad (negative) size -7746721568139339722 on inode 1074266655
bad magic number 0xfeed on inode 1074266656
bad version number 0x0 on inode 1074266656
bad inode format in inode 1074266656
bad magic number 0x0 on inode 1074266657
bad version number 0x0 on inode 1074266657
bad (negative) size -7746721568139339722 on inode 1074266657
bad magic number 0xfeed on inode 1074266658
bad version number 0x0 on inode 1074266658
bad inode format in inode 1074266658
bad magic number 0x0 on inode 1074266659
bad version number 0x0 on inode 1074266659
bad (negative) size -7746721568139339722 on inode 1074266659
bad magic number 0xfeed on inode 1074266660
bad version number 0x0 on inode 1074266660
bad inode format in inode 1074266660
bad magic number 0x0 on inode 1074266661
bad version number 0x0 on inode 1074266661
bad (negative) size -7746721568139339722 on inode 1074266661
bad magic number 0xfeed on inode 1074266662
bad version number 0x0 on inode 1074266662
bad inode format in inode 1074266662
bad magic number 0x0 on inode 1074266663
bad version number 0x0 on inode 1074266663
bad (negative) size -7746721568139339722 on inode 1074266663
bad magic number 0xfeed on inode 1074266664
bad version number 0x0 on inode 1074266664
bad inode format in inode 1074266664
bad magic number 0x0 on inode 1074266665
bad version number 0x0 on inode 1074266665
bad (negative) size -7746721568139339722 on inode 1074266665
bad magic number 0xfeed on inode 1074266666
bad version number 0x0 on inode 1074266666
bad inode format in inode 1074266666
bad magic number 0x0 on inode 1074266667
bad version number 0x0 on inode 1074266667
bad (negative) size -7746721568139339722 on inode 1074266667
bad magic number 0xfeed on inode 1074266668
bad version number 0x0 on inode 1074266668
bad inode format in inode 1074266668
bad magic number 0x0 on inode 1074266669
bad version number 0x0 on inode 1074266669
bad (negative) size -7746721568139339722 on inode 1074266669
bad magic number 0xfeed on inode 1074266670
bad version number 0x0 on inode 1074266670
bad inode format in inode 1074266670
bad magic number 0x0 on inode 1074266671
bad version number 0x0 on inode 1074266671
bad (negative) size -7746721568139339722 on inode 1074266671
bad magic number 0xfeed on inode 1074266672
bad version number 0x0 on inode 1074266672
bad inode format in inode 1074266672
bad magic number 0x0 on inode 1074266673
bad version number 0x0 on inode 1074266673
bad (negative) size -7746721568139339722 on inode 1074266673
bad magic number 0xfeed on inode 1074266674
bad version number 0x0 on inode 1074266674
bad inode format in inode 1074266674
bad magic number 0x0 on inode 1074266675
bad version number 0x0 on inode 1074266675
bad (negative) size -7746721568139339722 on inode 1074266675
bad magic number 0xfeed on inode 1074266676
bad version number 0x0 on inode 1074266676
bad inode format in inode 1074266676
bad magic number 0x0 on inode 1074266677
bad version number 0x0 on inode 1074266677
bad (negative) size -7746721568139339722 on inode 1074266677
bad magic number 0xfeed on inode 1074266678
bad version number 0x0 on inode 1074266678
bad inode format in inode 1074266678
bad magic number 0x0 on inode 1074266679
bad version number 0x0 on inode 1074266679
bad (negative) size -7746721568139339722 on inode 1074266679
bad magic number 0xfeed on inode 1074266680
bad version number 0x0 on inode 1074266680
bad inode format in inode 1074266680
bad magic number 0x0 on inode 1074266681
bad version number 0x0 on inode 1074266681
bad (negative) size -7746721568139339722 on inode 1074266681
bad magic number 0xfeed on inode 1074266682
bad version number 0x0 on inode 1074266682
bad inode format in inode 1074266682
bad magic number 0x0 on inode 1074266683
bad version number 0x0 on inode 1074266683
bad (negative) size -7746721568139339722 on inode 1074266683
bad magic number 0xfeed on inode 1074266684
bad version number 0x0 on inode 1074266684
bad inode format in inode 1074266684
bad magic number 0x0 on inode 1074266685
bad version number 0x0 on inode 1074266685
bad (negative) size -7746721568139339722 on inode 1074266685
bad magic number 0xfeed on inode 1074266686
bad version number 0x0 on inode 1074266686
bad inode format in inode 1074266686
bad magic number 0x0 on inode 1074266687
bad version number 0x0 on inode 1074266687
bad (negative) size -7746721568139339722 on inode 1074266687
bad magic number 0xfeed on inode 1074266688
bad version number 0x0 on inode 1074266688
bad inode format in inode 1074266688
bad magic number 0x0 on inode 1074266689
bad version number 0x0 on inode 1074266689
bad (negative) size -7746721568139339722 on inode 1074266689
bad magic number 0xfeed on inode 1074266690
bad version number 0x0 on inode 1074266690
bad inode format in inode 1074266690
bad magic number 0x0 on inode 1074266691
bad version number 0x0 on inode 1074266691
bad (negative) size -7746721568139339722 on inode 1074266691
bad magic number 0xfeed on inode 1074266692
bad version number 0x0 on inode 1074266692
bad inode format in inode 1074266692
bad magic number 0x0 on inode 1074266693
bad version number 0x0 on inode 1074266693
bad (negative) size -7746721568139339722 on inode 1074266693
bad magic number 0xfeed on inode 1074266694
bad version number 0x0 on inode 1074266694
bad inode format in inode 1074266694
bad magic number 0x0 on inode 1074266695
bad version number 0x0 on inode 1074266695
bad (negative) size -7746721568139339722 on inode 1074266695
bad magic number 0xfeed on inode 1074266696
bad version number 0x0 on inode 1074266696
bad inode format in inode 1074266696
bad magic number 0x0 on inode 1074266697
bad version number 0x0 on inode 1074266697
bad (negative) size -7746721568139339722 on inode 1074266697
bad magic number 0xfeed on inode 1074266698
bad version number 0x0 on inode 1074266698
bad inode format in inode 1074266698
bad magic number 0x0 on inode 1074266699
bad version number 0x0 on inode 1074266699
bad (negative) size -7746721568139339722 on inode 1074266699
bad magic number 0xfeed on inode 1074266700
bad version number 0x0 on inode 1074266700
bad inode format in inode 1074266700
bad magic number 0x0 on inode 1074266701
bad version number 0x0 on inode 1074266701
bad (negative) size -7746721568139339722 on inode 1074266701
bad magic number 0xfeed on inode 1074266702
bad version number 0x0 on inode 1074266702
bad inode format in inode 1074266702
bad magic number 0x0 on inode 1074266703
bad version number 0x0 on inode 1074266703
bad (negative) size -7746721568139339722 on inode 1074266703
bad magic number 0xfeed on inode 1074266704
bad version number 0x0 on inode 1074266704
bad inode format in inode 1074266704
bad magic number 0x0 on inode 1074266705
bad version number 0x0 on inode 1074266705
bad (negative) size -7746721568139339722 on inode 1074266705
bad magic number 0xfeed on inode 1074266706
bad version number 0x0 on inode 1074266706
bad inode format in inode 1074266706
bad magic number 0x0 on inode 1074266707
bad version number 0x0 on inode 1074266707
bad (negative) size -7746721568139339722 on inode 1074266707
bad magic number 0xfeed on inode 1074266708
bad version number 0x0 on inode 1074266708
bad inode format in inode 1074266708
bad magic number 0x0 on inode 1074266709
bad version number 0x0 on inode 1074266709
bad (negative) size -7746721568139339722 on inode 1074266709
bad magic number 0xfeed on inode 1074266710
bad version number 0x0 on inode 1074266710
bad inode format in inode 1074266710
bad magic number 0x0 on inode 1074266711
bad version number 0x0 on inode 1074266711
bad (negative) size -7746721568139339722 on inode 1074266711
bad magic number 0xfeed on inode 1074266712
bad version number 0x0 on inode 1074266712
bad inode format in inode 1074266712
bad magic number 0x0 on inode 1074266713
bad version number 0x0 on inode 1074266713
bad (negative) size -7746721568139339722 on inode 1074266713
bad magic number 0xfeed on inode 1074266714
bad version number 0x0 on inode 1074266714
bad inode format in inode 1074266714
bad magic number 0x0 on inode 1074266715
bad version number 0x0 on inode 1074266715
bad (negative) size -7746721568139339722 on inode 1074266715
bad magic number 0xfeed on inode 1074266716
bad version number 0x0 on inode 1074266716
bad inode format in inode 1074266716
bad magic number 0x0 on inode 1074266717
bad version number 0x0 on inode 1074266717
bad (negative) size -7746721568139339722 on inode 1074266717
bad magic number 0xfeed on inode 1074266718
bad version number 0x0 on inode 1074266718
bad inode format in inode 1074266718
bad magic number 0x0 on inode 1074266719
bad version number 0x0 on inode 1074266719
bad (negative) size -7746721568139339722 on inode 1074266719
bad magic number 0xfeed on inode 1074266720
bad version number 0x0 on inode 1074266720
bad inode format in inode 1074266720
bad magic number 0x0 on inode 1074266721
bad version number 0x0 on inode 1074266721
bad (negative) size -7746721568139339722 on inode 1074266721
bad magic number 0xfeed on inode 1074266722
bad version number 0x0 on inode 1074266722
bad inode format in inode 1074266722
bad magic number 0x0 on inode 1074266723
bad version number 0x0 on inode 1074266723
bad (negative) size -7746721568139339722 on inode 1074266723
bad magic number 0xfeed on inode 1074266724
bad version number 0x0 on inode 1074266724
bad inode format in inode 1074266724
bad magic number 0x0 on inode 1074266725
bad version number 0x0 on inode 1074266725
bad (negative) size -7746721568139339722 on inode 1074266725
bad magic number 0xfeed on inode 1074266726
bad version number 0x0 on inode 1074266726
bad inode format in inode 1074266726
bad magic number 0x0 on inode 1074266727
bad version number 0x0 on inode 1074266727
bad (negative) size -7746721568139339722 on inode 1074266727
bad magic number 0xfeed on inode 1074266728
bad version number 0x0 on inode 1074266728
bad inode format in inode 1074266728
bad magic number 0x0 on inode 1074266729
bad version number 0x0 on inode 1074266729
bad (negative) size -7746721568139339722 on inode 1074266729
bad magic number 0xfeed on inode 1074266730
bad version number 0x0 on inode 1074266730
bad inode format in inode 1074266730
bad magic number 0x0 on inode 1074266731
bad version number 0x0 on inode 1074266731
bad (negative) size -7746721568139339722 on inode 1074266731
bad magic number 0xfeed on inode 1074266732
bad version number 0x0 on inode 1074266732
bad inode format in inode 1074266732
bad magic number 0x0 on inode 1074266733
bad version number 0x0 on inode 1074266733
bad (negative) size -7746721568139339722 on inode 1074266733
bad magic number 0xfeed on inode 1074266734
bad version number 0x0 on inode 1074266734
bad inode format in inode 1074266734
bad magic number 0x0 on inode 1074266735
bad version number 0x0 on inode 1074266735
bad (negative) size -7746721568139339722 on inode 1074266735
bad magic number 0xfeed on inode 1074266688, would reset magic number
bad version number 0x0 on inode 1074266688, would reset version number
bad inode format in inode 1074266688
would have cleared inode 1074266688
bad magic number 0x0 on inode 1074266689, would reset magic number
bad version number 0x0 on inode 1074266689, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266689
would have cleared inode 1074266689
bad magic number 0xfeed on inode 1074266690, would reset magic number
bad version number 0x0 on inode 1074266690, would reset version number
bad inode format in inode 1074266690
would have cleared inode 1074266690
bad magic number 0x0 on inode 1074266691, would reset magic number
bad version number 0x0 on inode 1074266691, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266691
would have cleared inode 1074266691
bad magic number 0xfeed on inode 1074266692, would reset magic number
bad version number 0x0 on inode 1074266692, would reset version number
bad inode format in inode 1074266692
would have cleared inode 1074266692
bad magic number 0x0 on inode 1074266693, would reset magic number
bad version number 0x0 on inode 1074266693, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266693
would have cleared inode 1074266693
bad magic number 0xfeed on inode 1074266694, would reset magic number
bad version number 0x0 on inode 1074266694, would reset version number
bad inode format in inode 1074266694
would have cleared inode 1074266694
bad magic number 0x0 on inode 1074266695, would reset magic number
bad version number 0x0 on inode 1074266695, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266695
would have cleared inode 1074266695
bad magic number 0xfeed on inode 1074266696, would reset magic number
bad version number 0x0 on inode 1074266696, would reset version number
bad inode format in inode 1074266696
would have cleared inode 1074266696
bad magic number 0x0 on inode 1074266697, would reset magic number
bad version number 0x0 on inode 1074266697, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266697
would have cleared inode 1074266697
bad magic number 0xfeed on inode 1074266698, would reset magic number
bad version number 0x0 on inode 1074266698, would reset version number
bad inode format in inode 1074266698
would have cleared inode 1074266698
bad magic number 0x0 on inode 1074266699, would reset magic number
bad version number 0x0 on inode 1074266699, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266699
would have cleared inode 1074266699
bad magic number 0xfeed on inode 1074266700, would reset magic number
bad version number 0x0 on inode 1074266700, would reset version number
bad inode format in inode 1074266700
would have cleared inode 1074266700
bad magic number 0x0 on inode 1074266701, would reset magic number
bad version number 0x0 on inode 1074266701, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266701
would have cleared inode 1074266701
bad magic number 0xfeed on inode 1074266702, would reset magic number
bad version number 0x0 on inode 1074266702, would reset version number
bad inode format in inode 1074266702
would have cleared inode 1074266702
bad magic number 0x0 on inode 1074266703, would reset magic number
bad version number 0x0 on inode 1074266703, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266703
would have cleared inode 1074266703
bad magic number 0xfeed on inode 1074266704, would reset magic number
bad version number 0x0 on inode 1074266704, would reset version number
bad inode format in inode 1074266704
would have cleared inode 1074266704
bad magic number 0x0 on inode 1074266705, would reset magic number
bad version number 0x0 on inode 1074266705, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266705
would have cleared inode 1074266705
bad magic number 0xfeed on inode 1074266706, would reset magic number
bad version number 0x0 on inode 1074266706, would reset version number
bad inode format in inode 1074266706
would have cleared inode 1074266706
bad magic number 0x0 on inode 1074266707, would reset magic number
bad version number 0x0 on inode 1074266707, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266707
would have cleared inode 1074266707
bad magic number 0xfeed on inode 1074266708, would reset magic number
bad version number 0x0 on inode 1074266708, would reset version number
bad inode format in inode 1074266708
would have cleared inode 1074266708
bad magic number 0x0 on inode 1074266709, would reset magic number
bad version number 0x0 on inode 1074266709, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266709
would have cleared inode 1074266709
bad magic number 0xfeed on inode 1074266710, would reset magic number
bad version number 0x0 on inode 1074266710, would reset version number
bad inode format in inode 1074266710
would have cleared inode 1074266710
bad magic number 0x0 on inode 1074266711, would reset magic number
bad version number 0x0 on inode 1074266711, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266711
would have cleared inode 1074266711
bad magic number 0xfeed on inode 1074266712, would reset magic number
bad version number 0x0 on inode 1074266712, would reset version number
bad inode format in inode 1074266712
would have cleared inode 1074266712
bad magic number 0x0 on inode 1074266713, would reset magic number
bad version number 0x0 on inode 1074266713, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266713
would have cleared inode 1074266713
bad magic number 0xfeed on inode 1074266714, would reset magic number
bad version number 0x0 on inode 1074266714, would reset version number
bad inode format in inode 1074266714
would have cleared inode 1074266714
bad magic number 0x0 on inode 1074266715, would reset magic number
bad version number 0x0 on inode 1074266715, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266715
would have cleared inode 1074266715
bad magic number 0xfeed on inode 1074266716, would reset magic number
bad version number 0x0 on inode 1074266716, would reset version number
bad inode format in inode 1074266716
would have cleared inode 1074266716
bad magic number 0x0 on inode 1074266717, would reset magic number
bad version number 0x0 on inode 1074266717, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266717
would have cleared inode 1074266717
bad magic number 0xfeed on inode 1074266718, would reset magic number
bad version number 0x0 on inode 1074266718, would reset version number
bad inode format in inode 1074266718
would have cleared inode 1074266718
bad magic number 0x0 on inode 1074266719, would reset magic number
bad version number 0x0 on inode 1074266719, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266719
would have cleared inode 1074266719
bad magic number 0xfeed on inode 1074266720, would reset magic number
bad version number 0x0 on inode 1074266720, would reset version number
bad inode format in inode 1074266720
would have cleared inode 1074266720
bad magic number 0x0 on inode 1074266721, would reset magic number
bad version number 0x0 on inode 1074266721, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266721
would have cleared inode 1074266721
bad magic number 0xfeed on inode 1074266722, would reset magic number
bad version number 0x0 on inode 1074266722, would reset version number
bad inode format in inode 1074266722
would have cleared inode 1074266722
bad magic number 0x0 on inode 1074266723, would reset magic number
bad version number 0x0 on inode 1074266723, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266723
would have cleared inode 1074266723
bad magic number 0xfeed on inode 1074266724, would reset magic number
bad version number 0x0 on inode 1074266724, would reset version number
bad inode format in inode 1074266724
would have cleared inode 1074266724
bad magic number 0x0 on inode 1074266725, would reset magic number
bad version number 0x0 on inode 1074266725, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266725
would have cleared inode 1074266725
bad magic number 0xfeed on inode 1074266726, would reset magic number
bad version number 0x0 on inode 1074266726, would reset version number
bad inode format in inode 1074266726
would have cleared inode 1074266726
bad magic number 0x0 on inode 1074266727, would reset magic number
bad version number 0x0 on inode 1074266727, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266727
would have cleared inode 1074266727
bad magic number 0xfeed on inode 1074266728, would reset magic number
bad version number 0x0 on inode 1074266728, would reset version number
bad inode format in inode 1074266728
would have cleared inode 1074266728
bad magic number 0x0 on inode 1074266729, would reset magic number
bad version number 0x0 on inode 1074266729, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266729
would have cleared inode 1074266729
bad magic number 0xfeed on inode 1074266730, would reset magic number
bad version number 0x0 on inode 1074266730, would reset version number
bad inode format in inode 1074266730
would have cleared inode 1074266730
bad magic number 0x0 on inode 1074266731, would reset magic number
bad version number 0x0 on inode 1074266731, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266731
would have cleared inode 1074266731
bad magic number 0xfeed on inode 1074266732, would reset magic number
bad version number 0x0 on inode 1074266732, would reset version number
bad inode format in inode 1074266732
would have cleared inode 1074266732
bad magic number 0x0 on inode 1074266733, would reset magic number
bad version number 0x0 on inode 1074266733, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266733
would have cleared inode 1074266733
bad magic number 0xfeed on inode 1074266734, would reset magic number
bad version number 0x0 on inode 1074266734, would reset version number
bad inode format in inode 1074266734
would have cleared inode 1074266734
bad magic number 0x0 on inode 1074266735, would reset magic number
bad version number 0x0 on inode 1074266735, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266735
would have cleared inode 1074266735
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - 16:12:07: process known inodes and inode discovery - 88832 of 88832 inodes done
        - process newly discovered inodes...
        - 16:12:07: process newly discovered inodes - 32 of 16 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 16:12:07: setting up duplicate extent list - 16 of 16 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry "sony_vndr" at block 0 offset 200 in directory inode 134218249 references non-existent inode 1074266626
	would clear inode number in entry at offset 200...
entry "nfs-premount" at block 0 offset 224 in directory inode 527 references non-existent inode 1074266640
	would clear inode number in entry at offset 224...
        - agno = 2
entry "beagle" at block 0 offset 272 in directory inode 268435968 references non-existent inode 1074266634
	would clear inode number in entry at offset 272...
entry "freeradius" at block 0 offset 960 in directory inode 268435968 references non-existent inode 1074266637
	would clear inode number in entry at offset 960...
entry "libpaper.d" at block 0 offset 1440 in directory inode 268435968 references non-existent inode 1074266641
	would clear inode number in entry at offset 1440...
entry "readahead" at block 0 offset 2632 in directory inode 268435968 references non-existent inode 1074266645
	would clear inode number in entry at offset 2632...
entry "w3m" at block 1 offset 1864 in directory inode 268435968 references non-existent inode 1074266651
	would clear inode number in entry at offset 1864...
entry "keycodes" at block 0 offset 144 in directory inode 268435970 references non-existent inode 1074266625
	would clear inode number in entry at offset 144...
entry "bash_completion.d" at block 0 offset 344 in directory inode 268436146 references non-existent inode 1074266675
	would clear inode number in entry at offset 344...
entry "cron.hourly" at block 0 offset 696 in directory inode 268436146 references free inode 1074266706
	would clear inode number in entry at offset 696...
        - agno = 3
        - agno = 4
entry "cursors" at block 0 offset 176 in directory inode 536871424 references non-existent inode 1074266624
	would clear inode number in entry at offset 176...
        - agno = 5
entry "mods-enabled" at block 0 offset 104 in directory inode 671089155 references non-existent inode 1074266627
	would clear inode number in entry at offset 104...
entry "ipv6-down.d" at block 0 offset 96 in directory inode 671089196 references non-existent inode 1074266644
	would clear inode number in entry at offset 96...
        - agno = 6
entry "dhclient-exit-hooks.d" in shortform directory 805306886 references non-existent inode 1074266636
would have junked entry "dhclient-exit-hooks.d" in directory inode 805306886
entry "2.0" in shortform directory 805306892 references non-existent inode 1074266642
would have junked entry "2.0" in directory inode 805306892
entry "mods-available" at block 0 offset 72 in directory inode 805306942 references non-existent inode 1074266673
	would clear inode number in entry at offset 72...
entry "conf.d" in shortform directory 805306973 references free inode 1074266718
would have junked entry "conf.d" in directory inode 805306973
        - agno = 7
entry "interfaces" at block 0 offset 48 in directory inode 939524614 references non-existent inode 1074266635
	would clear inode number in entry at offset 48...
entry "filter" in shortform directory 939524617 references non-existent inode 1074266638
would have junked entry "filter" in directory inode 939524617
entry "information" in shortform directory 939524618 references non-existent inode 1074266639
would have junked entry "information" in directory inode 939524618
entry "CPAN" in shortform directory 939524622 references non-existent inode 1074266643
would have junked entry "CPAN" in directory inode 939524622
entry "events" in shortform directory 939524694 references non-existent inode 1074266650
would have junked entry "events" in directory inode 939524694
entry "Xresources" at block 0 offset 104 in directory inode 939524700 references non-existent inode 1074266667
	would clear inode number in entry at offset 104...
entry "xinit" at block 0 offset 240 in directory inode 939524700 references non-existent inode 1074266668
	would clear inode number in entry at offset 240...
entry "config" at block 0 offset 48 in directory inode 939525159 references free inode 1074266709
	would clear inode number in entry at offset 48...
entry "site-start.d" in shortform directory 939525160 references free inode 1074266710
would have junked entry "site-start.d" in directory inode 939525160
        - agno = 8
bad magic number 0xfeed on inode 1074266688, would reset magic number
bad version number 0x0 on inode 1074266688, would reset version number
bad inode format in inode 1074266688
would have cleared inode 1074266688
bad magic number 0x0 on inode 1074266689, would reset magic number
bad version number 0x0 on inode 1074266689, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266689
would have cleared inode 1074266689
bad magic number 0xfeed on inode 1074266690, would reset magic number
bad version number 0x0 on inode 1074266690, would reset version number
bad inode format in inode 1074266690
would have cleared inode 1074266690
bad magic number 0x0 on inode 1074266691, would reset magic number
bad version number 0x0 on inode 1074266691, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266691
would have cleared inode 1074266691
bad magic number 0xfeed on inode 1074266692, would reset magic number
bad version number 0x0 on inode 1074266692, would reset version number
bad inode format in inode 1074266692
would have cleared inode 1074266692
bad magic number 0x0 on inode 1074266693, would reset magic number
bad version number 0x0 on inode 1074266693, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266693
would have cleared inode 1074266693
bad magic number 0xfeed on inode 1074266694, would reset magic number
bad version number 0x0 on inode 1074266694, would reset version number
bad inode format in inode 1074266694
would have cleared inode 1074266694
bad magic number 0x0 on inode 1074266695, would reset magic number
bad version number 0x0 on inode 1074266695, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266695
would have cleared inode 1074266695
bad magic number 0xfeed on inode 1074266696, would reset magic number
bad version number 0x0 on inode 1074266696, would reset version number
bad inode format in inode 1074266696
would have cleared inode 1074266696
bad magic number 0x0 on inode 1074266697, would reset magic number
bad version number 0x0 on inode 1074266697, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266697
would have cleared inode 1074266697
bad magic number 0xfeed on inode 1074266698, would reset magic number
bad version number 0x0 on inode 1074266698, would reset version number
bad inode format in inode 1074266698
would have cleared inode 1074266698
bad magic number 0x0 on inode 1074266699, would reset magic number
bad version number 0x0 on inode 1074266699, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266699
would have cleared inode 1074266699
bad magic number 0xfeed on inode 1074266700, would reset magic number
bad version number 0x0 on inode 1074266700, would reset version number
bad inode format in inode 1074266700
would have cleared inode 1074266700
bad magic number 0x0 on inode 1074266701, would reset magic number
bad version number 0x0 on inode 1074266701, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266701
would have cleared inode 1074266701
bad magic number 0xfeed on inode 1074266702, would reset magic number
bad version number 0x0 on inode 1074266702, would reset version number
bad inode format in inode 1074266702
would have cleared inode 1074266702
bad magic number 0x0 on inode 1074266703, would reset magic number
bad version number 0x0 on inode 1074266703, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266703
would have cleared inode 1074266703
bad magic number 0xfeed on inode 1074266704, would reset magic number
bad version number 0x0 on inode 1074266704, would reset version number
bad inode format in inode 1074266704
would have cleared inode 1074266704
bad magic number 0x0 on inode 1074266705, would reset magic number
bad version number 0x0 on inode 1074266705, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266705
would have cleared inode 1074266705
bad magic number 0xfeed on inode 1074266706, would reset magic number
bad version number 0x0 on inode 1074266706, would reset version number
bad inode format in inode 1074266706
would have cleared inode 1074266706
bad magic number 0x0 on inode 1074266707, would reset magic number
bad version number 0x0 on inode 1074266707, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266707
would have cleared inode 1074266707
bad magic number 0xfeed on inode 1074266708, would reset magic number
bad version number 0x0 on inode 1074266708, would reset version number
bad inode format in inode 1074266708
would have cleared inode 1074266708
bad magic number 0x0 on inode 1074266709, would reset magic number
bad version number 0x0 on inode 1074266709, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266709
would have cleared inode 1074266709
bad magic number 0xfeed on inode 1074266710, would reset magic number
bad version number 0x0 on inode 1074266710, would reset version number
bad inode format in inode 1074266710
would have cleared inode 1074266710
bad magic number 0x0 on inode 1074266711, would reset magic number
bad version number 0x0 on inode 1074266711, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266711
would have cleared inode 1074266711
bad magic number 0xfeed on inode 1074266712, would reset magic number
bad version number 0x0 on inode 1074266712, would reset version number
bad inode format in inode 1074266712
would have cleared inode 1074266712
bad magic number 0x0 on inode 1074266713, would reset magic number
bad version number 0x0 on inode 1074266713, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266713
would have cleared inode 1074266713
bad magic number 0xfeed on inode 1074266714, would reset magic number
bad version number 0x0 on inode 1074266714, would reset version number
bad inode format in inode 1074266714
would have cleared inode 1074266714
bad magic number 0x0 on inode 1074266715, would reset magic number
bad version number 0x0 on inode 1074266715, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266715
would have cleared inode 1074266715
bad magic number 0xfeed on inode 1074266716, would reset magic number
bad version number 0x0 on inode 1074266716, would reset version number
bad inode format in inode 1074266716
would have cleared inode 1074266716
bad magic number 0x0 on inode 1074266717, would reset magic number
bad version number 0x0 on inode 1074266717, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266717
would have cleared inode 1074266717
bad magic number 0xfeed on inode 1074266718, would reset magic number
bad version number 0x0 on inode 1074266718, would reset version number
bad inode format in inode 1074266718
would have cleared inode 1074266718
bad magic number 0x0 on inode 1074266719, would reset magic number
bad version number 0x0 on inode 1074266719, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266719
would have cleared inode 1074266719
bad magic number 0xfeed on inode 1074266720, would reset magic number
bad version number 0x0 on inode 1074266720, would reset version number
bad inode format in inode 1074266720
would have cleared inode 1074266720
bad magic number 0x0 on inode 1074266721, would reset magic number
bad version number 0x0 on inode 1074266721, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266721
would have cleared inode 1074266721
bad magic number 0xfeed on inode 1074266722, would reset magic number
bad version number 0x0 on inode 1074266722, would reset version number
bad inode format in inode 1074266722
would have cleared inode 1074266722
bad magic number 0x0 on inode 1074266723, would reset magic number
bad version number 0x0 on inode 1074266723, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266723
would have cleared inode 1074266723
bad magic number 0xfeed on inode 1074266724, would reset magic number
bad version number 0x0 on inode 1074266724, would reset version number
bad inode format in inode 1074266724
would have cleared inode 1074266724
bad magic number 0x0 on inode 1074266725, would reset magic number
bad version number 0x0 on inode 1074266725, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266725
would have cleared inode 1074266725
bad magic number 0xfeed on inode 1074266726, would reset magic number
bad version number 0x0 on inode 1074266726, would reset version number
bad inode format in inode 1074266726
would have cleared inode 1074266726
bad magic number 0x0 on inode 1074266727, would reset magic number
bad version number 0x0 on inode 1074266727, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266727
would have cleared inode 1074266727
bad magic number 0xfeed on inode 1074266728, would reset magic number
bad version number 0x0 on inode 1074266728, would reset version number
bad inode format in inode 1074266728
would have cleared inode 1074266728
bad magic number 0x0 on inode 1074266729, would reset magic number
bad version number 0x0 on inode 1074266729, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266729
would have cleared inode 1074266729
bad magic number 0xfeed on inode 1074266730, would reset magic number
bad version number 0x0 on inode 1074266730, would reset version number
bad inode format in inode 1074266730
would have cleared inode 1074266730
bad magic number 0x0 on inode 1074266731, would reset magic number
bad version number 0x0 on inode 1074266731, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266731
would have cleared inode 1074266731
bad magic number 0xfeed on inode 1074266732, would reset magic number
bad version number 0x0 on inode 1074266732, would reset version number
bad inode format in inode 1074266732
would have cleared inode 1074266732
bad magic number 0x0 on inode 1074266733, would reset magic number
bad version number 0x0 on inode 1074266733, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266733
would have cleared inode 1074266733
bad magic number 0xfeed on inode 1074266734, would reset magic number
bad version number 0x0 on inode 1074266734, would reset version number
bad inode format in inode 1074266734
would have cleared inode 1074266734
bad magic number 0x0 on inode 1074266735, would reset magic number
bad version number 0x0 on inode 1074266735, would reset version number
bad (negative) size -7746721568139339722 on inode 1074266735
would have cleared inode 1074266735
        - agno = 9
entry ".." at block 0 offset 32 in directory inode 1207960072 references non-existent inode 1074266637
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 1207960114 references non-existent inode 1074266668
	would clear inode number in entry at offset 32...
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - 16:12:07: check for inodes claiming duplicate blocks - 88768 of 88832 inodes done
Phase 6 - check inode connectivity...
        - traversing filesystem starting at / ... 
entry "nfs-premount" in directory inode 527 points to non-existent inode, would junk entry
entry "sony_vndr" in directory inode 134218249 points to non-existent inode, would junk entry
entry "beagle" in directory inode 268435968 points to non-existent inode, would junk entry
entry "freeradius" in directory inode 268435968 points to non-existent inode, would junk entry
entry "libpaper.d" in directory inode 268435968 points to non-existent inode, would junk entry
entry "readahead" in directory inode 268435968 points to non-existent inode, would junk entry
entry "w3m" in directory inode 268435968 points to non-existent inode, would junk entry
entry "keycodes" in directory inode 268435970 points to non-existent inode, would junk entry
entry "bash_completion.d" in directory inode 268436146 points to non-existent inode, would junk entry
entry "cron.hourly" in directory inode 268436146 points to free inode 1074266706, would junk entry
entry "cursors" in directory inode 536871424 points to non-existent inode, would junk entry
entry "mods-enabled" in directory inode 671089155 points to non-existent inode, would junk entry
entry "ipv6-down.d" in directory inode 671089196 points to non-existent inode, would junk entry
entry "dhclient-exit-hooks.d" in shortform directory 805306886 references non-existent inode 1074266636
would junk entry
entry "dhclient-exit-hooks.d" in shortform directory 805306886 references non-existent inode 1074266636
would junk entry
entry "2.0" in shortform directory 805306892 references non-existent inode 1074266642
would junk entry
entry "2.0" in shortform directory 805306892 references non-existent inode 1074266642
would junk entry
entry "2.0" in shortform directory 805306892 references non-existent inode 1074266642
would junk entry
entry "mods-available" in directory inode 805306942 points to non-existent inode, would junk entry
entry "conf.d" in shortform directory inode 805306973 points to free inode 1074266718
would junk entry "conf.d"
entry "interfaces" in directory inode 939524614 points to non-existent inode, would junk entry
entry "filter" in shortform directory 939524617 references non-existent inode 1074266638
would junk entry
entry "filter" in shortform directory 939524617 references non-existent inode 1074266638
would junk entry
entry "filter" in shortform directory 939524617 references non-existent inode 1074266638
would junk entry
entry "information" in shortform directory 939524618 references non-existent inode 1074266639
would junk entry
entry "information" in shortform directory 939524618 references non-existent inode 1074266639
would junk entry
entry "information" in shortform directory 939524618 references non-existent inode 1074266639
would junk entry
entry "CPAN" in shortform directory 939524622 references non-existent inode 1074266643
would junk entry
entry "CPAN" in shortform directory 939524622 references non-existent inode 1074266643
would junk entry
entry "CPAN" in shortform directory 939524622 references non-existent inode 1074266643
would junk entry
entry "events" in shortform directory 939524694 references non-existent inode 1074266650
would junk entry
entry "Xresources" in directory inode 939524700 points to non-existent inode, would junk entry
entry "xinit" in directory inode 939524700 points to non-existent inode, would junk entry
entry "config" in directory inode 939525159 points to free inode 1074266709, would junk entry
entry "site-start.d" in shortform directory inode 939525160 points to free inode 1074266710
would junk entry "site-start.d"
        - 16:12:19: traversing filesystem - 16 of 16 allocation groups done
        - traversal finished ... 
        - traversing all unattached subtrees ... 
        - traversals finished ... 
        - moving disconnected inodes to lost+found ... 
disconnected inode 805306949, would move to lost+found
disconnected inode 805306958, would move to lost+found
disconnected inode 805306959, would move to lost+found
disconnected inode 939525150, would move to lost+found
disconnected inode 939525151, would move to lost+found
disconnected inode 1074266736, would move to lost+found
disconnected inode 1074266737, would move to lost+found
disconnected inode 1074266738, would move to lost+found
disconnected inode 1074266740, would move to lost+found
disconnected inode 1074266742, would move to lost+found
disconnected inode 1074266743, would move to lost+found
disconnected inode 1074266744, would move to lost+found
disconnected inode 1074266747, would move to lost+found
disconnected inode 1074266748, would move to lost+found
disconnected inode 1074266749, would move to lost+found
disconnected inode 1074266750, would move to lost+found
disconnected inode 1074266751, would move to lost+found
disconnected inode 1074267136, would move to lost+found
disconnected inode 1074267137, would move to lost+found
disconnected inode 1074267138, would move to lost+found
disconnected inode 1074267139, would move to lost+found
disconnected inode 1074267140, would move to lost+found
disconnected inode 1074267141, would move to lost+found
disconnected inode 1074267142, would move to lost+found
disconnected inode 1074267143, would move to lost+found
disconnected inode 1074267144, would move to lost+found
disconnected inode 1074267145, would move to lost+found
disconnected inode 1074267146, would move to lost+found
disconnected inode 1074267147, would move to lost+found
disconnected inode 1074267148, would move to lost+found
disconnected inode 1074267149, would move to lost+found
disconnected inode 1074267150, would move to lost+found
disconnected inode 1074267151, would move to lost+found
disconnected inode 1074267152, would move to lost+found
disconnected inode 1074267153, would move to lost+found
disconnected inode 1074267154, would move to lost+found
disconnected inode 1074267155, would move to lost+found
disconnected inode 1074267156, would move to lost+found
disconnected inode 1074267157, would move to lost+found
disconnected inode 1074267158, would move to lost+found
disconnected inode 1074267159, would move to lost+found
disconnected inode 1074267160, would move to lost+found
disconnected inode 1074267161, would move to lost+found
disconnected inode 1074267162, would move to lost+found
disconnected inode 1074267163, would move to lost+found
disconnected inode 1074267164, would move to lost+found
disconnected inode 1074267165, would move to lost+found
disconnected inode 1074267166, would move to lost+found
disconnected inode 1074267167, would move to lost+found
disconnected inode 1074267168, would move to lost+found
disconnected inode 1074267169, would move to lost+found
disconnected inode 1074267171, would move to lost+found
disconnected inode 1074267172, would move to lost+found
disconnected inode 1074267173, would move to lost+found
disconnected inode 1074267174, would move to lost+found
disconnected inode 1074267176, would move to lost+found
disconnected inode 1074267177, would move to lost+found
disconnected inode 1074267178, would move to lost+found
disconnected inode 1074267179, would move to lost+found
disconnected inode 1074267180, would move to lost+found
disconnected inode 1074267181, would move to lost+found
disconnected inode 1074267182, would move to lost+found
disconnected inode 1074267183, would move to lost+found
disconnected inode 1074267184, would move to lost+found
disconnected inode 1074267185, would move to lost+found
disconnected inode 1074267186, would move to lost+found
disconnected inode 1074267187, would move to lost+found
disconnected inode 1074267188, would move to lost+found
disconnected inode 1074267189, would move to lost+found
disconnected inode 1074267190, would move to lost+found
disconnected inode 1074267191, would move to lost+found
disconnected inode 1074267192, would move to lost+found
disconnected inode 1074267193, would move to lost+found
disconnected inode 1074267194, would move to lost+found
disconnected inode 1074267195, would move to lost+found
disconnected inode 1074267196, would move to lost+found
disconnected inode 1074267197, would move to lost+found
disconnected inode 1074267198, would move to lost+found
disconnected inode 1074267199, would move to lost+found
disconnected inode 1074267200, would move to lost+found
disconnected inode 1074267201, would move to lost+found
disconnected inode 1074267202, would move to lost+found
disconnected inode 1074267203, would move to lost+found
disconnected inode 1074267204, would move to lost+found
disconnected inode 1074267205, would move to lost+found
disconnected inode 1074267206, would move to lost+found
disconnected inode 1074267207, would move to lost+found
disconnected inode 1074267208, would move to lost+found
disconnected inode 1074267209, would move to lost+found
disconnected inode 1074267210, would move to lost+found
disconnected inode 1074267211, would move to lost+found
disconnected inode 1074267212, would move to lost+found
disconnected inode 1074267213, would move to lost+found
disconnected inode 1074267214, would move to lost+found
disconnected inode 1074267215, would move to lost+found
disconnected inode 1074267216, would move to lost+found
disconnected inode 1074267217, would move to lost+found
disconnected inode 1074267218, would move to lost+found
disconnected inode 1074267219, would move to lost+found
disconnected inode 1074267220, would move to lost+found
disconnected inode 1074267221, would move to lost+found
disconnected inode 1074267222, would move to lost+found
disconnected inode 1074267223, would move to lost+found
disconnected inode 1074267224, would move to lost+found
disconnected inode 1074267225, would move to lost+found
disconnected inode 1074267226, would move to lost+found
disconnected inode 1074267227, would move to lost+found
disconnected inode 1074267228, would move to lost+found
disconnected inode 1074267229, would move to lost+found
disconnected inode 1074267230, would move to lost+found
disconnected inode 1074267231, would move to lost+found
disconnected inode 1074267232, would move to lost+found
disconnected inode 1074267233, would move to lost+found
disconnected inode 1074267234, would move to lost+found
disconnected inode 1074267235, would move to lost+found
disconnected inode 1074267236, would move to lost+found
disconnected inode 1074267237, would move to lost+found
disconnected inode 1074267238, would move to lost+found
disconnected inode 1074267239, would move to lost+found
disconnected inode 1074267240, would move to lost+found
disconnected inode 1074267241, would move to lost+found
disconnected inode 1074267242, would move to lost+found
disconnected inode 1074267243, would move to lost+found
disconnected inode 1074267244, would move to lost+found
disconnected inode 1074267245, would move to lost+found
disconnected inode 1074267246, would move to lost+found
disconnected inode 1074267247, would move to lost+found
disconnected inode 1074267248, would move to lost+found
disconnected inode 1074267249, would move to lost+found
disconnected inode 1074267250, would move to lost+found
disconnected inode 1074267251, would move to lost+found
disconnected inode 1074267252, would move to lost+found
disconnected inode 1074267253, would move to lost+found
disconnected inode 1074267254, would move to lost+found
disconnected inode 1074267255, would move to lost+found
disconnected inode 1074267256, would move to lost+found
disconnected inode 1074267257, would move to lost+found
disconnected inode 1074267258, would move to lost+found
disconnected inode 1074267259, would move to lost+found
disconnected inode 1074267260, would move to lost+found
disconnected inode 1074267261, would move to lost+found
disconnected inode 1074267262, would move to lost+found
disconnected inode 1074267263, would move to lost+found
disconnected inode 1074267264, would move to lost+found
disconnected inode 1074267265, would move to lost+found
disconnected inode 1074267266, would move to lost+found
disconnected inode 1074267267, would move to lost+found
disconnected inode 1074267268, would move to lost+found
disconnected inode 1074267269, would move to lost+found
disconnected inode 1074267270, would move to lost+found
disconnected inode 1074267271, would move to lost+found
disconnected inode 1074267272, would move to lost+found
disconnected inode 1074267277, would move to lost+found
disconnected inode 1074267278, would move to lost+found
disconnected inode 1074267801, would move to lost+found
disconnected inode 1074267802, would move to lost+found
disconnected inode 1074267803, would move to lost+found
disconnected inode 1074267804, would move to lost+found
disconnected inode 1074267806, would move to lost+found
disconnected inode 1074267807, would move to lost+found
disconnected inode 1074267808, would move to lost+found
disconnected inode 1074267809, would move to lost+found
disconnected inode 1074267810, would move to lost+found
disconnected inode 1074267811, would move to lost+found
disconnected inode 1074267812, would move to lost+found
disconnected dir inode 1207960065, would move to lost+found
disconnected dir inode 1207960072, would move to lost+found
disconnected dir inode 1207960074, would move to lost+found
disconnected dir inode 1207960078, would move to lost+found
disconnected dir inode 1207960114, would move to lost+found
disconnected dir inode 1342177793, would move to lost+found
disconnected dir inode 1342177805, would move to lost+found
disconnected dir inode 1342177809, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 527 nlinks from 11 to 10
would have reset inode 134218249 nlinks from 11 to 10
would have reset inode 268435968 nlinks from 125 to 120
would have reset inode 268435970 nlinks from 10 to 9
would have reset inode 268436146 nlinks from 151 to 149
would have reset inode 536871424 nlinks from 9 to 8
would have reset inode 671089155 nlinks from 8 to 7
would have reset inode 671089196 nlinks from 8 to 7
would have reset inode 805306886 nlinks from 4 to 3
would have reset inode 805306892 nlinks from 4 to 3
would have reset inode 805306942 nlinks from 7 to 6
would have reset inode 805306973 nlinks from 4 to 3
would have reset inode 939524614 nlinks from 5 to 4
would have reset inode 939524617 nlinks from 3 to 2
would have reset inode 939524618 nlinks from 5 to 2
would have reset inode 939524622 nlinks from 5 to 2
would have reset inode 939524694 nlinks from 3 to 2
would have reset inode 939524700 nlinks from 11 to 9
would have reset inode 939525159 nlinks from 4 to 3
would have reset inode 939525160 nlinks from 3 to 2
        - 16:12:25: verify link counts - 88768 of 88832 inodes done
No modify flag set, skipping filesystem flush and exiting.

--------------050705000404000303010802--
