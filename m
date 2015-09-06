Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 659F97F50
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2015 16:56:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46F738F8049
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2015 14:56:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id egmY9vv8mkmTVoeq for <xfs@oss.sgi.com>;
	Sun, 06 Sep 2015 14:56:12 -0700 (PDT)
Subject: Re: xfs corruption
References: <CAC=x_0hAQR9Ynmnqohv1R8xv3TBot5wmn7DODx6GbKU7tYv2sA@mail.gmail.com>
	<55E8498F.8090508@sandeen.net>
	<CAC=x_0iUc2VEfW9qChuvUpDk5Kz=wvRGH-1w6sS0XP6CG_ERBQ@mail.gmail.com>
	<55E85F5F.6010005@sandeen.net> <55E871EF.4040603@sandeen.net>
	<42D7AA163AD247998B82E3C75D289FC2@alyakaslap>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55ECB67A.2070707@sandeen.net>
Date: Sun, 6 Sep 2015 16:56:10 -0500
MIME-Version: 1.0
In-Reply-To: <42D7AA163AD247998B82E3C75D289FC2@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>, Danny Shavit <danny@zadarastorage.com>
Cc: xfs@oss.sgi.com

On 9/6/15 5:19 AM, Alex Lyakas wrote:
> Hi Eric,
> Thank you for your comments.
> 
> Yes, we made the ACL limit change, being fully aware that this breaks
> compatibility with the mainline kernel and future mainline kernels.
> We mount our XFS filesystems with our kernel only. We are also aware
> that this change needs to be carefully forward-ported, when we move
> to a newer kernel.

Ok, sorry for the lecture...  ;)  I did want to make sure it
hadn't been mounted on an unmodified kernel, though.

> I have an additional question regarding the latest XFS corruption report:
> kernel: [3507105.314446] Pid: 25231, comm: kworker/0:0H Tainted: GF       W O 3.8.13-030813-generic #201305111843
> kernel: [3507105.314449] Call Trace:
> kernel: [3507105.314487]  [<ffffffffa0631baf>] xfs_error_report+0x3f/0x50 [xfs]
> kernel: [3507105.314502]  [<ffffffffa064e9ce>] ? xfs_allocbt_read_verify+0xe/0x10 [xfs]
> kernel: [3507105.314514]  [<ffffffffa0631c1e>] xfs_corruption_error+0x5e/0x90 [xfs]
> kernel: [3507105.314528]  [<ffffffffa064e862>] xfs_allocbt_verify+0x92/0x1e0 [xfs]
> kernel: [3507105.314540]  [<ffffffffa064e9ce>] ? xfs_allocbt_read_verify+0xe/0x10 [xfs]
> kernel: [3507105.314547]  [<ffffffff810135aa>] ? __switch_to+0x12a/0x4a0
> kernel: [3507105.314551]  [<ffffffff81096cd8>] ? set_next_entity+0xa8/0xc0
> kernel: [3507105.314566]  [<ffffffffa064e9ce>] xfs_allocbt_read_verify+0xe/0x10 [xfs]
> kernel: [3507105.315251]  [<ffffffffa062f48f>] xfs_buf_iodone_work+0x3f/0xa0 [xfs]
> kernel: [3507105.315255]  [<ffffffff81078b81>] process_one_work+0x141/0x490
> kernel: [3507105.315257]  [<ffffffff81079b48>] worker_thread+0x168/0x400
> kernel: [3507105.315259]  [<ffffffff810799e0>] ? manage_workers+0x120/0x120
> kernel: [3507105.315262]  [<ffffffff8107f050>] kthread+0xc0/0xd0
> kernel: [3507105.315265]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
> kernel: [3507105.315270]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
> kernel: [3507105.315273]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
> kernel: [3507105.315275] XFS (dm-39): Corruption detected. Unmount and run xfs_repair
> kernel: [3507105.316706] XFS (dm-39): metadata I/O error: block 0x41a6eff8 ("xfs_trans_read_buf_map") error 117 numblks 8
> 
> From looking at XFS code, it appears that XFS read metadata block
> from disk, and discovered that it was corrupted.

Yes.  Unfortunately the verifier didn't say what it thinks is wrong.

I'd have to look to see for sure, but I think that on your kernel version,
if you turn up the xfs error level sysctl, you should get a hexdump of the
first 64 bytes of the buffer when this happens, and that would hopefully
tell us enough to know what was wrong, and -

> At this point, the
> system was rebooted, and after reboot we prevented this particular
> XFS from mounting. Then we ran xfs-metadump and xfs-repair. The
> latter found absolutely no issues, and XFS was able to successfully
> mount and continue operation.

- and why repair found no issue

With the buffer dump, and then from that hopefully knowing what the verifier
didn't like, we could then check your repair version and be sure it is
performing the same checks as the verifier

-Eric

> Can you think of a way to explain this?
> Can you confirm that the above trace really means that XFS was reading its metadata from disk?
> From XFS code, I see that XFS does not use Linux page cache for its
> metadata (unlike btrfs, for example). Is my understanding correct?
> (Otherwise, I could assume that somebody wrongly touched a page in
> the page-cache and messed up its in-memory content).
> 
> Thanks,
> Alex.
> 
> 
> 
> 
> 
> -----Original Message----- From: Eric Sandeen
> Sent: 03 September, 2015 6:14 PM
> To: Danny Shavit
> Cc: Alex Lyakas ; xfs@oss.sgi.com
> Subject: Re: xfs corruption
> 
> On 9/3/15 9:55 AM, Eric Sandeen wrote:
>> On 9/3/15 9:26 AM, Danny Shavit wrote:
> 
> ...
> 
>>> We are using modified xfs. Mainly, added some reporting features and
>>> changed discard operation to be aligned with chunk sizes used in our
>>> systems. The modified code resides at  https://github.com/zadarastora
>>> <https://github.com/zadarastorage/zadara-xfs-pushback>ge/zadara-xfs-pushback
>>> <https://github.com/zadarastorage/zadara-xfs-pushback>.
>>
>> Interesting, thanks for the pointer.  I guess at this point I have to
>> ask, do you see these same problems without your modifications?
> 
> Have you ever mounted this filesystem on non-zadara kernels?
> 
> looking at
> https://github.com/zadarastorage/zadara-xfs-pushback/commit/094df949fd080ede546bb7518405ab873a444823
> 
> you've changed the disk format w/o adding a feature flag,
> which is pretty dangerous.
> 
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
