Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A8AA57F74
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 03:29:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A365B30406A
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 01:29:41 -0700 (PDT)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
	[209.85.213.178]) by cuda.sgi.com with ESMTP id
	ZDoa37e2mUoHqCuL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 01:29:37 -0700 (PDT)
Received: by mail-ig0-f178.google.com with SMTP id hn18so5187137igb.5
	for <xfs@oss.sgi.com>; Tue, 01 Jul 2014 01:29:37 -0700 (PDT)
From: Alexandru Cardaniuc <cardaniuc@gmail.com>
Subject: Re: corruption of in-memory data detected
References: <CALkk6gqiwyC7HD3QvzUgecVgdr55=zW=bEA-0bqHFR4y28koxA@mail.gmail.com>
	<20140701070230.GG4453@dastard>
Date: Tue, 01 Jul 2014 01:29:35 -0700
In-Reply-To: <20140701070230.GG4453@dastard> (Dave Chinner's message of "Tue,
	1 Jul 2014 17:02:30 +1000")
Message-ID: <87vbrh1nyo.fsf@gmail.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


Dave Chinner <david@fromorbit.com> writes:

> On Mon, Jun 30, 2014 at 11:44:45PM -0700, Alexandru Cardaniuc wrote:
>> Hi All,
 
>> I am having an issue with an XFS filesystem shutting down under high
>> load with very many small files. Basically, I have around 3.5 - 4
>> million files on this filesystem. New files are being written to the
>> FS all the time, until I get to 9-11 mln small files (35k on
>> average).
>> 
>> at some point I get the following in dmesg:
>> 
>> [2870477.695512] Filesystem "sda5": XFS internal error
>> xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c. Caller
>> 0xffffffff8826bb7d [2870477.695558] [2870477.695559] Call Trace:
>> [2870477.695611] [<ffffffff88262c28>]
>> :xfs:xfs_trans_cancel+0x5b/0xfe [2870477.695643]
>> [<ffffffff8826bb7d>] :xfs:xfs_mkdir+0x57c/0x5d7 [2870477.695673]
>> [<ffffffff8822f3f8>] :xfs:xfs_attr_get+0xbf/0xd2 [2870477.695707]
>> [<ffffffff88273326>] :xfs:xfs_vn_mknod+0x1e1/0x3bb [2870477.695726]
>> [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14 [2870477.695736]
>> [<ffffffff802230e6>] __up_read+0x19/0x7f [2870477.695764]
>> [<ffffffff8824f8f4>] :xfs:xfs_iunlock+0x57/0x79 [2870477.695776]
>> [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14 [2870477.695784]
>> [<ffffffff802230e6>] __up_read+0x19/0x7f [2870477.695791]
>> [<ffffffff80209f4c>] __d_lookup+0xb0/0xff [2870477.695803]
>> [<ffffffff8020cd4a>] _atomic_dec_and_lock+0x39/0x57 [2870477.695814]
>> [<ffffffff8022d6db>] mntput_no_expire+0x19/0x89 [2870477.695829]
>> [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14 [2870477.695837]
>> [<ffffffff802230e6>] __up_read+0x19/0x7f [2870477.695861]
>> [<ffffffff8824f8f4>] :xfs:xfs_iunlock+0x57/0x79 [2870477.695887]
>> [<ffffffff882680af>] :xfs:xfs_access+0x3d/0x46 [2870477.695899]
>> [<ffffffff80264929>] _spin_lock_irqsave+0x9/0x14 [2870477.695923]
>> [<ffffffff802df4a3>] vfs_mkdir+0xe3/0x152 [2870477.695933]
>> [<ffffffff802dfa79>] sys_mkdirat+0xa3/0xe4 [2870477.695953]
>> [<ffffffff80260295>] tracesys+0x47/0xb6 [2870477.695963]
>> [<ffffffff802602f9>] tracesys+0xab/0xb6 [2870477.695977]
>> [2870477.695985] xfs_force_shutdown(sda5,0x8) called from line 1139
>> of file fs/xfs/xfs_trans.c. Return address = 0xffffffff88262c46
>> [2870477.696452] Filesystem "sda5": Corruption of in-memory data
>> detected. Shutting down filesystem: sda5 [2870477.696464] Please
>> umount the filesystem, and rectify the problem(s)
>
> You've probably fragmented free space to the point where inodes cannot
> be allocated anymore, and then it's shutdown because it got enospc
> with a dirty inode allocation transaction.

> xfs_db -c "freespc -s" <dev>

> should tell us whether this is the case or not.

This is what I have

#  xfs_db -c "freesp -s" /dev/sda5
   from      to extents  blocks    pct
      1       1     657     657   0.00
      2       3     264     607   0.00
      4       7      29     124   0.00
      8      15      13     143   0.00
     16      31      41     752   0.00
     32      63       8     293   0.00
     64     127      12    1032   0.00
    128     255       8    1565   0.00
    256     511      10    4044   0.00
    512    1023       7    5750   0.00
   1024    2047      10   16061   0.01
   2048    4095       5   16948   0.01
   4096    8191       7   43312   0.02
   8192   16383       9  115578   0.06
  16384   32767       6  159576   0.08
  32768   65535       3  104586   0.05
 262144  524287       1  507710   0.25
4194304 7454720      28 200755934  99.51
total free extents 1118
total free blocks 201734672
average free extent size 180442



>> Using CentOS 5.9 with kernel 2.6.18-348.el5xen
>
> The "enospc with dirty transaction" shutdown bugs have been fixed in
> more recent kernels than RHEL5.

These fixes were not backported to RHEL5 kernels?

>> The problem is reproducible and I don't think it's hardware related.
>> The problem was reproduced on multiple servers of the same type. So,
>> I doubt it's a memory issue or something like that.

> Nope, it's not hardware, it's buggy software that has been fixed in
> the years since 2.6.18....

I would hope these fixes would be backported to RHEL5 (CentOS 5) kernels...

>> Is that a known issue?

> Yes.

Well at least that's a good thing :)

>> If it is then what's the fix?

> If you've fragmented free space, then your ony options are:

> 	- dump/mkfs/restore - remove a large number of files from the
> filesystem so free space defragments.

That wouldn't be fixed automagically using xfs_repair, wouldn't it?

> If you simply want to avoid the shutdown, then upgrade to a more
> recent kernel (3.x of some kind) where all the known issues have been
> fixed.

How about 2.6.32? That's the kernel that comes with RHEL 6.x

>> I went through the kernel updates for CentOS 5.10 (newer kernel),
>> but didn't see any xfs related fixes since CentOS 5.9

> That's something you need to talk to your distro maintainers about....

I was worried you gonna say that :)

What are my options at this point? Am I correct to assume that the issue
is related to the load and if I manage to decrease the load, the issue
is not going to reproduce itself? We have been using XFS on RHEL 5
kernels for years and didn't see this issue. Now, the issue happens
consistently, but seems to be related to high load...

We have hundreds of these servers deployed in production right now, so
some way to address the current situation would be very welcomed.

thanks for help :)

> Cheers,
> Dave.

-- 
"Every problem that I solved became a rule which served afterwards to
solve other problems."  
- Descartes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
