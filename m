Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 17A787F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 12:38:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B79B7AC001
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 10:38:17 -0700 (PDT)
Message-ID: <5192767D.8070607@redhat.com>
Date: Tue, 14 May 2013 12:38:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests btrfs/284: shorten duration, fix output
References: <517ACB41.2030002@redhat.com> <51925612.5050002@sgi.com>
In-Reply-To: <51925612.5050002@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 5/14/13 10:19 AM, Rich Johnston wrote:
> On 04/26/2013 01:45 PM, Eric Sandeen wrote:
>> test 284 had... some issues.
>>
>> First, it took so long nobody ran it; so shorten the extent
>> count by a factor of about 100.
>>
>> Having fixed that, we see failures in 2 cases; when start or
>> len is -1, but the golden output file didn't have error
>> output, as if they should pass.
>>
>> I'm going to argue that these *should* both fail; start = -1
>> has no real meaning.  length = -1 might mean "the rest
>> of the file" but if that's what you really want, just
>> don't specify -l.
>>
>> So add failure output for those cases.
>>
>> Send all command output to $seq.full, in case that changes
>> in the future; just capture the return value.
>>
>> Then remove the return value echo on failure (50?) because
>> who knows when that might change to some other magic value.
>>
>> Ok, then when defrag actually works, old defrag returned
>> "20" (because?) but a recent commit changed it to 0.
>> So accommodate that too.
>>
>> And remove a stray "HAVE_DEFRAG=1" while we're at it.
>> That variable is never used.
>>
> 
> So should I be seeing failures with
> btrfs-progs-0.20-0.2.git91d9eec.el6.x86_64 installed?

Maybe? ...if that's an old version in rhel6.

If you really want to investigate this, you could grab i.e.
http://kojipkgs.fedoraproject.org/packages/btrfs-progs/0.20.rc1.20130501git7854c8b/3.fc20/src/btrfs-progs-0.20.rc1.20130501git7854c8b-3.fc20.src.rpm
and rebuild it for something newer.  (Or I could double check . . . )

But honestly as the sgi xfstests maintainer I think you are going well above and beyond your duties here.

Ideally, someone from the btrfs community could help out here, and test/review the change...

-Eric

> ./check btrfs/284
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 cxfsxe4 3.9.0+
> MKFS_OPTIONS  -- /dev/sdk2
> MOUNT_OPTIONS -- /dev/sdk2 /mnt/scratch
> 
> btrfs/284     - output mismatch (see /usr/src/rcj/xfstests/results/btrfs/284.out.bad)
>     --- tests/btrfs/284.out    2013-05-14 09:31:35.000000000 -0500
>     +++ /usr/src/rcj/xfstests/results/btrfs/284.out.bad    2013-05-14 10:10:45.000000000 -0500
>     @@ -6,7 +6,6 @@
>      btrfs filesystem defragment failed!
>      a single file | start > file size && 0 < len < file size | off
>      a single file | start = 0 && len < 0 | off (should fail)
>     -btrfs filesystem defragment failed!
>      a single file | start = 0 && len > file size | off
>      a single file | start = 0 && 0 < len < file size | off
>      a directory | default | off
>      ...
>      (Run 'diff -u tests/btrfs/284.out /usr/src/rcj/xfstests/results/btrfs/284.out.bad' to see the entire diff)
> Ran: btrfs/284
> Failures: btrfs/284
> Failed 1 of 1 tests
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
