Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A0C47F7E
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 08:13:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0D9C304053
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 06:13:27 -0800 (PST)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	ReFthUegiwHeCJK9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 06:13:25 -0800 (PST)
Received: by mail-wi0-f181.google.com with SMTP id r20so2464031wiv.2
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 06:13:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150216141039.GA48651@bfoster.bfoster>
References: <CAF1in6QW=PS0qfBAtQZHC23r+WVAXv5TLxFAr0r6RfTNiOnXcQ@mail.gmail.com>
	<20150216141039.GA48651@bfoster.bfoster>
Date: Wed, 18 Feb 2015 11:13:23 -0300
Message-ID: <CAF1in6RXO_=KkQ8VyzoyNGH_F4zk5J+cUeCdwic-muHL9V7ydw@mail.gmail.com>
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 990 of file
	fs/xfs/xfs_ialloc.c
From: Pablo Silva <psilvao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8617562233514745205=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============8617562233514745205==
Content-Type: multipart/alternative; boundary=047d7b8743f821ad02050f5d6c9a

--047d7b8743f821ad02050f5d6c9a
Content-Type: text/plain; charset=UTF-8

Hi Brian!

 Thanks for your time!, i've just to run xfs_repair -n the result you can
see --> http://pastebin.centos.org/16106/ and as you can see there was
problems, but why this problems occurs?, we have xfs partition used for one
KVM where running Amanda with Centos 7, perhaps it was a bad configuration
inside KVM or perhaps a bug?, the host server is running centos 6

[root@vtl ~]# uname -a
Linux vtl.areaprod.b2b 2.6.32-504.8.1.el6.x86_64 #1 SMP Wed Jan 28 21:11:36
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux


But the KVM running centos 7

Linux amanda 3.10.0-123.8.1.el7.x86_64 #1 SMP Mon Sep 22 19:06:58 UTC 2014
x86_64 x86_64 x86_64 GNU/Linux

The KVM config is this --> http://pastebin.centos.org/16111/

And /etc/fstab is this---> http://pastebin.centos.org/16116/


Thanks in advance, for any hint.

-Pablo


On Mon, Feb 16, 2015 at 11:10 AM, Brian Foster <bfoster@redhat.com> wrote:

