Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C7057F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 14:00:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C71338F8050
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 12:00:21 -0700 (PDT)
Received: from nm27-vm8.access.bullet.mail.gq1.yahoo.com
	(nm27-vm8.access.bullet.mail.gq1.yahoo.com [216.39.63.235]) by
	cuda.sgi.com with ESMTP id LnG9fPtr6YTg5V4v (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 12:00:20 -0700 (PDT)
Message-ID: <543ACFC2.2090308@sbcglobal.net>
Date: Sun, 12 Oct 2014 14:00:18 -0500
From: BillStuff <billstuff2001@sbcglobal.net>
MIME-Version: 1.0
Subject: Re: dmesg error in xfs_aops.c on kernel 3.14.21
References: <54397E0F.2050700@sbcglobal.net>
	<20141012140704.GA35667@bfoster.bfoster>
In-Reply-To: <20141012140704.GA35667@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 10/12/2014 09:07 AM, Brian Foster wrote:
> On Sat, Oct 11, 2014 at 01:59:27PM -0500, BillStuff wrote:
>> Hi,
>>
>> I'm running 3.14.21, and got these traces in dmesg; they appear to be from
>> xfs:
>>
>> [56180.816526] ------------[ cut here ]------------
>> [56180.816550] WARNING: CPU: 5 PID: 67 at fs/xfs/xfs_aops.c:1172
>
> 	if (WARN_ON(delalloc))
> 		return 0;
>
> So this generally looks like stale delalloc blocks on a page that is
> reclaimed/invalidated or otherwise expected to be clean. We've been
> seeing this a lot over the past few kernel releases and there have been
> a variety of fixes in error paths and such so it's hard to say precisely
> what might be causing this. Some examples:
>
> aad3f375 xfs: xfs_vm_write_end truncates too much on failure
> 72ab70a1 xfs: write failure beyond EOF truncates too much data
> 4ab9ed57 xfs: kill buffers over failed write ranges properly
>
> It looks like those are in the stable tree as of 3.15, so you could give
> that a try and see if it helps. Otherwise, can you post xfs_info for the
> filesytem? Do you have particular workloads or sequences of operations
> that tend to reproduce this?
>
> Brian
>
Thanks Brian,

I'll try out those fixes.

The filesystem is home theater recordings on a 6 disk raid5 array:

meta-data=/dev/md3               isize=256    agcount=81, 
agsize=15237264 blks
          =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=1218981920, imaxpct=5
          =                       sunit=16     swidth=80 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=131072 blocks=0, rtextents=0

I believe it was just starting a recording when I got this message.

-Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
