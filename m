Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9CBA7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 11:01:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B0A130405F
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 09:01:29 -0700 (PDT)
Received: from mail-we0-f174.google.com (mail-we0-f174.google.com
	[74.125.82.174]) by cuda.sgi.com with ESMTP id vzBfhfoEdhQm0XeI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Sep 2014 09:01:27 -0700 (PDT)
Received: by mail-we0-f174.google.com with SMTP id t60so58087wes.19
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 09:01:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140902220216.GJ20518@dastard>
References: <1408648692-15957-1-git-send-email-bfoster@redhat.com>
	<CAOcd+r32+6gafv5+MCNyNTH1Ncas9CJHHrku+Y=sZefDzzS1Zw@mail.gmail.com>
	<20140825142025.GA10135@bfoster.bfoster>
	<AFED541EB7FA490C8E16DCB81F400B1C@alyakaslap>
	<20140831210507.GA11913@bfoster.bfoster>
	<3476A2CBDE694DC6BD06DBDD15165151@alyakaslap>
	<20140902220216.GJ20518@dastard>
Date: Tue, 16 Sep 2014 19:01:25 +0300
Message-ID: <CAOcd+r1T11WwYdE5TzV=hq2VH3ZkC_JghSkKcyARoYOcXSV7gw@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix double free of trans in log recovery on I/O error
From: Alex Lyakas <alex@zadarastorage.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6543163442587836096=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

--===============6543163442587836096==
Content-Type: multipart/alternative; boundary=001a1134894815676c050330dd1b

--001a1134894815676c050330dd1b
Content-Type: text/plain; charset=UTF-8

Hi Dave,

On Wed, Sep 3, 2014 at 1:02 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 02, 2014 at 12:51:35PM +0300, Alex Lyakas wrote:
> > Hi Brian, Dave,
> > I tested this patch on 3.8.13 kernel with the scenario I described
> > in http://oss.sgi.com/pipermail/xfs/2014-August/037637.html, but I
> > still see the issue.
> > I placed the metadump at
> https://drive.google.com/file/d/0ByBy89zr3kJNV2UxMERNTkE4aHM/edit?usp=sharing
> >
> > During log recovery, 3 IO errors are encountered:
> > [  340.381199] XFS (dm-0): Mounting Filesystem
> > [  340.439897] XFS (dm-0): Sleep 10s before xlog_do_recover
> > [  350.440143] XFS (dm-0): Starting recovery (logdev: internal)
> > [  351.584647] XFS (dm-0): metadata I/O error: block 0x1
> > ("xlog_recover_iodone") error 28 numblks 1
> > [  351.584660] XFS (dm-0): metadata I/O error: block 0x40
> > ("xlog_recover_iodone") error 28 numblks 16
> > [  351.584665] XFS (dm-0): xfs_do_force_shutdown(0x1) called from
> > line 377 of file
> > /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.  Return
> > address = 0xffffffffa0372728
> > [  351.584969] XFS (dm-0): I/O Error Detected. Shutting down filesystem
> > [  351.584970] XFS (dm-0): Please umount the filesystem and rectify
> > the problem(s)
> > [  351.585047] XFS (dm-0): metadata I/O error: block 0x1e00040
> > ("xlog_recover_iodone") error 28 numblks 16
> > [  351.585050] XFS (dm-0): xfs_do_force_shutdown(0x1) called from
> > line 377 of file
> > /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.  Return
> > address = 0xffffffffa0372728
> > [  351.585068] XFS (dm-0): log mount/recovery failed: error 28
> > [  351.585332] XFS (dm-0): log mount failed
> >
> > Two IO error callbacks are handled before XFS is unmounted, but the
> > last one crashes with stack[1].
> >
> > Do I need some or all of the 9 patches that Dave posted? (They do
> > not apply to my kernel, so I need to apply them by hand).
>
> No, I suspect that there are other problems that have been fixed
> since 3.8 that you are missing. e.g.
>
> 9c23ecc xfs: unmount does not wait for shutdown during unmount
>
I applied this patch, and on top of that applied your patch "[PATCH 1/9]
xfs: synchronous buffer IO needs a reference". However, the log recovery
problem still reproduces.

At least with the 9c23ecc patch, the unmount-while-IO-error problems that I
reported long ago seem to be fixed.

Thanks,
Alex.



