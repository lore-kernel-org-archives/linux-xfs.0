Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AAUfdF071930 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 04:30:41 -0600
Received: from USMAMAIL.TILERA.COM (usmamail.tilera.com [206.83.70.75]) by
	cuda.sgi.com with ESMTP id JW0AuUkuisgRlmxh for
	<xfs@oss.sgi.com>; Tue, 10 Jan 2012 02:30:38 -0800 (PST)
From: Tony Lu <zlu@tilera.com>
Subject: RE: XFS: bad clientid on recovery on MIPS (VIPT cache)
Date: Tue, 10 Jan 2012 10:30:33 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C687EDD@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C6875A2@USMAExch1.tad.internal.tilera.com>
	<CAB4K4y7SmGKG1yVvxu5jSberYS8ayYiGHOGe81CNZHmOHi7ssg@mail.gmail.com>
	<CAB4K4y5W0o8mJ2koKgEZtRRB4k=UNjr3Ha1zq_ic+0LjFw-LpQ@mail.gmail.com>
In-Reply-To: <CAB4K4y5W0o8mJ2koKgEZtRRB4k=UNjr3Ha1zq_ic+0LjFw-LpQ@mail.gmail.com>
Content-Language: zh-CN
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks for your kindly help, Ajeet.

I am using 2.6.38.6. =


>-----Original Message-----
>From: Ajeet Yadav [mailto:ajeet.yadav.77@gmail.com]
>Sent: Monday, January 09, 2012 3:28 PM
>To: Tony Lu; xfs@oss.sgi.com
>Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
>
>Yes I implemented these definitions for MIPS, without them this
>problem will continue to occur.
>
>On Mon, Jan 9, 2012 at 12:52 PM, Ajeet Yadav <ajeet.yadav.77@gmail.com> wr=
ote:
>> Hi,
>> You are using which kernel version ? because this is fixed in XFS in
>> kernel 2.6.34
>>
>http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dco=
mmit;
>h=3D73c77e2ccc14413c232c3e0b3aa43a0c4b72ec70
>>
>> but for this patch to work correctly, yer you need to provide the
>> architecture dependent definition of invalidate_kernel_vmap_range() /
>> flush_kernel_vmap_range() and ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE,
>> similar to this patch
>>
>>
>http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dco=
mmit;
>h=3D252a9afff76097667429b583e8b5b170b47665a4
>>
>http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dco=
mmit;
>h=3D73be1591579084a8103a7005dd3172f3e9dd7362
>>
>> Note: include/linux/highmem.h provide dummy definitions if
>> architecture does not define them
>>
>> #ifndef ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
>> static inline void flush_kernel_dcache_page(struct page *page)
>> {
>> }
>> static inline void flush_kernel_vmap_range(void *vaddr, int size)
>> {
>> }
>> static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
>> {
>> }
>> #endi
>>
>>
>>
>>
>> On Fri, Jan 6, 2012 at 3:44 PM, Tony Lu <zlu@tilera.com> wrote:
>>> Hi, Ajeet
>>>
>>> Sorry to bother you. By googling, I found that I am encountering the sa=
me
>XFS umount issue on TILE architecture. And I noticed that somebody suggest=
ed
>that other architectures like ARM, MIPS need to implement the following
>functions to fix this issue.
>>>
>>> flush_kernel_dcache_page()
>>> flush_kernel_vmap_range()
>>> void invalidate_kernel_vmap_range()
>>>
>>> I am not sure if these functions can really fix this issue, since I imp=
lemented
>these functions for TILE architecture, but did not fix it.
>>>
>>> So I really want to know that if you implemented these functions for MI=
PS
>to fix this issue. Or is there other method to fix this issue?
>>>
>>> I would be very appreciated for any feedback from you.
>>>
>>> Thanks
>>> -Tony
>>>
>>>>Dear member,
>>>>If I remove USB flash storage from PC/ARM/MIPS target (i.e without umou=
nt)
>while >copying file to XFS partition and connect it to MIPS target I alway=
s get
>>>>XFS: xlog_recover_process_data: bad clientid
>>>>XFS: log mount/recovery failed: error 5
>>>>XFS: log mount failed
>>>>This problem does not occur, if I connect the same USB flash to PC/ARM =
target.
>>>>I have tested this on 2.6.30 - 2.6.34 (It everywhere when concerend wit=
h MIPS)
>>>>
>>>>I had two workaround to avoid this problem on MIPS, but I wish to know =
the
>exact >reason of this problme on MIPS.
>>>>I am really tired and giving up, so finally thought of taking your help=
, your
>>guidence can help me.
>>>>
>>>>1. __flush_cache_all() at the begining of each iteration of while loop =
in
>>function xlog_recover_process_data().
>>>>
>>>> =A0 =A0 while ((dp < lp) && num_logops) {
>>>>+ =A0 =A0 =A0 __flush_cache_all() ;
>>>> =A0 =A0 =A0 =A0 ASSERT(dp + sizeof(xlog_op_header_t) <=3D lp);
>>>> =A0 =A0 =A0 =A0 ohead =3D (xlog_op_header_t *)dp;
>>>> =A0 =A0 =A0 =A0 dp +=3D sizeof(xlog_op_header_t);
>>>> =A0 =A0 =A0 =A0 if (ohead->oh_clientid !=3D XFS_TRANSACTION &&
>>>> =A0 =A0 =A0 =A0 =A0 =A0 ohead->oh_clientid !=3D XFS_LOG) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 xlog_warn(
>>>> =A0 =A0 =A0 =A0 =A0 =A0 "XFS: xlog_recover_process_data: bad clientid")
>>>>
>>>>OR
>>>>
>>>>2. Provide new buffer in each call to xlog_bread in function
>>xlog_do_recovery_pass().
>>>>
>>>> =A0 =A0 =A0 =A0 =A0if (error)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0goto bread_err2;
>>>> =A0 =A0 =A0 =A0 =A0/* blocks in data section */
>>>> =A0 =A0 =A0 =A0 =A0bblks =3D (int)BTOBB(be32_to_cpu(rhead->h_len));
>>>>+ =A0 =A0 =A0 =A0xlog_put_bp(dbp);
>>>>+ =A0 =A0 =A0 =A0dbp =3D xlog_get_bp(log, BTOBB(h_size));
>>>> =A0 =A0 =A0 =A0 =A0error =3D xlog_bread(log, blk_no + hblks, bblks, db=
p,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 &offset);
>>>> =A0 =A0 =A0 =A0 =A0if (error)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0goto bread_err2;
>>>>
>>>>WIth Regards
>>>>Ajeet Yadav

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
