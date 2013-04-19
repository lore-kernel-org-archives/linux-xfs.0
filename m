Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A27BA29DFA
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 11:47:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22742AC002
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 09:47:49 -0700 (PDT)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	9G5JeWRrEvb6dLmF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 09:47:46 -0700 (PDT)
Received: by mail-ie0-f170.google.com with SMTP id at1so1320718iec.29
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 09:47:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51716DCB.4060407@sandeen.net>
References: <516C89DF.4070904@redhat.com>
	<CADFMGuK3cPSmqZoMdFSSqOnUz3GLv+c01xXHDhzv9_dfUNUPPA@mail.gmail.com>
	<CADFMGu+XD=-NJm3CAsnKpiMWykPj67t2LHgtxkPpyTpVmG3LDA@mail.gmail.com>
	<CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
	<BA50C18A-BE51-4658-B05E-3EDB0F11BE36@sandeen.net>
	<CADFMGuKfXwY=Z9dg6+wyX7mKzppu1hQhsqxcr9Fd=DjP4hii9w@mail.gmail.com>
	<CADFMGuLDwde8te0Cs4-T9fdVmq2v22fmSTgkYbULHS3voHzw6A@mail.gmail.com>
	<CADFMGuKmmJCz+FxsFL9KegqzNhhHsG2ZbVjrwCDyNCh1R_Zgpw@mail.gmail.com>
	<516FDBDE.1070406@redhat.com>
	<CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
	<51705EC4.4000306@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
	<CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
Date: Sat, 20 Apr 2013 00:47:46 +0800
Message-ID: <CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9147847137995757394=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============9147847137995757394==
Content-Type: multipart/alternative; boundary=90e6ba3fcd278625cb04dab97aba

--90e6ba3fcd278625cb04dab97aba
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Eric,
Here's the server info:
[root@10.23.72.95 ~]# rpm -qa|grep kernel
kernel-debug-debuginfo-2.6.32-279.19.1.el6.x86_64
kernel-headers-2.6.32-279.19.1.el6.x86_64
abrt-addon-kerneloops-2.0.8-6.el6.x86_64
dracut-kernel-004-283.el6.noarch
kernel-debuginfo-common-x86_64-2.6.32-279.19.1.el6.x86_64
kernel-debuginfo-2.6.32-279.19.1.el6.x86_64
kernel-debug-2.6.32-279.19.1.el6.x86_64
kernel-devel-2.6.32-279.19.1.el6.x86_64
libreport-plugin-kerneloops-2.0.9-5.el6.x86_64
kernel-firmware-2.6.32-279.19.1.el6.noarch
kernel-2.6.32-279.19.1.el6.x86_64
kernel-debug-devel-2.6.32-279.19.1.el6.x86_64
[root@10.23.72.95 ~]# uname -a
Linux 10.23.72.95 2.6.32-279.19.1.el6.x86_64 #1 SMP Fri Apr 19 10:44:52 CST
2013 x86_64 x86_64 x86_64 GNU/Linux
[root@10.23.72.95 ~]#

The kernel code looks like:
__rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
{
        struct rwsem_waiter *waiter;
        struct task_struct *tsk;
        int woken;

        waiter =3D list_entry(sem->wait_list.next, struct rwsem_waiter, lis=
t);

        if (!wakewrite) {
                if (waiter->flags & RWSEM_WAITING_FOR_WRITE)
                        goto out;
                goto dont_wake_writers;
        }

        /* if we are allowed to wake writers try to grant a single write
lock
         * if there's a writer at the front of the queue
         * - we leave the 'waiting count' incremented to signify potential
         *   contention
         */
        if (waiter->flags & RWSEM_WAITING_FOR_WRITE) {
                sem->activity =3D -1;
                list_del(&waiter->list);
                tsk =3D waiter->task;
                /* Don't touch waiter after ->task has been NULLed */
                smp_mb();
                waiter->task =3D NULL;
                wake_up_process(tsk);
                put_task_struct(tsk);
                goto out;
        }

        /* grant an infinite number of read locks to the front of the queue
*/
 dont_wake_writers:
        woken =3D 0;
        while (waiter->flags & RWSEM_WAITING_FOR_READ) {
                struct list_head *next =3D waiter->list.next;

                list_del(&waiter->list);
                tsk =3D waiter->task;
                smp_mb();
                waiter->task =3D NULL;
                wake_up_process(tsk);
                put_task_struct(tsk);
                woken++;
                if (list_empty(&sem->wait_list))
                        break;
                waiter =3D list_entry(next, struct rwsem_waiter, list);
        }

        sem->activity +=3D woken;

 out:
        return sem;
}

