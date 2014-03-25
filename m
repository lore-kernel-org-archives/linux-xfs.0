Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A9EBA7F4E
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 04:40:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89DDB304059
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 02:40:12 -0700 (PDT)
Received: from smtp2.ispfabriek.nl (smtp2.ispfabriek.nl [37.251.0.169]) by
	cuda.sgi.com with ESMTP id sgvuqQIqCokPm2pP for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 02:40:10 -0700 (PDT)
Message-ID: <53314EED.2000004@1st-setup.nl>
Date: Tue, 25 Mar 2014 10:39:57 +0100
From: "Michel Verbraak(1st-Setup)" <info@1st-setup.nl>
MIME-Version: 1.0
Subject: Re: xfs blocks (blocked for more than 120 seconds)
References: <532FF9DD.5080700@1st-setup.nl>
	<20140324173636.GD18572@destitution>
In-Reply-To: <20140324173636.GD18572@destitution>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4766323912676676861=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============4766323912676676861==
Content-Type: multipart/alternative;
 boundary="------------000709050504020909030804"

This is a multi-part message in MIME format.
--------------000709050504020909030804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

op 24-03-14 18:36, Dave Chinner schreef:
> On Mon, Mar 24, 2014 at 10:24:45AM +0100, Michel Verbraak(1st-Setup) wrote:
>> Hi,
>>
>> We have a problem with one of our systems which is using XFS but we are
>> unable to find the problem. Recently we had two moments, Tuesday 4th of
>> March and Friday the 21st of March, where we had to reboot the system to
>> get it up and running again.
>>
>> What happens:
>> - The programs handling files on the XFS disc stop working when
>> creating, deleting or writing files. They do not error they are just
>> waiting on the command to complete.
>> - One of our programs, a java application, goes into very high cpu usage
>> (50%) which normally is at 1%. This could be something in our java
>> application but it happens at the moment handling files gets stuck.
>> - A nice restart of the programs does not succeed as wel a kill -9 does
>> not work.
>> - Trying to reboot the servers in a normal fashion does not work. As it
>> is a virtual machine we have to do a shutdown (unplug power) and start
>> it up again to get it up and running.
> ......
>> Following details I have for you:
>>
>> System OS: Ubuntu 12.04 LTS
>> Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC 2013
>> x86_64 x86_64 x86_64 GNU/Linux
>> Server: Virtual machine in a VMWare setup.
>> Disc: 300GB direct attached LUN
>>
>> We have an exact clone of this system for our acceptance environment. In
>> this environment we are unable to reproduce this problem/situation.
>>
>> Differences between the two days is that our services on 2014-03-21 were
>> quit busy with a lot of file changes on the xfs disc and on 2014-03-04
>> the system was very quiet on the moment the kernel traces appear and the
>> services get stuck.
>>
>> Any help is appreciated.
>>
>> Regards Michel Verbraak.
>>
>> Following we see in the syslog on both moments (2014-03-04 and 2014-03-21):
>>
> ....
>> Mar 21 06:32:20 ealxs00169 kernel: [1412280.930543] flush-8:16      D
>> 0000000000000000     0 13864      2 0x00000000
>> [<ffffffff8165b34f>] schedule+0x3f/0x60
>> [<ffffffff8165b3ff>] io_schedule+0x8f/0xd0
>> [<ffffffff8111836e>] sleep_on_page+0xe/0x20
>> [<ffffffff8165baca>] __wait_on_bit_lock+0x5a/0xc0
>> [<ffffffff81118357>] __lock_page+0x67/0x70
>> [<ffffffff81122bd4>] write_cache_pages+0x3d4/0x460
>> [<ffffffff81122caa>] generic_writepages+0x4a/0x70
>> [<ffffffffa007980d>] xfs_vm_writepages+0x4d/0x60 [xfs]
>> [<ffffffff81123b71>] do_writepages+0x21/0x40
>> [<ffffffff811a2990>] writeback_single_inode+0x180/0x430
>> [<ffffffff811a3056>] writeback_sb_inodes+0x1b6/0x270
>> [<ffffffff811a31ae>] __writeback_inodes_wb+0x9e/0xd0
>> [<ffffffff811a345b>] wb_writeback+0x27b/0x330
>> [<ffffffff811a35af>] wb_check_old_data_flush+0x9f/0xb0
>> [<ffffffff811a4481>] wb_do_writeback+0x151/0x1d0
>> [<ffffffff811a4583>] bdi_writeback_thread+0x83/0x2a0
>> [<ffffffff8108b27c>] kthread+0x8c/0xa0
> Writeback is blocked on a locked page, and is waiting for IO
> completion.
We currently have the following options in fstab for the filesystem:
defaults,noatime,inode64,barrier=no

