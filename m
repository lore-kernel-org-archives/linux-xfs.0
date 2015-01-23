Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F13DD7F5A
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 07:47:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EF0EAC008
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 05:47:04 -0800 (PST)
Received: from mail-pd0-f176.google.com (mail-pd0-f176.google.com
	[209.85.192.176]) by cuda.sgi.com with ESMTP id
	NikhfdsOfw8iTTEg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2015 05:47:03 -0800 (PST)
Received: by mail-pd0-f176.google.com with SMTP id y10so8645174pdj.7
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 05:47:03 -0800 (PST)
Message-ID: <54C250D3.9030706@xtremenitro.org>
Date: Fri, 23 Jan 2015 20:46:59 +0700
From: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>
MIME-Version: 1.0
Subject: Re: Change sector size on existing partition
References: <54C246EC.90207@xtremenitro.org>
	<20150123133933.GA2864@laptop.bfoster>
In-Reply-To: <20150123133933.GA2864@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hi,

The device reported like this :

$ blockdev --getss --getpbsz --getiomin --getioopt /dev/dm-3
512
4096
4096
0

Then, the sector size should be 512. Don't know why it can be 4096. :( I
will try to backup them and reformat. Any suggestion for formating on
raid-10 array? The device is 4 x 1TB drives.

On 01/23/2015 08:39 PM, Brian Foster wrote:
> On Fri, Jan 23, 2015 at 08:04:44PM +0700, Dewangga Bachrul Alam wrote:
>> Hi,
>>
>> I'm new to XFS, I have RAID-10 array with 4 disk, when I check with
>> xfs_info, the information print like this.
>>
>> $ xfs_info /var/lib/mysql
>> meta-data=/dev/mapper/vg_catalystdb01-lv_database isize=256
>> agcount=16, agsize=1600000 blks
>>          =                       sectsz=4096  attr=2, projid32bit=0
>> data     =                       bsize=4096   blocks=25600000, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=12500, version=2
>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> Is it possible to change `sectsz` value to 512 without re-format it? Or
>> any suggestion? I have issue with current sector size, my TokuDB
>> engines[1] can't start because of this.
>>
> 
> The only way to set things like sector size, block size, etc. is to
> reformat. I believe the default sector size is dependent on the physical
> device. You might want to report the following from your array device
> and perhaps from some or all of the member devices:
> 
> blockdev --getss --getpbsz --getiomin --getioopt <device>
> 
> Brian
> 
>> [1] https://groups.google.com/forum/#!topic/tokudb-user/kvQFJLCmKwo
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