>
> THere's bound to be others, so you're really going to need to look
> at the differences between 3.8 and a current mainline to determine
> what other patches you are going to need...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a1134894815676c050330dd1b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<br><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On Wed, Sep 3, 2014 at 1:02 AM, Dave Chinner <span dir=3D"ltr">=
&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbi=
t.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex"><span class=3D"">On Tue, Sep 02, 2014 at 12:51:35PM +0300, Alex Lyaka=
s wrote:<br>
&gt; Hi Brian, Dave,<br>
</span><div><div class=3D"h5">&gt; I tested this patch on 3.8.13 kernel wit=
h the scenario I described<br>
&gt; in <a href=3D"http://oss.sgi.com/pipermail/xfs/2014-August/037637.html=
" target=3D"_blank">http://oss.sgi.com/pipermail/xfs/2014-August/037637.htm=
l</a>, but I<br>
&gt; still see the issue.<br>
&gt; I placed the metadump at <a href=3D"https://drive.google.com/file/d/0B=
yBy89zr3kJNV2UxMERNTkE4aHM/edit?usp=3Dsharing" target=3D"_blank">https://dr=
ive.google.com/file/d/0ByBy89zr3kJNV2UxMERNTkE4aHM/edit?usp=3Dsharing</a><b=
r>
&gt;<br>
&gt; During log recovery, 3 IO errors are encountered:<br>
&gt; [=C2=A0 340.381199] XFS (dm-0): Mounting Filesystem<br>
&gt; [=C2=A0 340.439897] XFS (dm-0): Sleep 10s before xlog_do_recover<br>
&gt; [=C2=A0 350.440143] XFS (dm-0): Starting recovery (logdev: internal)<b=
r>
&gt; [=C2=A0 351.584647] XFS (dm-0): metadata I/O error: block 0x1<br>
&gt; (&quot;xlog_recover_iodone&quot;) error 28 numblks 1<br>
&gt; [=C2=A0 351.584660] XFS (dm-0): metadata I/O error: block 0x40<br>
&gt; (&quot;xlog_recover_iodone&quot;) error 28 numblks 16<br>
&gt; [=C2=A0 351.584665] XFS (dm-0): xfs_do_force_shutdown(0x1) called from=
<br>
&gt; line 377 of file<br>
&gt; /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.=C2=A0 Return<br>
&gt; address =3D 0xffffffffa0372728<br>
&gt; [=C2=A0 351.584969] XFS (dm-0): I/O Error Detected. Shutting down file=
system<br>
&gt; [=C2=A0 351.584970] XFS (dm-0): Please umount the filesystem and recti=
fy<br>
&gt; the problem(s)<br>
&gt; [=C2=A0 351.585047] XFS (dm-0): metadata I/O error: block 0x1e00040<br=
>
&gt; (&quot;xlog_recover_iodone&quot;) error 28 numblks 16<br>
&gt; [=C2=A0 351.585050] XFS (dm-0): xfs_do_force_shutdown(0x1) called from=
<br>
&gt; line 377 of file<br>
&gt; /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.=C2=A0 Return<br>
&gt; address =3D 0xffffffffa0372728<br>
&gt; [=C2=A0 351.585068] XFS (dm-0): log mount/recovery failed: error 28<br=
>
&gt; [=C2=A0 351.585332] XFS (dm-0): log mount failed<br>
&gt;<br>
&gt; Two IO error callbacks are handled before XFS is unmounted, but the<br=
>
&gt; last one crashes with stack[1].<br>
&gt;<br>
&gt; Do I need some or all of the 9 patches that Dave posted? (They do<br>
&gt; not apply to my kernel, so I need to apply them by hand).<br>
<br>
</div></div>No, I suspect that there are other problems that have been fixe=
d<br>
since 3.8 that you are missing. e.g.<br>
<br>
9c23ecc xfs: unmount does not wait for shutdown during unmount<br></blockqu=
ote><div>I applied this patch, and on top of that applied your patch &quot;=
[PATCH 1/9] xfs: synchronous buffer IO needs a reference&quot;. However, th=
e log recovery problem still reproduces.<br><br></div><div>At least with th=
e 9c23ecc patch, the unmount-while-IO-error problems that I reported long a=
go seem to be fixed. <br><br></div><div>Thanks,<br></div><div>Alex.<br><br>=
</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
THere&#39;s bound to be others, so you&#39;re really going to need to look<=
br>
at the differences between 3.8 and a current mainline to determine<br>
what other patches you are going to need...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D""><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div></div>

--001a1134894815676c050330dd1b--


--===============6543163442587836096==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6543163442587836096==--
