Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62F1D7F7B
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 09:19:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 51AE68F8037
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 07:19:07 -0800 (PST)
Received: from mail-we0-f175.google.com (mail-we0-f175.google.com
	[74.125.82.175]) by cuda.sgi.com with ESMTP id xb5Ys0YaxVscUjq4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Feb 2015 07:19:05 -0800 (PST)
Received: by wesk11 with SMTP id k11so1743184wes.11
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 07:19:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150218145844.GA62927@bfoster.bfoster>
References: <CAF1in6QW=PS0qfBAtQZHC23r+WVAXv5TLxFAr0r6RfTNiOnXcQ@mail.gmail.com>
	<20150216141039.GA48651@bfoster.bfoster>
	<CAF1in6RXO_=KkQ8VyzoyNGH_F4zk5J+cUeCdwic-muHL9V7ydw@mail.gmail.com>
	<20150218145844.GA62927@bfoster.bfoster>
Date: Wed, 18 Feb 2015 12:19:03 -0300
Message-ID: <CAF1in6TCiwHyt40sm4g0LxKcf5o-=o5cZxMM+x=coSsKJ2hXcQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1327649550627880792=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============1327649550627880792==
Content-Type: multipart/alternative; boundary=047d7b8743f8f52832050f5e564a

--047d7b8743f8f52832050f5e564a
Content-Type: text/plain; charset=UTF-8

The XFS filesystem is only access by kvm guest, the objetive is store the
backup's amanda that running in kvm host.

Now, i answer your questions:

* Have there been any other storage errors reported in the logs?,

ans: No, no information inside /var/log/messages , dmesg about xfs., can
you suggest other log file for to find any information?

* Is the problem reproducible or was it a one off occurrence?

ans: It is only the first occurrence, and the server has a little use,
because we are working yet for to complete the amanda backups, it isn't in
production yet.

-Pablo









On Wed, Feb 18, 2015 at 11:58 AM, Brian Foster <bfoster@redhat.com> wrote:

