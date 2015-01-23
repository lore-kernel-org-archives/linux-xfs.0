Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3914A7F62
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 09:40:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEFABAC001
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 07:40:24 -0800 (PST)
Received: from mail-pd0-f179.google.com (mail-pd0-f179.google.com
	[209.85.192.179]) by cuda.sgi.com with ESMTP id
	Khj6K2oS0bvuKxY7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2015 07:40:21 -0800 (PST)
Received: by mail-pd0-f179.google.com with SMTP id v10so9135659pde.10
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 07:40:20 -0800 (PST)
Message-ID: <54C26B5F.7000803@xtremenitro.org>
Date: Fri, 23 Jan 2015 22:40:15 +0700
From: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>
MIME-Version: 1.0
Subject: Re: Change sector size on existing partition
References: <54C246EC.90207@xtremenitro.org> <54C268ED.2000801@sandeen.net>
In-Reply-To: <54C268ED.2000801@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi,

I'm sorry, didnt fill any information here, but here is my nodes details.

$ uname -a
Linux catalyst-db01.jkt3d.xxx 2.6.32-504.3.3.el6.x86_64 #1 SMP Wed Dec
17 01:55:02 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

$ cat /etc/redhat-release
CentOS release 6.6 (Final)

The xfs and partition table build from anaconda from first install,
instalation came from CentOS 6.6. But it's weird, only this node has 4k
sector size, the others is 512.

catalyst-db01$ yum history info 1 | grep xfsprogs | fpaste
Uploading (0.2KiB)...
http://ur1.ca/jihyu -> http://paste.fedoraproject.org/173606/27434142

catalyst-db02$ yum history info 1 | grep xfsprogs | fpaste
Uploading (0.2KiB)...
http://ur1.ca/jihzp -> http://paste.fedoraproject.org/173608/27517142

Is it bug?

On 01/23/2015 10:29 PM, Eric Sandeen wrote:
> On 1/23/15 7:04 AM, Dewangga Bachrul Alam wrote:
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
>> [1] https://groups.google.com/forum/#!topic/tokudb-user/kvQFJLCmKwo
> 
> You almost certainly need this commit to resolve the issue.
> 
> You didn't say here what kernel you were using, but from your other
> post it looks like CentOS 6.4.  Are you using stock xfsprogs from centos6.4
> as well?  I don't remember if it chooses 4k sectors for 4k physical block
> devices or not; unless you have a custom xfsprogs version or overrode
> sector size at mkfs time, I guess it must.
> 
> commit 7c71ee78031c248dca13fc94dea9a4cc217db6cf
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Tue Jan 21 16:46:23 2014 -0600
> 
>     xfs: allow logical-sector sized O_DIRECT
>     
>     Some time ago, mkfs.xfs started picking the storage physical
>     sector size as the default filesystem "sector size" in order
>     to avoid RMW costs incurred by doing IOs at logical sector
>     size alignments.
>     
>     However, this means that for a filesystem made with i.e.
>     a 4k sector size on an "advanced format" 4k/512 disk,
>     512-byte direct IOs are no longer allowed.  This means
>     that XFS has essentially turned this AF drive into a hard
>     4K device, from the filesystem on up.
>     
>     XFS's mkfs-specified "sector size" is really just controlling
>     the minimum size & alignment of filesystem metadata.
>     
>     There is no real need to tightly couple XFS's minimal
>     metadata size to the minimum allowed direct IO size;
>     XFS can continue doing metadata in optimal sizes, but
>     still allow smaller DIOs for apps which issue them,
>     for whatever reason.
>     
>     This patch adds a new field to the xfs_buftarg, so that
>     we now track 2 sizes:
>     
>      1) The metadata sector size, which is the minimum unit and
>         alignment of IO which will be performed by metadata operations.
>      2) The device logical sector size
>     
>     The first is used internally by the file system for metadata
>     alignment and IOs.
>     The second is used for the minimum allowed direct IO alignment.
>     
>     This has passed xfstests on filesystems made with 4k sectors,
>     including when run under the patch I sent to ignore
>     XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
>     tested end of block behavior on preallocated, sparse, and
>     existing files when we do a 512 IO into a 4k file on a
>     4k-sector filesystem, to be sure there were no unexpected
>     behaviors.
>     
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