> On Fri, Feb 13, 2015 at 03:44:57PM -0300, Pablo Silva wrote:
> > Hi !
> >
> >     We have a server with centos 6.6, kernel version:
> > 2.6.32-431.17.1.el6.x86_64, where we got the following message:
> >
> > Feb 12 19:22:15 vtl kernel:
> > Feb 12 19:22:15 vtl kernel: Pid: 3502, comm: touch Not tainted
> > 2.6.32-431.17.1.el6.x86_64 #1
> > Feb 12 19:22:15 vtl kernel: Call Trace:
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa041ae5f>] ?
> > xfs_error_report+0x3f/0x50 [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ? xfs_ialloc+0x60/0x6e0
> [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa041ec2e>] ?
> xfs_dialloc+0x43e/0x850 [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ? xfs_ialloc+0x60/0x6e0
> [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa044007a>] ?
> > kmem_zone_zalloc+0x3a/0x50 [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa043b814>] ?
> > xfs_dir_ialloc+0x74/0x2b0 [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa043d900>] ?
> xfs_create+0x440/0x640 [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa044aa5d>] ?
> xfs_vn_mknod+0xad/0x1c0 [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffffa044aba0>] ?
> xfs_vn_create+0x10/0x20 [xfs]
> > Feb 12 19:22:15 vtl kernel: [<ffffffff81198086>] ? vfs_create+0xe6/0x110
> > Feb 12 19:22:15 vtl kernel: [<ffffffff8119bb9e>] ?
> do_filp_open+0xa8e/0xd20
> > Feb 12 19:22:15 vtl kernel: [<ffffffff811a7ea2>] ? alloc_fd+0x92/0x160
> > Feb 12 19:22:15 vtl kernel: XFS: Internal error
> > XFS_WANT_CORRUPTED_GOTO at line 990 of file fs/xfs/xfs_ialloc.c.
> > Caller 0xffffffffa0422980
> >
>
>         /*
>          * None left in the last group, search the whole AG
>          */
>         error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
>         if (error)
>                 goto error0;
>         XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
>
>         for (;;) {
>                 error = xfs_inobt_get_rec(cur, &rec, &i);
>                 if (error)
>                         goto error0;
>                 XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
>                 if (rec.ir_freecount > 0)
>                         break;
>                 error = xfs_btree_increment(cur, 0, &i);
>                 if (error)
>                         goto error0;
> --->            XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
>         }
>
> That corresponds to the check above. This code is part of the inode
> allocator where we expect an AG to have free inodes and we're doing a
> brute force search for a record. Apparently we go off the AG or some
> other problem occurs before we find a free inode record.
>
> Does 'xfs_repair -n' report any problems with this fs? Have there been
> any other storage errors reported in the logs? Is the problem
> reproducible or was it a one off occurrence?
>
> Brian
>
> > I can't find more information for this..., perhaps a bug or other
> > thing ..., welcome any hint for to research..
> >
> > Thanks in advance!
> >
> > -Pablo
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--047d7b8743f821ad02050f5d6c9a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hi Brian!<br><br></div>=C2=A0Thanks fo=
r your time!, i&#39;ve just to run xfs_repair -n the result you can see --&=
gt; <a href=3D"http://pastebin.centos.org/16106/">http://pastebin.centos.or=
g/16106/</a> and as you can see there was problems, but why this problems o=
ccurs?, we have xfs partition used for one KVM where running Amanda with Ce=
ntos 7, perhaps it was a bad configuration inside KVM or perhaps a bug?, th=
e host server is running centos 6 <br><br>[root@vtl ~]# uname -a<br>Linux v=
tl.areaprod.b2b 2.6.32-504.8.1.el6.x86_64 #1 SMP Wed Jan 28 21:11:36 UTC 20=
15 x86_64 x86_64 x86_64 GNU/Linux<br><br><br></div>But the KVM running cent=
os 7<br><br>Linux amanda 3.10.0-123.8.1.el7.x86_64 #1 SMP Mon Sep 22 19:06:=
58 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux<br><br></div><div>The KVM config=
 is this --&gt; <a href=3D"http://pastebin.centos.org/16111/">http://pasteb=
in.centos.org/16111/</a><br><br></div><div>And /etc/fstab is this---&gt; <a=
 href=3D"http://pastebin.centos.org/16116/">http://pastebin.centos.org/1611=
6/</a><br><br></div><div><br></div>Thanks in advance, for any hint.<br><br>=
</div>-Pablo<br><div><div><br></div></div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Feb 16, 2015 at 11:10 AM, Brian Fost=
er <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_b=
lank">bfoster@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Fri, Feb 13, 2015 at 03:44=
:57PM -0300, Pablo Silva wrote:<br>
&gt; Hi !<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0We have a server with centos 6.6, kernel version:<b=
r>
&gt; 2.6.32-431.17.1.el6.x86_64, where we got the following message:<br>
&gt;<br>
&gt; Feb 12 19:22:15 vtl kernel:<br>
&gt; Feb 12 19:22:15 vtl kernel: Pid: 3502, comm: touch Not tainted<br>
&gt; 2.6.32-431.17.1.el6.x86_64 #1<br>
&gt; Feb 12 19:22:15 vtl kernel: Call Trace:<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa041ae5f&gt;] ?<br>
&gt; xfs_error_report+0x3f/0x50 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa0422980&gt;] ? xfs_ialloc+0x=
60/0x6e0 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa041ec2e&gt;] ? xfs_dialloc+0=
x43e/0x850 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa0422980&gt;] ? xfs_ialloc+0x=
60/0x6e0 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044007a&gt;] ?<br>
&gt; kmem_zone_zalloc+0x3a/0x50 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa043b814&gt;] ?<br>
&gt; xfs_dir_ialloc+0x74/0x2b0 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa043d900&gt;] ? xfs_create+0x=
440/0x640 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044aa5d&gt;] ? xfs_vn_mknod+=
0xad/0x1c0 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044aba0&gt;] ? xfs_vn_create=
+0x10/0x20 [xfs]<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffff81198086&gt;] ? vfs_create+0x=
e6/0x110<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffff8119bb9e&gt;] ? do_filp_open+=
0xa8e/0xd20<br>
&gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffff811a7ea2&gt;] ? alloc_fd+0x92=
/0x160<br>
&gt; Feb 12 19:22:15 vtl kernel: XFS: Internal error<br>
&gt; XFS_WANT_CORRUPTED_GOTO at line 990 of file fs/xfs/xfs_ialloc.c.<br>
&gt; Caller 0xffffffffa0422980<br>
&gt;<br>
<br>
</div></div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* None left in the last group, search the=
 whole AG<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 error =3D xfs_inobt_lookup(cur, 0, XFS_LOOKUP_G=
E, &amp;i);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (error)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 XFS_WANT_CORRUPTED_GOTO(i =3D=3D 1, error0);<br=
>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (;;) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 error =3D xfs_inobt=
_get_rec(cur, &amp;rec, &amp;i);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (error)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto error0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 XFS_WANT_CORRUPTED_=
GOTO(i =3D=3D 1, error0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rec.ir_freecoun=
t &gt; 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 error =3D xfs_btree=
_increment(cur, 0, &amp;i);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (error)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto error0;<br>
---&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 XFS_WANT_CORRUPTED_GOTO(i =
=3D=3D 1, error0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
That corresponds to the check above. This code is part of the inode<br>
allocator where we expect an AG to have free inodes and we&#39;re doing a<b=
r>
brute force search for a record. Apparently we go off the AG or some<br>
other problem occurs before we find a free inode record.<br>
<br>
Does &#39;xfs_repair -n&#39; report any problems with this fs? Have there b=
een<br>
any other storage errors reported in the logs? Is the problem<br>
reproducible or was it a one off occurrence?<br>
<br>
Brian<br>
<span class=3D""><br>
&gt; I can&#39;t find more information for this..., perhaps a bug or other<=
br>
&gt; thing ..., welcome any hint for to research..<br>
&gt;<br>
&gt; Thanks in advance!<br>
&gt;<br>
&gt; -Pablo<br>
<br>
</span>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br></div>

--047d7b8743f821ad02050f5d6c9a--


--===============8617562233514745205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8617562233514745205==--