I use srpm because I want to apply the trace path. Can you help to provide
the official 279.19.1 srpm link.
Thank you.


2013/4/20 Eric Sandeen <sandeen@sandeen.net>

> On 4/19/13 8:18 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Dear Eric,
> > If it's racing issue where the lock is introduced? I want to study the
> code from you. Thank you.
> >
>
> essentially:
>
> xfs_remove()
> {
> ...
>         xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
> ...
>         xfs_droplink()
>
> You are 100% sure that you were running the 279.19.1 kernel?
>
> (I'm not very familiar with Oracle's clone of RHEL - I assume that they
> have copied all of Red Hat's work verbatim, but I have not looked)
>
> Can you verify that in:
>
> __rwsem_do_wake()
>
> the undo target looks like:
>
>   out:
>         return sem;
>
>
>         /* undo the change to the active count, but check for a transitio=
n
>          * 1->0 */
>   undo:
>         if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) &
> RWSEM_ACTIVE_MASK)
>                 goto out;
>         goto try_again;
>
>
> thanks,
> -Eric
>
> > 2013/4/19 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gma=
il.com>>
> >
> >     Sure the serious thing here is that it corrupt the unlinked list.
> The inode 0x1bd33 which trigger xfs shutdown is not  0x6b133.
> >
> >
> >     2013/4/19 Eric Sandeen <sandeen@sandeen.net <mailto:
> sandeen@sandeen.net>>
> >
> >         On 4/19/13 4:41 AM, =B7=FB=D3=C0=CC=CE wrote:
> >         > Dear Brian and Eric,
> >         >
> >         > kernel kernel-2.6.32-279.19.1.el6.x86_64.rpm <
> http://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/kerne=
l-2.6.32-279.19.1.el6.x86_64.rpm>
> still have this problem
> >         > I build the kernel from this srpm
> >         >
> https://oss.oracle.com/ol6/SRPMS-updates/kernel-2.6.32-279.19.1.el6.src.r=
pm
> >         >
> >         > today the shutdown happens again during test.
> >         > Seelogs bellow:
> >         >
> >         > /var/log/message
> >         > Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_iunlink_remove:
> xfs_inotobp() returned error 22.
> >         > Apr 19 16:40:05 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree
> returned error 22
> >         > Apr 19 16:40:05 10 kernel: XFS (sdb):
> xfs_do_force_shutdown(0x1) called from line 1184 of file
> fs/xfs/xfs_vnodeops.c.  Return address =3D 0xffffffffa02d4bda
> >         > Apr 19 16:40:05 10 kernel: XFS (sdb): I/O Error Detected.
> Shutting down filesystem
> >         > Apr 19 16:40:05 10 kernel: XFS (sdb): Please umount the
> filesystem and rectify the problem(s)
> >         > Apr 19 16:40:07 10 kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> >         > Apr 19 16:40:37 10 kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> >         >
> >         > systemtap script output:
> >         > --- xfs_imap -- module("xfs").function("xfs_imap@fs/xfs/xfs_i=
alloc.c:1257").return
> -- return=3D0x16
> >         > vars: mp=3D0xffff88101801e800 tp=3D0xffff880ff143ac70
> ino=3D0xffffffff imap=3D0xffff88100e93bc08 flags=3D0x0 agbno=3D? agino=3D=
? agno=3D?
> blks_per_cluster=3D? chunk_agbno=3D? cluster_agbno=3D? error=3D? offset=
=3D?
> offset_agbno=3D? __func__=3D[...]
> >         > mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20
> >         > mp->m_sb: sb_agcount =3D 0x1c, sb_agblocks =3D 0xffffff0,
> sb_inopblog =3D 0x4, sb_agblklog =3D 0x1c, sb_dblocks =3D 0x1b4900000
> >         > imap: im_blkno =3D 0x0, im_len =3D 0xe778, im_boffset =3D 0xd=
997
> >         > kernel backtrace:
> >         > Returning from:  0xffffffffa02b4260 : xfs_imap+0x0/0x280 [xfs=
]
> >         > Returning to  :  0xffffffffa02b9d59 : xfs_inotobp+0x49/0xc0
> [xfs]
> >         >  0xffffffffa02b9ec1 : xfs_iunlink_remove+0xf1/0x360 [xfs]
> >         >  0xffffffff814ede89
> >         >  0x0 (inexact)
> >         > user backtrace:
> >         >  0x3ec260e5ad [/lib64/libpthread-2.12.so <
> http://libpthread-2.12.so> <http://libpthread-2.12.so>+0xe5ad/0x219000]
> >         >
> >         > --- xfs_iunlink_remove --
> module("xfs").function("xfs_iunlink_remove@fs/xfs/xfs_inode.c:1681").retu=
rn
> -- return=3D0x16
> >         > vars: tp=3D0xffff880ff143ac70 ip=3D0xffff8811ed111000 next_in=
o=3D?
> mp=3D? agi=3D? dip=3D? agibp=3D? ibp=3D? agno=3D? agino=3D? next_agino=3D=
? last_ibp=3D?
> last_dip=3D0xffff881000000001 bucket_index=3D? offset=3D?
> last_offset=3D0xffffffffffff8811 error=3D? __func__=3D[...]
> >         > ip: i_ino =3D 0x1bd33, i_flags =3D 0x0
> >         > ip->i_d: di_nlink =3D 0x0, di_gen =3D 0x53068791
> >         >
> >         > debugfs events trace:
> >         >
> https://docs.google.com/file/d/0B7n2C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Dsh=
aring
> >
> >         Same issue, one file was unlinked twice in a race:
> >
> >         =3D=3D=3D ino 0x6b133 =3D=3D=3D
> >                    <...>-4477  [003]  2721.176790: xfs_iunlink: dev 8:1=
6
> ino 0x6b133
> >                    <...>-4477  [003]  2721.176839: xfs_iunlink_remove:
> dev 8:16 ino 0x6b133
> >                    <...>-4477  [009]  3320.127227: xfs_iunlink: dev 8:1=
6
> ino 0x6b133
> >                    <...>-4477  [001]  3320.141126: xfs_iunlink_remove:
> dev 8:16 ino 0x6b133
> >                    <...>-4477  [003]  7973.136368: xfs_iunlink: dev 8:1=
6
> ino 0x6b133
> >                    <...>-4479  [018]  7973.158457: xfs_iunlink: dev 8:1=
6
> ino 0x6b133
> >                    <...>-4479  [018]  7973.158497: xfs_iunlink_remove:
> dev 8:16 ino 0x6b133
> >
> >         -Eric
> >
> >
> >
> >
> >     --
> >     =B7=FB=D3=C0=CC=CE
> >
> >
> >
> >
> > --
> > =B7=FB=D3=C0=CC=CE
>
>


--=20
=B7=FB=D3=C0=CC=CE

--90e6ba3fcd278625cb04dab97aba
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi Eric,<br></div>Here&#39;s the server inf=
o:<br>[<a href=3D"mailto:root@10.23.72.95">root@10.23.72.95</a> ~]# rpm -qa=
|grep kernel<br>kernel-debug-debuginfo-2.6.32-279.19.1.el6.x86_64<br>kernel=
-headers-2.6.32-279.19.1.el6.x86_64<br>
abrt-addon-kerneloops-2.0.8-6.el6.x86_64<br>dracut-kernel-004-283.el6.noarc=
h<br>kernel-debuginfo-common-x86_64-2.6.32-279.19.1.el6.x86_64<br>kernel-de=
buginfo-2.6.32-279.19.1.el6.x86_64<br>kernel-debug-2.6.32-279.19.1.el6.x86_=
64<br>
kernel-devel-2.6.32-279.19.1.el6.x86_64<br>libreport-plugin-kerneloops-2.0.=
9-5.el6.x86_64<br>kernel-firmware-2.6.32-279.19.1.el6.noarch<br>kernel-2.6.=
32-279.19.1.el6.x86_64<br>kernel-debug-devel-2.6.32-279.19.1.el6.x86_64<br>
[<a href=3D"mailto:root@10.23.72.95">root@10.23.72.95</a> ~]# uname -a<br>L=
inux 10.23.72.95 2.6.32-279.19.1.el6.x86_64 #1 SMP Fri Apr 19 10:44:52 CST =
2013 x86_64 x86_64 x86_64 GNU/Linux<br>[<a href=3D"mailto:root@10.23.72.95"=
>root@10.23.72.95</a> ~]# <br>
<br>The kernel code looks like:<br>__rwsem_do_wake(struct rw_semaphore *sem=
, int wakewrite)<br>{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct =
rwsem_waiter *waiter;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct =
task_struct *tsk;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int woken;<=
br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; waiter =3D list_entry(sem=
-&gt;wait_list.next, struct rwsem_waiter, list);<br>
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!wakewrite) {<br>&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; if (waiter-&gt;flags &amp; RWSEM_WAITING_FOR_WRITE)<br>&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto out;<br>&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; goto dont_wake_writers;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; }<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* if we are allowed =
to wake writers try to grant a single write lock<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * if there&#39;s a writer =
at the front of the queue<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; * - we leave the &#39;waiting count&#39; incremented to signify potentia=
l<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp; content=
ion<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<br>&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (waiter-&gt;flags &amp; RWSEM_WAITING_FOR_=
WRITE) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; sem-&gt;activity =3D -1;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_del(&amp;w=
aiter-&gt;list);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tsk =3D waiter-&gt;task;<br>&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; /* Don&#39;t touch waiter after -&gt;task has been NULLed */<br>&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; smp_mb();<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; waiter-&gt;task =3D NULL;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wake_up_proces=
s(tsk);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; put_task_struct(tsk);<br>&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto ou=
t;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br><br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; /* grant an infinite number of read locks to the =
front of the queue */<br>
&nbsp;dont_wake_writers:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; woke=
n =3D 0;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (waiter-&gt;fl=
ags &amp; RWSEM_WAITING_FOR_READ) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct list_head *ne=
xt =3D waiter-&gt;list.next;<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_del(&amp;waiter-&g=
t;list);<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tsk =3D waiter-&gt;=
task;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; smp_mb();<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; waiter-&gt;task =3D N=
ULL;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; wake_up_process(tsk);<br>&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; put_task_s=
truct(tsk);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; woken++;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; if (list_empty(&amp;sem-&gt;wait_list))<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; w=
aiter =3D list_entry(next, struct rwsem_waiter, list);<br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; }<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; sem-&gt;activity +=3D woken;<br>
<br>&nbsp;out:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return sem;<br=
>}<br><br></div>I use srpm because I want to apply the trace path. Can you =
help to provide the official 279.19.1 srpm link.<br></div>Thank you.<br></d=
iv><div class=3D"gmail_extra"><br><br>
<div class=3D"gmail_quote">2013/4/20 Eric Sandeen <span dir=3D"ltr">&lt;<a =
href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</=
a>&gt;</span><br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On 4/19/13 8:18 AM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Dear Eric,<br>
&gt; If it&#39;s racing issue where the lock is introduced? I want to study=
 the code from you. Thank you.<br>
