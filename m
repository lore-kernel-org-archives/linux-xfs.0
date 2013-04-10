Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D9527F89
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 00:34:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 389DE8F8052
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 22:34:43 -0700 (PDT)
Received: from mail-ia0-f178.google.com (mail-ia0-f178.google.com
	[209.85.210.178]) by cuda.sgi.com with ESMTP id
	CwAe6HLzyVDQgEdg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 22:34:39 -0700 (PDT)
Received: by mail-ia0-f178.google.com with SMTP id f27so80479iae.23
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 22:34:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51644B87.60400@sandeen.net>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<51642E5E.3040403@sandeen.net>
	<CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
	<51644B87.60400@sandeen.net>
Date: Wed, 10 Apr 2013 13:34:39 +0800
Message-ID: <CADFMGuKW8G3b8mOgGnafTXJgCR3YrjLS-xD8aVt1yynVuDLt0g@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7686065891842764329=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7686065891842764329==
Content-Type: multipart/alternative; boundary=90e6ba6e817ab8a8fc04d9fb06da

--90e6ba6e817ab8a8fc04d9fb06da
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Here's the file info in lost+found:

[ lost+found]# pwd
/mnt/xfsd/lost+found
[ lost+found]# ls -l
=D7=DC=D3=C3=C1=BF 4
---------T 1 root root 0 2=D4=C2  28 15:42 3097
---------T 1 root root 0 2=D4=C2  28 15:16 6169
[root@10.15.136.67 lost+found]# sudo getfattr -m . -d -e hex 6169
[root@10.15.136.67 lost+found]# sudo getfattr -m . -d -e hex 3097
# file: 3097
trusted.afr.ec-data-client-2=3D0x000000000000000000000000
trusted.afr.ec-data-client-3=3D0x000000000000000000000000
trusted.afr.ec-data1-client-2=3D0x000000000000000000000000
trusted.afr.ec-data1-client-3=3D0x000000000000000000000000
trusted.gfid=3D0x2bb701d327c44bb0af78d69e89f192a4
trusted.glusterfs.dht.linkto=3D0x65632d64617461312d7265706c69636174652d3400
trusted.glusterfs.quota.b8e8b3ef-0268-40af-93b6-257c4c7ef17a.contri=3D0x000=
0000004249000


It seems they're some link files for glusterfs dht xlator.

Thank you.


2013/4/10 Eric Sandeen <sandeen@sandeen.net>

