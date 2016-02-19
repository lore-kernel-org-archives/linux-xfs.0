Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F16C7CAF
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 00:49:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7314A8F8040
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 22:49:40 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3XS9Zzxzczt84dYJ for <xfs@oss.sgi.com>;
	Thu, 18 Feb 2016 22:49:35 -0800 (PST)
Date: Fri, 19 Feb 2016 17:49:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [lkp] [xfs] fbcc025613: -5.6% fsmark.files_per_sec
Message-ID: <20160219064932.GX14668@dastard>
References: <87vb5lqunb.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87vb5lqunb.fsf@yhuang-dev.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: kernel test robot <ying.huang@linux.intel.com>
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, lkp@01.org, LKML <linux-kernel@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>

On Fri, Feb 19, 2016 at 10:52:08AM +0800, kernel test robot wrote:
> FYI, we noticed the below changes on
> =

> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit fbcc025613590d7b1d15521555dcc6393a148a6b ("xfs: Introduce writebac=
k context for writepages")
> =

> =

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> compiler/cpufreq_governor/disk/filesize/fs/iterations/kconfig/md/nr_threa=
ds/rootfs/sync_method/tbox_group/test_size/testcase:
>   gcc-4.9/performance/8BRD_12G/4M/xfs/1x/x86_64-rhel/RAID0/1t/debian-x86_=
64-2015-02-07.cgz/fsyncBeforeClose/lkp-hsx02/60G/fsmark
> =

> commit: =

>   150d5be09ce49a9bed6feb7b7dc4e5ae188778ec
>   fbcc025613590d7b1d15521555dcc6393a148a6b
> =

> 150d5be09ce49a9b fbcc025613590d7b1d15521555 =

> ---------------- -------------------------- =

>          %stddev     %change         %stddev
>              \          |                \  =

>      36122 =B1  0%     -57.4%      15404 =B1  0%  fsmark.time.involuntary=
_context_switches
>      95.30 =B1  0%      +1.8%      97.00 =B1  0%  fsmark.time.percent_of_=
cpu_this_job_got
>      25339 =B1 32%   +5756.0%    1483901 =B1  1%  fsmark.time.voluntary_c=
ontext_switches
>     881.80 =B1 45%  +14258.5%     126613 =B1 10%  latency_stats.hits.wait=
_on_page_bit.__filemap_fdatawait_range.filemap_fdatawait_range.filemap_writ=
e_and_wait_range.xfs_file_fsync.vfs_fsync_range.do_fsync.SyS_fsync.entry_SY=
SCALL_64_fastpath
>       3548 =B1 48%  +11967.4%     428200 =B1  7%  latency_stats.sum.wait_=
on_page_bit.__filemap_fdatawait_range.filemap_fdatawait_range.filemap_write=
_and_wait_range.xfs_file_fsync.vfs_fsync_range.do_fsync.SyS_fsync.entry_SYS=
CALL_64_fastpath
.....
> 2016-02-17 22:08:15 mount -t xfs -o nobarrier,inode64 /dev/ram0 /fs/ram0
> 2016-02-17 22:08:16 ./fs_mark -d /fs/ram0/1 -n 10240 -L 1 -S 1 -s 4194304

Ok, so 10k x 4MB files, fsync after each. Let me go look.

So the problem above appears to be that fsync is waiting on 125,000
more pages to complete IO, causing a major increase in context
switches during fsync. With only 10000 files being created, that
mores than 10 pages per file that is being waited on.

That doesn't really seem right. The writeback should be done as a
single ioend, with a single completion, with a single setsize
transaction, adn then all the pages are marked clean sequentially.
The above behaviour implies we are ending up doing something like:

fsync proc		io completion
wait on page 0
			end page 0 writeback
			wake up page 0
wait on page 1
			end page 1 writeback
			wake up page 1
wait on page 2
			end page 2 writeback
			wake up page 2

Though in slightly larger batches than a single page (10 wakeups a
file, so batches of around 100 pages per wakeup?). i.e. the fsync
IO wait appears to be racing with IO completion marking pages as
done. I simply cannot see how the above change would cause that, as
it was simply a change in the IO submission code that doesn't affect
overall size or shape of the IOs being submitted.

This is a patch in the middle of a larger patch set - if any of the
patches in that series should affect behaviour, it's the commit a
couple further that removed the XFS page clustering code - that
changes the size and shape of the ioends and bios we build and
submit and so if anything is perturbing Io completion behaviour I'd
expect those to be the culprit....

Does this same problem context switch problem still exist when the
entire set of patches in the XFs series has been applied? I can't
reproduce it here locally with the entire series applied, but I have
only tested on 16p with 48GB RAM. The context switch rate does not
go above 3,000/s, regardless of whether I use a ramdisk or high
throughput SSDs. Tracing also clearly indicates a single 4MB ioend
is being build and submitted by the new code and so that implies
that the io completions that are occuring before and after this
patchset are identical, and so therefore the way pages are moving
from dirty -> writeback -> clean is identical before and after the
patch series.

So, like I said - this makes no sense to me from the perspective of
the change that you've bisected it down to. This smells to me of a
scheduler change in the linux-next tree, espcially as I can't
reproduce the behaviour with just the XFS commits in isolation on a
4.5-rc3 tree.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
