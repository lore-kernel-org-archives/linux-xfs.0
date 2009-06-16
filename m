Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GHSNYo171240
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 12:28:24 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3C39126487D
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 10:28:47 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.221.174]) by cuda.sgi.com with ESMTP id
	O2tyPr0DMKr110VT for <linux-xfs@oss.sgi.com>;
	Tue, 16 Jun 2009 10:28:47 -0700 (PDT)
Received: by qyk4 with SMTP id 4so6106815qyk.20
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 10:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
	<4A37B744.9030301@sandeen.net>
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>
Date: Tue, 16 Jun 2009 10:28:41 -0700
Message-ID: <8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
Subject: Re: XFS Preallocate using ALLOCSP
From: Smit Shah <getsmit@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Felix Blyakher <felixb@sgi.com>
Cc: linux-xfs@oss.sgi.com

On 6/16/09, Felix Blyakher <felixb@sgi.com> wrote:
>
> On Jun 16, 2009, at 10:16 AM, Eric Sandeen wrote:
>
>> Smit Shah wrote:
>>
>>> Even the man page of fallocate says that it allocates and initializes
>>> to zero the disk space allocated
>>
>> Bleah, so it does:
>>
>>       FALLOC_FL_KEEP_SIZE
>>              This flag allocates and initializes to zero the disk
>> space
>>
>> well, that's misleading and/or wrong.
>>
>>> but when i saw the code i did found out that it does not zero it out.
>>> Hence was a kindof confused. So posix_allocate is similar to ALLOCSP
>>> when falloc is not supported by the underlying filesystem  that is to
>>> ftruncate the file  and zero it out. So all of them try to allocate
>>> contiguous blocks but the only difference is when we use the
>>> fallocate in ext4/xfs it does not zero out the preallocated space. Am
>>> i right ?
>>
>> fallocate / sys_fallocate marks the region as uninitialized so that
>> you
>> get back 0s when you read.  It's implemented on xfs, ext4, ocfs2,
>> and btrfs.
>>
>> posix_fallocate manages to reach sys_fallocate when all the stars
>> align:
>> kernel,  glibc, and filesystgem.  Otherwise it writes 0s.
>>
>>> But  when i fallocate in ext4 i can see the write performance
>>> improvement but not in xfs
>>
>> Testing how?

I use IOmeter to test it.

>>
>>> and reason i found out in one of your previous comments is  because
>>> of the unwritten flag set in xfs. So how do we see if the unwritten
>>> flag is set or not ? I did use xfs_info but it didnt show any such
>>> information.
>>
>> ext4 & xfs are doing the same basic thing, they must maintain the
>> unwritten state on the preallocated extents, and manage that as it
>> changes when portions are written with real data.
>
> Well, the difference in managing the unwritten state can
> theoretically result in different performance. Not that I'd
> expect ext4 being better than xfs in this respect.
> More data is needed here.

Like when i do preallocation i see the thorughput for seq writes being
the same in ext4 but for xfs its goes down by say 10Mps or so.

>
>> xfs_bmap -v -v -p on a file will show you extent state for xfs.
>>
Thanks a lot.
>>> I guess i am not right here ftruncate simply does a lseek and wirtes
>>
>> ftruncate simply sets i_size, it does no data IO.
>
> ... and no block reservation/allocation either.
>
Yeah rite what i meant to say was that posix_fallocate uses ftruncate
which in turn just updates the i_size and then posix_fallocate zeros
out the whole thing

>>> to it which might not be contiguous whereas fallocate tries to
>>> allocate contiguous block so as to reduce fragmentation
>>
>> Actually fallocate's only official job is to reserve blocks so you
>> don't
>> get ENOSPC later.  Because the request comes in all at once, you are
>> very likely to get an optimal allocation, and that's a nice side
>> effect,
>> but it's not actually required by the interface.
>>
>>> and hence i
>>> thought to reduce fragmentation and for security reasons
>>
>> None of these normal interfaces poses any security risk.  If you build
>> xfs without the unwritten extent feature
>
> I don't think, it's possible. Not in any configurable way,
> at least.
>
>> you could allocate w/o flagging
>> uninitialized and expose stale data, but that's not a normal mode of
>> operation.
>
> That's was possible with mount option unwritten=0, but
> AFAIK, it's been recently completely removed from code.
>
>>
>>
>>> its better
>>> to use ALLOCSP rather than something like ftruncate /posix_fallocate
>>> or RSEVSP which kindof performs bad for writes with unwritten flag
>>> set and now there being a no direct way while creating the fs to
>>> disable unwritten.
>>
>> In the end, there are only 2 ways to preallocate blocks: explicitly
>> write 0s, or flag regions as unwritten (as xfs/ext4/... can do).
>
> Exactly.
> That's a trade-off between spending time on setup or at the
> write time. And if explicit zeros are desirable for the former
> approach, it can be driven from the user space (after
> preallocation) rather than from the kernel with the exactly the
> same outcome.
>
> Just restating the same what Eric already said :)
>
> Felix
>
>>  (Ok,
>> or a 3rd sorta-way, which is to reserve w/o flagging, maybe that's
>> what
>> you're looking for, but that's deprecated or not really available at
>> this point).
Yes that is what i was looking for :) but i guess its no more
available through mkfs.xfs
and i will have to do it with xfs_db as stated in one of the Eric's
replies in the previous posts

>>
>> Maybe I should ask what the end goal is here.  :)
>>
Just to see if preallocation using fallocate helps reducing the
fragmentation and increases the throughput.  I guess it wll help
reduce the fragmentation but the write performance is going to suffer.

>> -Eric
>>
>>> Thanks, Smit
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