> On 4/9/13 10:18 AM, =B7=FB=D3=C0=CC=CE wrote:
> > The servers are back to service now and It's hard to run xfs_repair. It
> always happen bellow is the xfs_repair log when it happens on another
> server several days ago.
>
> ...
>
> > =B5=DA=B6=FE=B2=BD
> > repair=B5=C4log
> >
> > sh-4.1$ sudo xfs_repair /dev/glustervg/glusterlv
> > Phase 1 - find and verify superblock=A1=AD
> > Phase 2 - using internal log
> >         - zero log=A1=AD
> >         - scan filesystem freespace and inode maps=A1=AD
> > agi unlinked bucket 0 is 4046848 in ag 0 (inode=3D4046848)
> > agi unlinked bucket 5 is 2340485 in ag 0 (inode=3D2340485)
> > agi unlinked bucket 6 is 2326854 in ag 0 (inode=3D2326854)
> > agi unlinked bucket 8 is 1802120 in ag 0 (inode=3D1802120)
> > agi unlinked bucket 14 is 495566 in ag 0 (inode=3D495566)
> > agi unlinked bucket 16 is 5899536 in ag 0 (inode=3D5899536)
> > agi unlinked bucket 19 is 4008211 in ag 0 (inode=3D4008211)
> > agi unlinked bucket 21 is 4906965 in ag 0 (inode=3D4906965)
> > agi unlinked bucket 23 is 2022231 in ag 0 (inode=3D2022231)
> > agi unlinked bucket 24 is 1626200 in ag 0 (inode=3D1626200)
> > agi unlinked bucket 25 is 938585 in ag 0 (inode=3D938585)
> > agi unlinked bucket 30 is 4226526 in ag 0 (inode=3D4226526)
> > agi unlinked bucket 34 is 4108962 in ag 0 (inode=3D4108962)
> > agi unlinked bucket 37 is 1740389 in ag 0 (inode=3D1740389)
> > agi unlinked bucket 39 is 247399 in ag 0 (inode=3D247399)
> > agi unlinked bucket 40 is 6237864 in ag 0 (inode=3D6237864)
> > agi unlinked bucket 43 is 3404331 in ag 0 (inode=3D3404331)
> > agi unlinked bucket 45 is 2092717 in ag 0 (inode=3D2092717)
> > agi unlinked bucket 48 is 4041008 in ag 0 (inode=3D4041008)
> > agi unlinked bucket 50 is 1459762 in ag 0 (inode=3D1459762)
> > agi unlinked bucket 56 is 852024 in ag 0 (inode=3D852024)
>
> If this machine is still around in similar state, can you do a
>
> # find /path/to/mount -inum $INODE_NUMBER
>
> for the inode numbers above, and see what files they are?
> That might give us a clue about what operations were happening
> to them.  Dumping the gluster xattrs on those files
> might also be interesting.  Just guesses here, but it'd be a
> little more data.
>
> (if this is an old repair, maybe doing the same for your most
> recent incident would be best)
>
> Thanks,
> -Eric
>
> >         - found root in ode chunk
> > Phase 3 - for each AG=A1=AD
> >         - scan and clear agi unlinked lists=A1=AD
> >         - process known inodes and perform inode discovery=A1=AD
> >         - agno =3D 0
> > 7f8220be6700: Badness in key lookup (length)
> > bp=3D(bno 123696, len 16384 bytes) key=3D(bno 123696, len 8192 bytes)
>
> (FWIW the above warnings look like an xfs_repair bug, not related)
>
> -Eric
>
>


--=20
=B7=FB=D3=C0=CC=CE

--90e6ba6e817ab8a8fc04d9fb06da
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Here&#39;s the file info in lost+found:<br><br>[=
 lost+found]# pwd<br>/mnt/xfsd/lost+found<br>[ lost+found]# ls -l<br>=D7=DC=