Now I read everywhere to turn of barrier you should specify "nobarrier".
Is our way of disabling wrong?

The disc used has "write cache" disabled:
[    2.875792] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    2.876376] sd 3:0:0:0: [sdb] 629145600 512-byte logical blocks: (322
GB/300 GiB)
[    2.876879] sd 3:0:0:0: [sdb] Write Protect is off
[    2.877050] sd 3:0:0:0: [sdb] Mode Sense: 87 00 00 08
[    2.877890] sd 3:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    2.885634]  sdb: unknown partition table
...
[    5.132308] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    5.155268] SGI XFS Quota Management subsystem
[    5.159345] XFS (sdb): Mounting Filesystem
..


Following is output of xfs_info on sdb:
meta-data=/dev/sdb               isize=256    agcount=4, agsize=19660800
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=78643200, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=38400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

>
>
>> Mar 21 06:34:20 ealxs00169 kernel: [1412400.891181] archiver.pl     D
>> [<ffffffff8165b34f>] schedule+0x3f/0x60
>> [<ffffffff8165b995>] schedule_timeout+0x2a5/0x320
>> [<ffffffff8165c5f0>] __down_common+0xa5/0xf5
>> [<ffffffff8165c6b3>] __down+0x1d/0x1f
.....
>> Cheers,
>>
>> Dave.
Michel.

--------------000709050504020909030804
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#666666" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">op 24-03-14 18:36, Dave Chinner
      schreef:<br>
    </div>
    <blockquote cite="mid:20140324173636.GD18572@destitution"
      type="cite">
      <pre wrap="">On Mon, Mar 24, 2014 at 10:24:45AM +0100, Michel Verbraak(1st-Setup) wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Hi,

We have a problem with one of our systems which is using XFS but we are
unable to find the problem. Recently we had two moments, Tuesday 4th of
March and Friday the 21st of March, where we had to reboot the system to
get it up and running again.

What happens:
- The programs handling files on the XFS disc stop working when
creating, deleting or writing files. They do not error they are just
waiting on the command to complete.
- One of our programs, a java application, goes into very high cpu usage
(50%) which normally is at 1%. This could be something in our java
application but it happens at the moment handling files gets stuck.
- A nice restart of the programs does not succeed as wel a kill -9 does
not work.
- Trying to reboot the servers in a normal fashion does not work. As it
is a virtual machine we have to do a shutdown (unplug power) and start
it up again to get it up and running.
</pre>
      </blockquote>
      <pre wrap="">......
</pre>
      <blockquote type="cite">
        <pre wrap="">
Following details I have for you:

System OS: Ubuntu 12.04 LTS
Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux
Server: Virtual machine in a VMWare setup.
Disc: 300GB direct attached LUN

We have an exact clone of this system for our acceptance environment. In
this environment we are unable to reproduce this problem/situation.

Differences between the two days is that our services on 2014-03-21 were
quit busy with a lot of file changes on the xfs disc and on 2014-03-04
the system was very quiet on the moment the kernel traces appear and the
services get stuck.

Any help is appreciated.

Regards Michel Verbraak.

Following we see in the syslog on both moments (2014-03-04 and 2014-03-21):

</pre>
      </blockquote>
      <pre wrap="">....
