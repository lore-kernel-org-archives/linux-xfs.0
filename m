Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E2CF7F47
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 23:14:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F053B304051
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 21:14:09 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id McT0EmUQs4kKn60M
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Oct 2014 21:14:08 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id a3so2037609oib.8
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 21:14:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543F3C9A.4060603@sandeen.net>
References: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
	<543F3C9A.4060603@sandeen.net>
Date: Thu, 16 Oct 2014 12:14:07 +0800
Message-ID: <CAGdb-8fE+jh0dojaScF=3Oc4Ovea=Tvw1tnRxwb+iroaZd3i9g@mail.gmail.com>
Subject: Re: xfsdump not work in 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5147255776859749033=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <xfs@oss.sgi.com>

--===============5147255776859749033==
Content-Type: multipart/alternative; boundary=001a11403b16cc45320505827a63

--001a11403b16cc45320505827a63
Content-Type: text/plain; charset=UTF-8

after apply above patch, the xfsdump will hang after this message:

/sbin/xfsdump: dumping non-directory files


2014-10-16 11:33 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:

> On 10/15/14 9:31 PM, Tommy Wu wrote:
> > Hi!
> >
> >    xfsdump 3.1.4
> >    xfsprogs 3.2.1
> >    linux kerenl 3.17/3.17.1
> >
>
> ...
>
> >    It just create  a small dump file, and if I run the same xfsdump
> again (or umount the filesystem), it will hang, like:
> >
> > fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=debug,media=debug -l 0
> -o -J -F - /dev/vg/root | gzip > test.gz
> > /sbin/xfsdump: using file dump (drive_simple) strategy
> > /sbin/xfsdump: version 3.1.4 (dump format 3.0)
> > /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/
> > /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014
> > /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208
> > /sbin/xfsdump: session label: ""
> > /sbin/xfsdump: ino map phase 1: constructing initial dump list
> >
> >
> >    switch back to kernel 3.16, the same command work fine.
> >
>
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/xfs?id=a8b1ee8bafc765ebf029d03c5479a69aebff9693
>
> addresses the small backup file, and
>
> [PATCH] xfs: bulkstat doesn't release AGI buffer on error
>
> (on the list) most likely addresses the hang, I think.
>
> -Eric
>



-- 

Tommy Wu

--001a11403b16cc45320505827a63
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">after apply above patch, the xfsdump will hang after this =
message:<br><br>/sbin/xfsdump: dumping non-directory files<br><br></div><di=
v class=3D"gmail_extra"><br><div class=3D"gmail_quote">2014-10-16 11:33 GMT=
+08:00 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen=
.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span>:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><span class=3D"">On 10/15/14 9:31 PM, Tommy Wu wrote:<br=
>
&gt; Hi!<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 xfsdump 3.1.4<br>
&gt;=C2=A0 =C2=A0 xfsprogs 3.2.1<br>
&gt;=C2=A0 =C2=A0 linux kerenl 3.17/3.17.1<br>
&gt;<br>
<br>
</span>...<br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 It just create=C2=A0 a small dump file, and if I run the =
same xfsdump again (or umount the filesystem), it will hang, like:<br>
&gt;<br>
&gt; fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=3Ddebug,media=3Ddebu=
g -l 0 -o -J -F - /dev/vg/root | gzip &gt; test.gz<br>
&gt; /sbin/xfsdump: using file dump (drive_simple) strategy<br>
&gt; /sbin/xfsdump: version 3.1.4 (dump format 3.0)<br>
&gt; /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/<br>
&gt; /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014<br>
&gt; /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208<br>
&gt; /sbin/xfsdump: session label: &quot;&quot;<br>
&gt; /sbin/xfsdump: ino map phase 1: constructing initial dump list<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 switch back to kernel 3.16, the same command work fine.<b=
r>
&gt;<br>
<br>
</span><a href=3D"http://git.kernel.org/cgit/linux/kernel/git/torvalds/linu=
x.git/commit/fs/xfs?id=3Da8b1ee8bafc765ebf029d03c5479a69aebff9693" target=
=3D"_blank">http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/=
commit/fs/xfs?id=3Da8b1ee8bafc765ebf029d03c5479a69aebff9693</a><br>
<br>
addresses the small backup file, and<br>
<br>
[PATCH] xfs: bulkstat doesn&#39;t release AGI buffer on error<br>
<br>
(on the list) most likely addresses the hang, I think.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><br>Tommy=
 Wu
</div>

--001a11403b16cc45320505827a63--


--===============5147255776859749033==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5147255776859749033==--
