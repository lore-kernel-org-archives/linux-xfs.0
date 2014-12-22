Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93AC47F4E
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 04:09:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 231FDAC002
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 02:09:09 -0800 (PST)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	M15VJ5UtVONb6rYY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 02:09:08 -0800 (PST)
Received: by mail-wi0-f178.google.com with SMTP id em10so7368829wid.17
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 02:09:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141221230818.GH24183@dastard>
References: <B97466D39E354AFB808620584A4ABE5C@alyakaslap>
	<54970DD9.6080707@sandeen.net> <20141221230818.GH24183@dastard>
Date: Mon, 22 Dec 2014 12:09:07 +0200
Message-ID: <CAOcd+r2ifn=iWFD0j1iYt8HZi3XsEfJX3DR5LPBdJ0tzDeZM=w@mail.gmail.com>
Subject: Re: XFS corruption
From: Alex Lyakas <alex@zadarastorage.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi Eric, Dave,

Thank you for looking at this.

On Mon, Dec 22, 2014 at 1:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Dec 21, 2014 at 12:13:45PM -0600, Eric Sandeen wrote:
>> On 12/21/14 5:42 AM, Alex Lyakas wrote:
>> > Greetings,
>> > we encountered XFS corruption:
>>
>> > kernel: [774772.852316] ffff8801018c5000: 05 d1 fd 01 fd ff 2f ec 2f 8d 82 6a 81 fe c2 0f  .....././..j....
>>
>> There should have been 64 bytes of hexdump, not just the single line above, no?
>
> Yeah, really need the whole dmesg, because we've got readahead in
> the picture here so the number of times the corruption error is seen
> is actually important....
>

I uploaded the full dump, captured by our kmsg dumper here:
https://drive.google.com/file/d/0ByBy89zr3kJNUkRfRG9TMWVnVkU/view?usp=sharing

As far as I see, all the corruption warnings are the same, and they
all print only one line of hex dump. There are some additional
warnings, like:
[812756.915765] XFS (dm-72): Access to block zero in inode 1946454529
start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 964
[812756.915765]
[812756.915772] XFS (dm-72): Access to block zero in inode 1946454529
start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 964
[812756.915772]
[812756.915815] XFS (dm-72): Access to block zero in inode 1946454529
start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 964

Two more log files (one prior to the crash and one from another VM
that took over after the crash). All corruption reports are the same.
https://drive.google.com/file/d/0ByBy89zr3kJNSHRCaUxDQnBEZHc/view?usp=sharing
https://drive.google.com/file/d/0ByBy89zr3kJNYk1hRTRaVDE4ZzA/view?usp=sharing

Unfortunately, I did not capture the output of xfs_repair. I also have
not captured the metadump. So I realize we do not have much to work
on.

Thanks!
Alex.


>>
>> > [813114.622928] IP: [<ffffffffa077bad9>] xfs_bmbt_get_all+0x9/0x20 [xfs]
>> > [813114.622928] PGD 0
>> > [813114.622928] Oops: 0000 [#1] SMP
>> > [813114.622928] CPU 2
>> > [813114.622928] Pid: 31120, comm: smbd Tainted: GF       W  O 3.8.13-030813-generic #201305111843 Bochs Bochs
>> > [813114.622928] RIP: 0010:[<ffffffffa077bad9>]  [<ffffffffa077bad9>] xfs_bmbt_get_all+0x9/0x20 [xfs]
>> > [813114.622928] RSP: 0018:ffff88010a193798  EFLAGS: 00010297
>> > [813114.622928] RAX: 0000000000000964 RBX: ffff880180fa9c38 RCX: ffffa5a5a5a5a5a5
>
> RCX implies gotp->br_startblock was not overwritten by the
> extent search. i.e. we've called xfs_bmap_search_multi_extents()
> but no extent was actually found.
>
>> > We analyzed several suspects, but all of them fall on disk addresses
>> > not near the corrupted disk address. I realize that running somewhat
>> > outdated kernel + our changes within XFSs, points back at us, but
>> > this is first time we see XFS corruption after about a year of this
>> > code being exercised. So posting here, just in case this is a known
>> > issue.
>>
>> well, xfs should _never_ oops, even if it encounters corruption.  So hopefully
>> we can work backwards from the trace above to what went wrong here.
>>
>> offhand, in xfs_bmap_search_multi_extents():
>>
>>         ep = xfs_iext_bno_to_ext(ifp, bno, &lastx);
>>         if (lastx > 0) {
>>                 xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx - 1), prevp);
>>         }
>>         if (lastx < (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
>>                 xfs_bmbt_get_all(ep, gotp);
>>                 *eofp = 0;
>>
>> xfs_iext_bno_to_ext() can return NULL with lastx set to 0:
>>
>>         nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
>>         if (nextents == 0) {
>>                 *idxp = 0;
>>                 return NULL;
>>         }
>>
>> (where idxp is the &lastx we sent in)
>
>> and if we do that, it sure seems like the "if lastx < ...." test will wind up
>> sending a null ep into xfs_bmbt_get_all, which would do a null ptr deref.
>
> No, it shouldn't because lastx = 0 to get it set that way
> ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t) must be zero.
> Therefore, this:
>
>         if (lastx < (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)))
>
> evaulates as:
>
>         if (0 < 0)
>
> which is not true, so we fall into the else case:
>
>         } else {
>                 if (lastx > 0) {
>                         *gotp = *prevp;
>                 }
>                 *eofp = 1;
>                 ep = NULL;
>         }
>         *lastxp = lastx;
>         return ep;
>
> Which basically overwrites *eofp and *lastxp, neither of which are
> NULL.
>
> However, the stack trace clearly shows we've just called
> xfs_bmap_search_multi_extents() - the "?" before the function name
> means it found the symbol in the stack, but not in the direct line
> of the frame pointers the current function stack points to.
>
> That makes me doubt the accuracy of the stack trace, because the
> only caller of xfs_bmap_search_multi_extents() is
> xfs_bmap_search_extents() and xfs_bmap_search_extents does not call
> xfs_bmbt_get_all() directly like the stack trace would lead us to
> beleive. Hence I don't think we can trust the stack trace to be
> pointing use at the correct caller of xfs_bmbt_get_all(), which
> makes it real hard to isolate the cause...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
