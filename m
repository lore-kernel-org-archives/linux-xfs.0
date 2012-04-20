Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3K4CGHd168902 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 23:12:16 -0500
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	prsNRCH3NtGDHfHj (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Apr 2012 21:12:15 -0700 (PDT)
Received: by iagk10 with SMTP id k10so14727674iag.26
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 21:12:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120415223106.GU6734@dastard>
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
	<20120415223106.GU6734@dastard>
From: Drew Wareham <m3rlin@gmail.com>
Date: Fri, 20 Apr 2012 14:11:54 +1000
Message-ID: <CALcU-6hxzE1Jjwcd=FQikReQCaPqrHN1FXdXim-kq1MvrwCgyA@mail.gmail.com>
Subject: Re: xfs_check segfault / xfs_repair I/O error
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6627866152221509591=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6627866152221509591==
Content-Type: multipart/alternative; boundary=14dae93411e751836604be147ea3

--14dae93411e751836604be147ea3
Content-Type: text/plain; charset=UTF-8

Hi Dave / Stan,

Thanks for taking the time to reply.  Unfortunately none of the suggestions
were able to recover the data - I'm going to rebuild the array now, but as
RAID6 for the extra level of security.

Thanks again for all your help!


Cheers,

Drew


On Mon, Apr 16, 2012 at 8:31 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Apr 15, 2012 at 11:15:09PM +1000, Drew Wareham wrote:
> > Hello Everyone,
> >
> > Hopefully this is the correct kind of information to send to this list.
> >
> > I have an issue with a large XFS volume (17TB) that mounts, but is not
> > readable.  I can view the folder structure on the volume but I can't
> access
> > any of the actual data.  A disk failed in a RAID5 array and while it has
> > rebuilt now, it looks like it's caused serious data integrity issues.
> >
> > Here is the CentOS release / Kernel version:
> >     [root@svr608 ~]# uname -a
> >     Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:51 EST 2012
> > x86_64 x86_64 x86_64 GNU/Linux
> >     [root@svr608 ~]# cat /etc/redhat-release
> >     CentOS release 5.8 (Final)
> >     [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep installed
> >     kmod-xfs.x86_64                            0.4-2
> > installed
> >     xfsdump.x86_64                             2.2.46-1.el5.centos
> > installed
> >     xfsprogs.x86_64                            2.9.4-1.el5.centos
>
> Try upgrading xfsprogs to the latest version first. this is rather
> old, and the latest versions handle IO errors better...
>
> > But even though the volume mounts, when trying to access data it just
> gives
> > a "Structure needs cleaning" error.
> >
> > Running xfs_check and xfs_repair yield the following:
> >     [root@svr608 ~]# xfs_check /dev/cciss/c0d2
> >     bad agf magic # 0x58418706 in ag 0
>
> Oh, that's bad. 2 bytes of the magic number are corrupt...
>
> >     bad agf version # 0x30002 in ag 0
>
> And the version is completely toast.
>
> >     /usr/sbin/xfs_check: line 28:  5259 Segmentation fault
> > xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1
> >     [root@svr608 ~]# xfs_repair -n /dev/cciss/c0d2
> >     Phase 1 - find and verify superblock...
> >     superblock read failed, offset 0, size 524288, ag 0, rval -1
> >
> >     fatal error -- Input/output error
> >
> > And they leave the following in dmesg:
> >     xfs_db[5259]: segfault at 000000000555a134 rip 00000000004070c3 rsp
> > 00007fff986bae50 error 4
> >     cciss 0000:04:00.0: cciss: c ffff810037e00000 has CHECK CONDITION
> sense
> > key = 0x3
>
> This is clearly a raid array error....
>
> ....
>
> > ................
> >     Filesystem cciss/c0d2: XFS internal error xfs_da_do_buf(2) at line
> 2112
> > of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8835d9b9
> >
> > hpacucli says the array is fine, but it looks like it's corrupted to me.
>
> It's badly corrupted. Try a newer version of check/repair, otherwise
> you're in a disaster recovery situation...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--14dae93411e751836604be147ea3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Dave / Stan,<br><br>Thanks for taking the time to reply.=C2=A0 Unfortuna=
tely none of the suggestions were able to recover the data - I&#39;m going =
to rebuild the array now, but as RAID6 for the extra level of security.<br>=
<br>

Thanks again for all your help!<br><br clear=3D"all"><br>Cheers,<br><br>Dre=
w<br>
<br><br><div class=3D"gmail_quote">On Mon, Apr 16, 2012 at 8:31 AM, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fr=
omorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div class=3D"im">On Sun, Apr 15, 2012 at 11:15:09PM +1000, Drew Wareham wr=
ote:<br>
&gt; Hello Everyone,<br>
&gt;<br>
&gt; Hopefully this is the correct kind of information to send to this list=
.<br>
&gt;<br>
&gt; I have an issue with a large XFS volume (17TB) that mounts, but is not=
<br>
&gt; readable. =C2=A0I can view the folder structure on the volume but I ca=
n&#39;t access<br>
&gt; any of the actual data. =C2=A0A disk failed in a RAID5 array and while=
 it has<br>
&gt; rebuilt now, it looks like it&#39;s caused serious data integrity issu=
es.<br>
&gt;<br>
&gt; Here is the CentOS release / Kernel version:<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# uname -a<br>
&gt; =C2=A0 =C2=A0 Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:5=
1 EST 2012<br>
&gt; x86_64 x86_64 x86_64 GNU/Linux<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# cat /etc/redhat-release<br>
&gt; =C2=A0 =C2=A0 CentOS release 5.8 (Final)<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep ins=
talled<br>
&gt; =C2=A0 =C2=A0 kmod-xfs.x86_64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.4-2<br>
&gt; installed<br>
&gt; =C2=A0 =C2=A0 xfsdump.x86_64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2.2.46-1.el5.cento=
s<br>
&gt; installed<br>
&gt; =C2=A0 =C2=A0 xfsprogs.x86_64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02.9.4-1.el5.cent=
os<br>
<br>
</div>Try upgrading xfsprogs to the latest version first. this is rather<br=
>
old, and the latest versions handle IO errors better...<br>
<div class=3D"im"><br>
&gt; But even though the volume mounts, when trying to access data it just =
gives<br>
&gt; a &quot;Structure needs cleaning&quot; error.<br>
&gt;<br>
&gt; Running xfs_check and xfs_repair yield the following:<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# xfs_check /dev/cciss/c0d2<br>
&gt; =C2=A0 =C2=A0 bad agf magic # 0x58418706 in ag 0<br>
<br>
</div>Oh, that&#39;s bad. 2 bytes of the magic number are corrupt...<br>
<div class=3D"im"><br>
&gt; =C2=A0 =C2=A0 bad agf version # 0x30002 in ag 0<br>
<br>
</div>And the version is completely toast.<br>
<div class=3D"im"><br>
&gt; =C2=A0 =C2=A0 /usr/sbin/xfs_check: line 28: =C2=A05259 Segmentation fa=
ult<br>
&gt; xfs_db$DBOPTS -i -p xfs_check -c &quot;check$OPTS&quot; $1<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# xfs_repair -n /dev/cciss/c0d2<br>
&gt; =C2=A0 =C2=A0 Phase 1 - find and verify superblock...<br>
&gt; =C2=A0 =C2=A0 superblock read failed, offset 0, size 524288, ag 0, rva=
l -1<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 fatal error -- Input/output error<br>
&gt;<br>
&gt; And they leave the following in dmesg:<br>
&gt; =C2=A0 =C2=A0 xfs_db[5259]: segfault at 000000000555a134 rip 000000000=
04070c3 rsp<br>
&gt; 00007fff986bae50 error 4<br>
&gt; =C2=A0 =C2=A0 cciss 0000:04:00.0: cciss: c ffff810037e00000 has CHECK =
CONDITION sense<br>
&gt; key =3D 0x3<br>
<br>
</div>This is clearly a raid array error....<br>
<br>
....<br>
<div class=3D"im"><br>
&gt; ................<br>
&gt; =C2=A0 =C2=A0 Filesystem cciss/c0d2: XFS internal error xfs_da_do_buf(=
2) at line 2112<br>
&gt; of file fs/xfs/xfs_da_btree.c. =C2=A0Caller 0xffffffff8835d9b9<br>
&gt;<br>
&gt; hpacucli says the array is fine, but it looks like it&#39;s corrupted =
to me.<br>
<br>
</div>It&#39;s badly corrupted. Try a newer version of check/repair, otherw=
ise<br>
you&#39;re in a disaster recovery situation...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br>

--14dae93411e751836604be147ea3--


--===============6627866152221509591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6627866152221509591==--