</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:32:20 ealxs00169 kernel: [1412280.930543] flush-8:16      D
0000000000000000     0 13864      2 0x00000000
[&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60
[&lt;ffffffff8165b3ff&gt;] io_schedule+0x8f/0xd0
[&lt;ffffffff8111836e&gt;] sleep_on_page+0xe/0x20
[&lt;ffffffff8165baca&gt;] __wait_on_bit_lock+0x5a/0xc0
[&lt;ffffffff81118357&gt;] __lock_page+0x67/0x70
[&lt;ffffffff81122bd4&gt;] write_cache_pages+0x3d4/0x460
[&lt;ffffffff81122caa&gt;] generic_writepages+0x4a/0x70
[&lt;ffffffffa007980d&gt;] xfs_vm_writepages+0x4d/0x60 [xfs]
[&lt;ffffffff81123b71&gt;] do_writepages+0x21/0x40
[&lt;ffffffff811a2990&gt;] writeback_single_inode+0x180/0x430
[&lt;ffffffff811a3056&gt;] writeback_sb_inodes+0x1b6/0x270
[&lt;ffffffff811a31ae&gt;] __writeback_inodes_wb+0x9e/0xd0
[&lt;ffffffff811a345b&gt;] wb_writeback+0x27b/0x330
[&lt;ffffffff811a35af&gt;] wb_check_old_data_flush+0x9f/0xb0
[&lt;ffffffff811a4481&gt;] wb_do_writeback+0x151/0x1d0
[&lt;ffffffff811a4583&gt;] bdi_writeback_thread+0x83/0x2a0
[&lt;ffffffff8108b27c&gt;] kthread+0x8c/0xa0
</pre>
      </blockquote>
      <pre wrap="">
Writeback is blocked on a locked page, and is waiting for IO
completion.</pre>
    </blockquote>
    We currently have the following options in fstab for the filesystem:
    defaults,noatime,inode64,barrier=no<br>
    <br>
    Now I read everywhere to turn of barrier you should specify
    "nobarrier". Is our way of disabling wrong?<br>
    <br>
    The disc used has "write cache" disabled:<br>
    [&nbsp;&nbsp;&nbsp; 2.875792] sd 3:0:0:0: Attached scsi generic sg2 type 0<br>
    [&nbsp;&nbsp;&nbsp; 2.876376] sd 3:0:0:0: [sdb] 629145600 512-byte logical blocks:
    (322 GB/300 GiB)<br>
    [&nbsp;&nbsp;&nbsp; 2.876879] sd 3:0:0:0: [sdb] Write Protect is off<br>
    [&nbsp;&nbsp;&nbsp; 2.877050] sd 3:0:0:0: [sdb] Mode Sense: 87 00 00 08<br>
    [&nbsp;&nbsp;&nbsp; 2.877890] sd 3:0:0:0: [sdb] Write cache: disabled, read cache:
    enabled, doesn't support DPO or FUA<br>
    [&nbsp;&nbsp;&nbsp; 2.885634]&nbsp; sdb: unknown partition table<br>
    ...<br>
    [&nbsp;&nbsp;&nbsp; 5.132308] SGI XFS with ACLs, security attributes, realtime,
    large block/inode numbers, no debug enabled<br>
    [&nbsp;&nbsp;&nbsp; 5.155268] SGI XFS Quota Management subsystem<br>
    [&nbsp;&nbsp;&nbsp; 5.159345] XFS (sdb): Mounting Filesystem<br>
    ..<br>
    <br>
    <br>
    Following is output of xfs_info on sdb:<br>
    meta-data=/dev/sdb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; isize=256&nbsp;&nbsp;&nbsp; agcount=4,
    agsize=19660800 blks<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; attr=2<br>
    data&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=78643200,
    imaxpct=25<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=0 blks<br>
    naming&nbsp;&nbsp; =version 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; ascii-ci=0<br>
    log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =internal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=38400,
    version=2<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; sunit=0 blks,
    lazy-count=1<br>
    realtime =none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=4096&nbsp;&nbsp; blocks=0, rtextents=0<br>
    <br>
    <blockquote cite="mid:20140324173636.GD18572@destitution"
      type="cite">
      <pre wrap="">


</pre>
      <blockquote type="cite">
        <pre wrap="">Mar 21 06:34:20 ealxs00169 kernel: [1412400.891181] archiver.pl     D
[&lt;ffffffff8165b34f&gt;] schedule+0x3f/0x60
[&lt;ffffffff8165b995&gt;] schedule_timeout+0x2a5/0x320
[&lt;ffffffff8165c5f0&gt;] __down_common+0xa5/0xf5
[&lt;ffffffff8165c6b3&gt;] __down+0x1d/0x1f
</pre>
      </blockquote>
    </blockquote>
    .....<br>
    <blockquote cite="mid:20140324173636.GD18572@destitution"
      type="cite">
      <blockquote type="cite">
        <pre wrap="">
Cheers,

Dave.
</pre>
      </blockquote>
    </blockquote>
    Michel.<br>
  </body>
</html>

--------------000709050504020909030804--


--===============4766323912676676861==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4766323912676676861==--