> On Wed, Feb 18, 2015 at 11:13:23AM -0300, Pablo Silva wrote:
> > Hi Brian!
> >
> >  Thanks for your time!, i've just to run xfs_repair -n the result you can
> > see --> http://pastebin.centos.org/16106/ and as you can see there was
> > problems, but why this problems occurs?, we have xfs partition used for
> one
> > KVM where running Amanda with Centos 7, perhaps it was a bad
> configuration
> > inside KVM or perhaps a bug?, the host server is running centos 6
> >
>
> Can you elaborate? You have an isolated XFS filesystem that is accessed
> by the host system, the kvm guest, or both? How is the fs used?
>
> Also, can you answer my other questions related to how this occurred?
> Are there any other errors in the logs that precede the one below?
>
> I assume the fs shut down at the point of the error below. Has it been
> mounted since? If not, that might be worth a try to replay the log. If
> the log is dirty and replayed, that should be indicated by the output in
> the log at mount time. You'll also want to re-run xfs_repair -n in that
> case.
>
> Brian
>
> > [root@vtl ~]# uname -a
> > Linux vtl.areaprod.b2b 2.6.32-504.8.1.el6.x86_64 #1 SMP Wed Jan 28
> 21:11:36
> > UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> >
> >
> > But the KVM running centos 7
> >
> > Linux amanda 3.10.0-123.8.1.el7.x86_64 #1 SMP Mon Sep 22 19:06:58 UTC
> 2014
> > x86_64 x86_64 x86_64 GNU/Linux
> >
> > The KVM config is this --> http://pastebin.centos.org/16111/
> >
> > And /etc/fstab is this---> http://pastebin.centos.org/16116/
> >
> >
> > Thanks in advance, for any hint.
> >
> > -Pablo
> >
> >
> > On Mon, Feb 16, 2015 at 11:10 AM, Brian Foster <bfoster@redhat.com>
> wrote:
> >
> > > On Fri, Feb 13, 2015 at 03:44:57PM -0300, Pablo Silva wrote:
> > > > Hi !
> > > >
> > > >     We have a server with centos 6.6, kernel version:
> > > > 2.6.32-431.17.1.el6.x86_64, where we got the following message:
> > > >
> > > > Feb 12 19:22:15 vtl kernel:
> > > > Feb 12 19:22:15 vtl kernel: Pid: 3502, comm: touch Not tainted
> > > > 2.6.32-431.17.1.el6.x86_64 #1
> > > > Feb 12 19:22:15 vtl kernel: Call Trace:
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa041ae5f>] ?
> > > > xfs_error_report+0x3f/0x50 [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ?
> xfs_ialloc+0x60/0x6e0
> > > [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa041ec2e>] ?
> > > xfs_dialloc+0x43e/0x850 [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ?
> xfs_ialloc+0x60/0x6e0
> > > [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa044007a>] ?
> > > > kmem_zone_zalloc+0x3a/0x50 [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa043b814>] ?
> > > > xfs_dir_ialloc+0x74/0x2b0 [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa043d900>] ?
> > > xfs_create+0x440/0x640 [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa044aa5d>] ?
> > > xfs_vn_mknod+0xad/0x1c0 [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffffa044aba0>] ?
> > > xfs_vn_create+0x10/0x20 [xfs]
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffff81198086>] ?
> vfs_create+0xe6/0x110
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffff8119bb9e>] ?
> > > do_filp_open+0xa8e/0xd20
> > > > Feb 12 19:22:15 vtl kernel: [<ffffffff811a7ea2>] ?
> alloc_fd+0x92/0x160
> > > > Feb 12 19:22:15 vtl kernel: XFS: Internal error
> > > > XFS_WANT_CORRUPTED_GOTO at line 990 of file fs/xfs/xfs_ialloc.c.
> > > > Caller 0xffffffffa0422980
> > > >
> > >
> > >         /*
> > >          * None left in the last group, search the whole AG
> > >          */
> > >         error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
> > >         if (error)
> > >                 goto error0;
> > >         XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
> > >
> > >         for (;;) {
> > >                 error = xfs_inobt_get_rec(cur, &rec, &i);
> > >                 if (error)
> > >                         goto error0;
> > >                 XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
> > >                 if (rec.ir_freecount > 0)
> > >                         break;
> > >                 error = xfs_btree_increment(cur, 0, &i);
> > >                 if (error)
> > >                         goto error0;
> > > --->            XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
> > >         }
> > >
> > > That corresponds to the check above. This code is part of the inode
> > > allocator where we expect an AG to have free inodes and we're doing a
> > > brute force search for a record. Apparently we go off the AG or some
> > > other problem occurs before we find a free inode record.
> > >
> > > Does 'xfs_repair -n' report any problems with this fs? Have there been
> > > any other storage errors reported in the logs? Is the problem
> > > reproducible or was it a one off occurrence?
> > >
> > > Brian
> > >
> > > > I can't find more information for this..., perhaps a bug or other
> > > > thing ..., welcome any hint for to research..
> > > >
> > > > Thanks in advance!
> > > >
> > > > -Pablo
> > >
> > > > _______________________________________________
> > > > xfs mailing list
> > > > xfs@oss.sgi.com
> > > > http://oss.sgi.com/mailman/listinfo/xfs
> > >
> > >
>

--047d7b8743f8f52832050f5e564a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>The XFS filesystem is only access by kvm gu=
est, the objetive is store the backup&#39;s amanda that running in kvm host=
.<br><br></div>Now, i answer your questions:<br><br>* Have there been any o=
ther storage errors reported in the logs?, <br><br>ans: No, no information =
inside /var/log/messages , dmesg about xfs., can you suggest other log file=
 for to find any information?<br><br>*  Is the problem reproducible or was =