&gt;<br>
<br>
</div>essentially:<br>
<br>
xfs_remove()<br>
{<br>
...<br>
&nbsp; &nbsp; &nbsp; &nbsp; xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);<br=
>
...<br>
&nbsp; &nbsp; &nbsp; &nbsp; xfs_droplink()<br>
<br>
You are 100% sure that you were running the 279.19.1 kernel?<br>
<br>
(I&#39;m not very familiar with Oracle&#39;s clone of RHEL - I assume that =
they have copied all of Red Hat&#39;s work verbatim, but I have not looked)=
<br>
<br>
Can you verify that in:<br>
<br>
__rwsem_do_wake()<br>
<br>
the undo target looks like:<br>
<br>
&nbsp; out:<br>
&nbsp; &nbsp; &nbsp; &nbsp; return sem;<br>
<br>
<br>
&nbsp; &nbsp; &nbsp; &nbsp; /* undo the change to the active count, but che=
ck for a transition<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* 1-&gt;0 */<br>
&nbsp; undo:<br>
&nbsp; &nbsp; &nbsp; &nbsp; if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem=
) &amp; RWSEM_ACTIVE_MASK)<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; goto out;<br>
&nbsp; &nbsp; &nbsp; &nbsp; goto try_again;<br>
<br>
<br>
thanks,<br>
-Eric<br>
<br>
&gt; 2013/4/19 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com=
">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.com"=
>yongtaofu@gmail.com</a>&gt;&gt;<br>
<div class=3D"im">&gt;<br>
&gt; &nbsp; &nbsp; Sure the serious thing here is that it corrupt the unlin=
ked list. The inode 0x1bd33 which trigger xfs shutdown is not &nbsp;0x6b133=
.<br>
&gt;<br>
&gt;<br>
</div>&gt; &nbsp; &nbsp; 2013/4/19 Eric Sandeen &lt;<a href=3D"mailto:sande=
en@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailto:sandee=
n@sandeen.net">sandeen@sandeen.net</a>&gt;&gt;<br>
<div><div class=3D"h5">&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; On 4/19/13 4:41 AM, =B7=FB=D3=C0=CC=CE wro=
te:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Dear Brian and Eric,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; kernel kernel-2.6.32-279.19.1.el6.x86=
_64.rpm &lt;<a href=3D"http://mirror.linux.duke.edu/pub/centos/6.3/updates/=
x86_64/Packages/kernel-2.6.32-279.19.1.el6.x86_64.rpm" target=3D"_blank">ht=
tp://mirror.linux.duke.edu/pub/centos/6.3/updates/x86_64/Packages/kernel-2.=
6.32-279.19.1.el6.x86_64.rpm</a>&gt; still have this problem<br>

