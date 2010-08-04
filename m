Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74FdhAL038686 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 10:39:44 -0500
Received: from mail-pv0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F39649417A
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 08:40:03 -0700 (PDT)
Received: from mail-pv0-f181.google.com (mail-pv0-f181.google.com
	[74.125.83.181]) by cuda.sgi.com with ESMTP id IaokGv5p7gbzBOl2
	for <xfs@oss.sgi.com>; Wed, 04 Aug 2010 08:40:03 -0700 (PDT)
Received: by pvg2 with SMTP id 2so2862822pvg.26
	for <xfs@oss.sgi.com>; Wed, 04 Aug 2010 08:40:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100804065347.GZ7362@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
	<AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
	<20100804004746.GT7362@dastard>
	<AANLkTikfK6z7b=0Vpijyz-3m3+_MTtcrbeQk-B9LkK61@mail.gmail.com>
	<20100804042725.GX7362@dastard>
	<AANLkTikkwW48u_y=Tzkh=ob-YanbOpGmCaAH7q=8PpFx@mail.gmail.com>
	<20100804065347.GZ7362@dastard>
Date: Wed, 4 Aug 2010 11:40:02 -0400
Message-ID: <AANLkTi=BA_spq8UoTR5HwDMWSFCp+qO54gTyVu2gdNBc@mail.gmail.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
From: Ilia Mirkin <imirkin@alum.mit.edu>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 4, 2010 at 2:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Aug 04, 2010 at 12:39:08AM -0400, Ilia Mirkin wrote:
>> On Wed, Aug 4, 2010 at 12:27 AM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> > On Tue, Aug 03, 2010 at 09:15:53PM -0400, Ilia Mirkin wrote:
>> >> On Tue, Aug 3, 2010 at 8:47 PM, Dave Chinner <david@fromorbit.com> wr=
ote:
>> >> > Ilia,
>> >> >
>> >> > Can you send me the output of this for your kernel that the
>> >> > traces came from:
>> >> >
>> >> > $ gdb <path/to/vmlinux>
>> >> > (gdb) l *( xfs_write+0x2cc)
>> >> >
>> >> > You can run it against the vmlinux file in the kernel build
>> >> > directory. =A0Basically I need to know which xfs_ilock() call in
>> >> > xfs_write() one of the mysqld-test processes is stuck on.
>> >>
>> >> No problem - BTW, I'm running this on a 2.6.33.3 kernel (same as the
>> >> one before, although diff hardware). If you want (and are fine with me
>> >> "destroying" the current state), I can upgrade it to a kernel of your
>> >> choice and repeat the test overnight.
>> >>
>> >> Naturally I didn't have CONFIG_DEBUG_INFO in there... just changed
>> >> that to Y and recompiled. I'm not entirely sure that this preserves
>> >> all the offsets, but at least the BUG-HUNTING doc makes allusions that
>> >> it would.
>> >>
>> >> (gdb) l *( xfs_write+0x2cc)
>> >> 0xffffffff8124342d is in xfs_write (fs/xfs/linux-2.6/xfs_lrw.c:597).
>> >> 592 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!need_i_mutex && (map=
ping->nrpages || pos
>> >> > xip->i_size)) {
>> >> 593 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_iunlo=
ck(xip, XFS_ILOCK_EXCL|iolock);
>> >> 594 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iolock =
=3D XFS_IOLOCK_EXCL;
>> >> 595 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 need_i_mu=
tex =3D 1;
>> >> 596 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_loc=
k(&inode->i_mutex);
>> >> 597 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ilock=
(xip, XFS_ILOCK_EXCL|iolock);
>> >
>> > Make sense. Can you run 'l *(xfs_ilock+0x2c)' as well? I just need to
>> > confirm which lock it has blocked on.
>>
>> (gdb) l *(xfs_ilock+0x2c)
>> 0xffffffff81221001 is in xfs_ilock (fs/xfs/linux-2.6/mrlock.h:48).
>> 43 =A0 =A0 =A0 =A0 =A0 =A0 =A0down_read_nested(&mrp->mr_lock, subclass);
>> 44 =A0 =A0 =A0}
>> 45
>> 46 =A0 =A0 =A0static inline void mrupdate_nested(mrlock_t *mrp, int subc=
lass)
>> 47 =A0 =A0 =A0{
>> 48 =A0 =A0 =A0 =A0 =A0 =A0 =A0down_write_nested(&mrp->mr_lock, subclass);
>> 49 =A0 =A0 =A0#ifdef DEBUG
>> 50 =A0 =A0 =A0 =A0 =A0 =A0 =A0mrp->mr_writer =3D 1;
>> 51 =A0 =A0 =A0#endif
>> 52 =A0 =A0 =A0}
>
> OK, that doesn't help - it followed into the inline function
> rather than telling me which of the two calls in the function it
> was. I guess I'll need the disassembly output to work it out.
> Can you send the output of "disass xfs_ilock" instead? Thanks.

Looks like it's the first one.