it a one off occurrence?<br><br></div>ans: <span tabindex=3D"-1" id=3D"resu=
lt_box" class=3D"" lang=3D"en"><span class=3D"">It</span> <span class=3D"">=
is only the</span> <span class=3D"">first occurrence, and the server has a =
little use, because we are working yet for to complete the amanda backups, =
it isn&#39;t in production yet.<br><br></span></span></div><span tabindex=
=3D"-1" id=3D"result_box" class=3D"" lang=3D"en"><span class=3D"">-Pablo<br=
></span></span><div><div><span tabindex=3D"-1" id=3D"result_box" class=3D""=
 lang=3D"en"><span class=3D""><br><br><br><br></span></span><div><br><br><b=
r>=C2=A0<br></div></div></div></div><div class=3D"gmail_extra"><br><div cla=
ss=3D"gmail_quote">On Wed, Feb 18, 2015 at 11:58 AM, Brian Foster <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoste=
r@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span =
class=3D"">On Wed, Feb 18, 2015 at 11:13:23AM -0300, Pablo Silva wrote:<br>
&gt; Hi Brian!<br>
&gt;<br>
&gt;=C2=A0 Thanks for your time!, i&#39;ve just to run xfs_repair -n the re=
sult you can<br>
&gt; see --&gt; <a href=3D"http://pastebin.centos.org/16106/" target=3D"_bl=
ank">http://pastebin.centos.org/16106/</a> and as you can see there was<br>
&gt; problems, but why this problems occurs?, we have xfs partition used fo=
r one<br>
&gt; KVM where running Amanda with Centos 7, perhaps it was a bad configura=
tion<br>
&gt; inside KVM or perhaps a bug?, the host server is running centos 6<br>
&gt;<br>
<br>
</span>Can you elaborate? You have an isolated XFS filesystem that is acces=
sed<br>
by the host system, the kvm guest, or both? How is the fs used?<br>
<br>
Also, can you answer my other questions related to how this occurred?<br>
Are there any other errors in the logs that precede the one below?<br>
<br>
I assume the fs shut down at the point of the error below. Has it been<br>
mounted since? If not, that might be worth a try to replay the log. If<br>
the log is dirty and replayed, that should be indicated by the output in<br=
>
the log at mount time. You&#39;ll also want to re-run xfs_repair -n in that=
<br>
case.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; [root@vtl ~]# uname -a<br>
&gt; Linux vtl.areaprod.b2b 2.6.32-504.8.1.el6.x86_64 #1 SMP Wed Jan 28 21:=
11:36<br>
&gt; UTC 2015 x86_64 x86_64 x86_64 GNU/Linux<br>
&gt;<br>
&gt;<br>
&gt; But the KVM running centos 7<br>
&gt;<br>
&gt; Linux amanda 3.10.0-123.8.1.el7.x86_64 #1 SMP Mon Sep 22 19:06:58 UTC =
2014<br>
&gt; x86_64 x86_64 x86_64 GNU/Linux<br>
&gt;<br>
&gt; The KVM config is this --&gt; <a href=3D"http://pastebin.centos.org/16=
111/" target=3D"_blank">http://pastebin.centos.org/16111/</a><br>
&gt;<br>
&gt; And /etc/fstab is this---&gt; <a href=3D"http://pastebin.centos.org/16=
116/" target=3D"_blank">http://pastebin.centos.org/16116/</a><br>
&gt;<br>
&gt;<br>
&gt; Thanks in advance, for any hint.<br>
&gt;<br>
&gt; -Pablo<br>
&gt;<br>
&gt;<br>
&gt; On Mon, Feb 16, 2015 at 11:10 AM, Brian Foster &lt;<a href=3D"mailto:b=
foster@redhat.com">bfoster@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Fri, Feb 13, 2015 at 03:44:57PM -0300, Pablo Silva wrote:<br>
&gt; &gt; &gt; Hi !<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0We have a server with centos 6.6, kernel =
version:<br>
&gt; &gt; &gt; 2.6.32-431.17.1.el6.x86_64, where we got the following messa=
ge:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel:<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: Pid: 3502, comm: touch Not taint=
ed<br>
&gt; &gt; &gt; 2.6.32-431.17.1.el6.x86_64 #1<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: Call Trace:<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa041ae5f&gt;] ?<br>
&gt; &gt; &gt; xfs_error_report+0x3f/0x50 [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa0422980&gt;] ? xfs=
_ialloc+0x60/0x6e0<br>
&gt; &gt; [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa041ec2e&gt;] ?<br>
&gt; &gt; xfs_dialloc+0x43e/0x850 [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa0422980&gt;] ? xfs=
_ialloc+0x60/0x6e0<br>
&gt; &gt; [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044007a&gt;] ?<br>
&gt; &gt; &gt; kmem_zone_zalloc+0x3a/0x50 [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa043b814&gt;] ?<br>
&gt; &gt; &gt; xfs_dir_ialloc+0x74/0x2b0 [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa043d900&gt;] ?<br>
&gt; &gt; xfs_create+0x440/0x640 [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044aa5d&gt;] ?<br>
&gt; &gt; xfs_vn_mknod+0xad/0x1c0 [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044aba0&gt;] ?<br>
&gt; &gt; xfs_vn_create+0x10/0x20 [xfs]<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffff81198086&gt;] ? vfs=
_create+0xe6/0x110<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffff8119bb9e&gt;] ?<br>
&gt; &gt; do_filp_open+0xa8e/0xd20<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: [&lt;ffffffff811a7ea2&gt;] ? all=
oc_fd+0x92/0x160<br>
&gt; &gt; &gt; Feb 12 19:22:15 vtl kernel: XFS: Internal error<br>
&gt; &gt; &gt; XFS_WANT_CORRUPTED_GOTO at line 990 of file fs/xfs/xfs_iallo=
c.c.<br>
&gt; &gt; &gt; Caller 0xffffffffa0422980<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * None left in the last group, =
search the whole AG<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D xfs_inobt_lookup(cur, =
0, XFS_LOOKUP_GE, &amp;i);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (error)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto=
 error0;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0XFS_WANT_CORRUPTED_GOTO(i =3D=3D=
 1, error0);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (;;) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0erro=