&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I build the kernel from this srpm<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; <a href=3D"https://oss.oracle.com/ol6=
/SRPMS-updates/kernel-2.6.32-279.19.1.el6.src.rpm" target=3D"_blank">https:=
//oss.oracle.com/ol6/SRPMS-updates/kernel-2.6.32-279.19.1.el6.src.rpm</a><b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; today the shutdown happens again duri=
ng test.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Seelogs bellow:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; /var/log/message<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Apr 19 16:40:05 10 kernel: XFS (sdb):=
 xfs_iunlink_remove: xfs_inotobp() returned error 22.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Apr 19 16:40:05 10 kernel: XFS (sdb):=
 xfs_inactive: xfs_ifree returned error 22<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Apr 19 16:40:05 10 kernel: XFS (sdb):=
 xfs_do_force_shutdown(0x1) called from line 1184 of file fs/xfs/xfs_vnodeo=
ps.c. &nbsp;Return address =3D 0xffffffffa02d4bda<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Apr 19 16:40:05 10 kernel: XFS (sdb):=
 I/O Error Detected. Shutting down filesystem<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Apr 19 16:40:05 10 kernel: XFS (sdb):=
 Please umount the filesystem and rectify the problem(s)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Apr 19 16:40:07 10 kernel: XFS (sdb):=
 xfs_log_force: error 5 returned.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Apr 19 16:40:37 10 kernel: XFS (sdb):=
 xfs_log_force: error 5 returned.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; systemtap script output:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; --- xfs_imap -- module(&quot;xfs&quot=
;).function(&quot;xfs_imap@fs/xfs/xfs_ialloc.c:1257&quot;).return -- return=
=3D0x16<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; vars: mp=3D0xffff88101801e800 tp=3D0x=
ffff880ff143ac70 ino=3D0xffffffff imap=3D0xffff88100e93bc08 flags=3D0x0 agb=
no=3D? agino=3D? agno=3D? blks_per_cluster=3D? chunk_agbno=3D? cluster_agbn=
o=3D? error=3D? offset=3D? offset_agbno=3D? __func__=3D[...]<br>