=D3=C3=C1=BF 4<br>---------T 1 root root 0 2=D4=C2&nbsp; 28 15:42 3097<br>-=
--------T 1 root root 0 2=D4=C2&nbsp; 28 15:16 6169<br>
[<a href=3D"mailto:root@10.15.136.67">root@10.15.136.67</a> lost+found]# su=
do getfattr -m . -d -e hex 6169<br>[<a href=3D"mailto:root@10.15.136.67">ro=
ot@10.15.136.67</a> lost+found]# sudo getfattr -m . -d -e hex 3097<br># fil=
e: 3097<br>
trusted.afr.ec-data-client-2=3D0x000000000000000000000000<br>trusted.afr.ec=
-data-client-3=3D0x000000000000000000000000<br>trusted.afr.ec-data1-client-=
2=3D0x000000000000000000000000<br>trusted.afr.ec-data1-client-3=3D0x0000000=
00000000000000000<br>
trusted.gfid=3D0x2bb701d327c44bb0af78d69e89f192a4<br>trusted.glusterfs.dht.=
linkto=3D0x65632d64617461312d7265706c69636174652d3400<br>trusted.glusterfs.=
quota.b8e8b3ef-0268-40af-93b6-257c4c7ef17a.contri=3D0x0000000004249000<br><=
br>
<br></div>It seems they&#39;re some link files for glusterfs dht xlator.<br=
><br></div>Thank you.<br></div><div class=3D"gmail_extra"><br><br><div clas=
s=3D"gmail_quote">2013/4/10 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</s=
pan><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 4/9/13 10:18 AM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
</div><div class=3D"im">&gt; The servers are back to service now and It&#39=
;s hard to run xfs_repair. It always happen bellow is the xfs_repair log wh=
en it happens on another server several days ago.<br>
<br>
</div><div><div class=3D"h5">...<br>
<br>
&gt; =B5=DA=B6=FE=B2=BD<br>
&gt; repair=B5=C4log<br>
&gt;<br>
&gt; sh-4.1$ sudo xfs_repair /dev/glustervg/glusterlv<br>
&gt; Phase 1 - find and verify superblock&hellip;<br>
&gt; Phase 2 - using internal log<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - zero log&hellip;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - scan filesystem freespace and inode maps=
&hellip;<br>
&gt; agi unlinked bucket 0 is 4046848 in ag 0 (inode=3D4046848)<br>
&gt; agi unlinked bucket 5 is 2340485 in ag 0 (inode=3D2340485)<br>
&gt; agi unlinked bucket 6 is 2326854 in ag 0 (inode=3D2326854)<br>
&gt; agi unlinked bucket 8 is 1802120 in ag 0 (inode=3D1802120)<br>
&gt; agi unlinked bucket 14 is 495566 in ag 0 (inode=3D495566)<br>
&gt; agi unlinked bucket 16 is 5899536 in ag 0 (inode=3D5899536)<br>
&gt; agi unlinked bucket 19 is 4008211 in ag 0 (inode=3D4008211)<br>
&gt; agi unlinked bucket 21 is 4906965 in ag 0 (inode=3D4906965)<br>
&gt; agi unlinked bucket 23 is 2022231 in ag 0 (inode=3D2022231)<br>
&gt; agi unlinked bucket 24 is 1626200 in ag 0 (inode=3D1626200)<br>
&gt; agi unlinked bucket 25 is 938585 in ag 0 (inode=3D938585)<br>
&gt; agi unlinked bucket 30 is 4226526 in ag 0 (inode=3D4226526)<br>
&gt; agi unlinked bucket 34 is 4108962 in ag 0 (inode=3D4108962)<br>
&gt; agi unlinked bucket 37 is 1740389 in ag 0 (inode=3D1740389)<br>
&gt; agi unlinked bucket 39 is 247399 in ag 0 (inode=3D247399)<br>
&gt; agi unlinked bucket 40 is 6237864 in ag 0 (inode=3D6237864)<br>
&gt; agi unlinked bucket 43 is 3404331 in ag 0 (inode=3D3404331)<br>
&gt; agi unlinked bucket 45 is 2092717 in ag 0 (inode=3D2092717)<br>
&gt; agi unlinked bucket 48 is 4041008 in ag 0 (inode=3D4041008)<br>
&gt; agi unlinked bucket 50 is 1459762 in ag 0 (inode=3D1459762)<br>
&gt; agi unlinked bucket 56 is 852024 in ag 0 (inode=3D852024)<br>
<br>
</div></div>If this machine is still around in similar state, can you do a<=
br>
<br>
# find /path/to/mount -inum $INODE_NUMBER<br>
<br>
for the inode numbers above, and see what files they are?<br>
That might give us a clue about what operations were happening<br>
to them. &nbsp;Dumping the gluster xattrs on those files<br>
might also be interesting. &nbsp;Just guesses here, but it&#39;d be a<br>
little more data.<br>
<br>
(if this is an old repair, maybe doing the same for your most<br>
recent incident would be best)<br>
<br>
Thanks,<br>
-Eric<br>
<div class=3D"im"><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - found root in ode chunk<br>
&gt; Phase 3 - for each AG&hellip;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - scan and clear agi unlinked lists&hellip=
;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - process known inodes and perform inode d=
iscovery&hellip;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - agno =3D 0<br>
&gt; 7f8220be6700: Badness in key lookup (length)<br>
&gt; bp=3D(bno 123696, len 16384 bytes) key=3D(bno 123696, len 8192 bytes)<=
br>
<br>
</div>(FWIW the above warnings look like an xfs_repair bug, not related)<br=
>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--90e6ba6e817ab8a8fc04d9fb06da--


--===============7686065891842764329==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7686065891842764329==--