(gdb) disass xfs_ilock
Dump of assembler code for function xfs_ilock:
0xffffffff81220fd5 <xfs_ilock+0>:       push   %rbp
0xffffffff81220fd6 <xfs_ilock+1>:       test   $0x1,%sil
0xffffffff81220fda <xfs_ilock+5>:       mov    %rsp,%rbp
0xffffffff81220fdd <xfs_ilock+8>:       push   %r14
0xffffffff81220fdf <xfs_ilock+10>:      push   %r13
0xffffffff81220fe1 <xfs_ilock+12>:      mov    %rdi,%r13
0xffffffff81220fe4 <xfs_ilock+15>:      push   %r12
0xffffffff81220fe6 <xfs_ilock+17>:      mov    %esi,%r12d
0xffffffff81220fe9 <xfs_ilock+20>:      push   %rbx
0xffffffff81220fea <xfs_ilock+21>:      je     0xffffffff81221003 <xfs_iloc=
k+46>
0xffffffff81220fec <xfs_ilock+23>:      and    $0xff0000,%esi
0xffffffff81220ff2 <xfs_ilock+29>:      lea    0xe8(%rdi),%rdi
0xffffffff81220ff9 <xfs_ilock+36>:      shr    $0x10,%esi
0xffffffff81220ffc <xfs_ilock+39>:      callq  0xffffffff8105b725
<down_write_nested>
0xffffffff81221001 <xfs_ilock+44>:      jmp    0xffffffff8122101e <xfs_iloc=
k+73>
0xffffffff81221003 <xfs_ilock+46>:      test   $0x2,%sil
0xffffffff81221007 <xfs_ilock+50>:      je     0xffffffff8122101e <xfs_iloc=
k+73>
0xffffffff81221009 <xfs_ilock+52>:      and    $0xff0000,%esi
0xffffffff8122100f <xfs_ilock+58>:      lea    0xe8(%rdi),%rdi
0xffffffff81221016 <xfs_ilock+65>:      shr    $0x10,%esi
0xffffffff81221019 <xfs_ilock+68>:      callq  0xffffffff8105b792
<down_read_nested>
0xffffffff8122101e <xfs_ilock+73>:      test   $0x4,%r12b
0xffffffff81221022 <xfs_ilock+77>:      je     0xffffffff81221038 <xfs_iloc=
k+99>
0xffffffff81221024 <xfs_ilock+79>:      mov    %r12d,%esi
0xffffffff81221027 <xfs_ilock+82>:      lea    0x88(%r13),%rdi
0xffffffff8122102e <xfs_ilock+89>:      shr    $0x18,%esi
0xffffffff81221031 <xfs_ilock+92>:      callq  0xffffffff8105b725
<down_write_nested>
0xffffffff81221036 <xfs_ilock+97>:      jmp    0xffffffff81221050
<xfs_ilock+123>
0xffffffff81221038 <xfs_ilock+99>:      test   $0x8,%r12b
0xffffffff8122103c <xfs_ilock+103>:     je     0xffffffff81221050
<xfs_ilock+123>
0xffffffff8122103e <xfs_ilock+105>:     mov    %r12d,%esi
0xffffffff81221041 <xfs_ilock+108>:     lea    0x88(%r13),%rdi
0xffffffff81221048 <xfs_ilock+115>:     shr    $0x18,%esi
0xffffffff8122104b <xfs_ilock+118>:     callq  0xffffffff8105b792
<down_read_nested>
0xffffffff81221050 <xfs_ilock+123>:     cmpl   $0x0,0x863891(%rip)
   # 0xffffffff81a848e8
0xffffffff81221057 <xfs_ilock+130>:     mov    0x8(%rbp),%r14
0xffffffff8122105b <xfs_ilock+134>:     je     0xffffffff8122107e
<xfs_ilock+169>
0xffffffff8122105d <xfs_ilock+136>:     mov    0x86389c(%rip),%rbx
   # 0xffffffff81a84900
0xffffffff81221064 <xfs_ilock+143>:     test   %rbx,%rbx
0xffffffff81221067 <xfs_ilock+146>:     je     0xffffffff8122107e
<xfs_ilock+169>
0xffffffff81221069 <xfs_ilock+148>:     mov    %r14,%rdx
0xffffffff8122106c <xfs_ilock+151>:     mov    %r12d,%esi
0xffffffff8122106f <xfs_ilock+154>:     mov    %r13,%rdi
0xffffffff81221072 <xfs_ilock+157>:     callq  *(%rbx)
0xffffffff81221074 <xfs_ilock+159>:     add    $0x8,%rbx
0xffffffff81221078 <xfs_ilock+163>:     cmpq   $0x0,(%rbx)
0xffffffff8122107c <xfs_ilock+167>:     jmp    0xffffffff81221067
<xfs_ilock+146>
0xffffffff8122107e <xfs_ilock+169>:     pop    %rbx
0xffffffff8122107f <xfs_ilock+170>:     pop    %r12
0xffffffff81221081 <xfs_ilock+172>:     pop    %r13
0xffffffff81221083 <xfs_ilock+174>:     pop    %r14
0xffffffff81221085 <xfs_ilock+176>:     leaveq
0xffffffff81221086 <xfs_ilock+177>:     retq
---Type <return> to continue, or q <return> to quit---
End of assembler dump.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