r =3D xfs_inobt_get_rec(cur, &amp;rec, &amp;i);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (=
error)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0goto error0;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0XFS_=
WANT_CORRUPTED_GOTO(i =3D=3D 1, error0);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (=
rec.ir_freecount &gt; 0)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0erro=
r =3D xfs_btree_increment(cur, 0, &amp;i);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (=
error)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0goto error0;<br>
&gt; &gt; ---&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 XFS_WANT_CORRUPT=
ED_GOTO(i =3D=3D 1, error0);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt; That corresponds to the check above. This code is part of the ino=
de<br>
&gt; &gt; allocator where we expect an AG to have free inodes and we&#39;re=
 doing a<br>
&gt; &gt; brute force search for a record. Apparently we go off the AG or s=
ome<br>
&gt; &gt; other problem occurs before we find a free inode record.<br>
&gt; &gt;<br>
&gt; &gt; Does &#39;xfs_repair -n&#39; report any problems with this fs? Ha=
ve there been<br>
&gt; &gt; any other storage errors reported in the logs? Is the problem<br>
&gt; &gt; reproducible or was it a one off occurrence?<br>
&gt; &gt;<br>
&gt; &gt; Brian<br>
&gt; &gt;<br>
&gt; &gt; &gt; I can&#39;t find more information for this..., perhaps a bug=
 or other<br>
&gt; &gt; &gt; thing ..., welcome any hint for to research..<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Thanks in advance!<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; -Pablo<br>
&gt; &gt;<br>
&gt; &gt; &gt; _______________________________________________<br>
&gt; &gt; &gt; xfs mailing list<br>
&gt; &gt; &gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; &gt; &gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=
=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt; &gt;<br>
&gt; &gt;<br>
</div></div></blockquote></div><br></div>

--047d7b8743f8f52832050f5e564a--


--===============1327649550627880792==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1327649550627880792==--