&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; mp: m_agno_log =3D 0x5, m_agino_log =
=3D 0x20<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; mp-&gt;m_sb: sb_agcount =3D 0x1c, sb_=
agblocks =3D 0xffffff0, sb_inopblog =3D 0x4, sb_agblklog =3D 0x1c, sb_dbloc=
ks =3D 0x1b4900000<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; imap: im_blkno =3D 0x0, im_len =3D 0x=
e778, im_boffset =3D 0xd997<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; kernel backtrace:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Returning from: &nbsp;0xffffffffa02b4=
260 : xfs_imap+0x0/0x280 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Returning to &nbsp;: &nbsp;0xffffffff=
a02b9d59 : xfs_inotobp+0x49/0xc0 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp;0xffffffffa02b9ec1 : xfs_iunlin=
k_remove+0xf1/0x360 [xfs]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp;0xffffffff814ede89<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp;0x0 (inexact)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; user backtrace:<br>
</div></div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &nbsp;0x3ec260e5ad [/lib6=
4/<a href=3D"http://libpthread-2.12.so" target=3D"_blank">libpthread-2.12.s=
o</a> &lt;<a href=3D"http://libpthread-2.12.so" target=3D"_blank">http://li=
bpthread-2.12.so</a>&gt; &lt;<a href=3D"http://libpthread-2.12.so" target=
=3D"_blank">http://libpthread-2.12.so</a>&gt;+0xe5ad/0x219000]<br>

<div class=3D"HOEnZb"><div class=3D"h5">&gt; &nbsp; &nbsp; &nbsp; &nbsp; &g=
t;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; --- xfs_iunlink_remove -- module(&quo=
t;xfs&quot;).function(&quot;xfs_iunlink_remove@fs/xfs/xfs_inode.c:1681&quot=
;).return -- return=3D0x16<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; vars: tp=3D0xffff880ff143ac70 ip=3D0x=
ffff8811ed111000 next_ino=3D? mp=3D? agi=3D? dip=3D? agibp=3D? ibp=3D? agno=
=3D? agino=3D? next_agino=3D? last_ibp=3D? last_dip=3D0xffff881000000001 bu=
cket_index=3D? offset=3D? last_offset=3D0xffffffffffff8811 error=3D? __func=
__=3D[...]<br>

&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; ip: i_ino =3D 0x1bd33, i_flags =3D 0x=
0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; ip-&gt;i_d: di_nlink =3D 0x0, di_gen =
=3D 0x53068791<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; debugfs events trace:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; <a href=3D"https://docs.google.com/fi=
le/d/0B7n2C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Dsharing" target=3D"_blank">htt=
ps://docs.google.com/file/d/0B7n2C4T5tfNCREZtdC1yamc0RnM/edit?usp=3Dsharing=
</a><br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Same issue, one file was unlinked twice in=
 a race:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; =3D=3D=3D ino 0x6b133 =3D=3D=3D<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&=
lt;...&gt;-4477 &nbsp;[003] &nbsp;2721.176790: xfs_iunlink: dev 8:16 ino 0x=
6b133<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&=
lt;...&gt;-4477 &nbsp;[003] &nbsp;2721.176839: xfs_iunlink_remove: dev 8:16=
 ino 0x6b133<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&=
lt;...&gt;-4477 &nbsp;[009] &nbsp;3320.127227: xfs_iunlink: dev 8:16 ino 0x=
6b133<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&=
lt;...&gt;-4477 &nbsp;[001] &nbsp;3320.141126: xfs_iunlink_remove: dev 8:16=
 ino 0x6b133<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&=
lt;...&gt;-4477 &nbsp;[003] &nbsp;7973.136368: xfs_iunlink: dev 8:16 ino 0x=
6b133<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&=
lt;...&gt;-4479 &nbsp;[018] &nbsp;7973.158457: xfs_iunlink: dev 8:16 ino 0x=
6b133<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&=
lt;...&gt;-4479 &nbsp;[018] &nbsp;7973.158497: xfs_iunlink_remove: dev 8:16=
 ino 0x6b133<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; -Eric<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--90e6ba3fcd278625cb04dab97aba--


--===============9147847137995757394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9147847137995757394==--
