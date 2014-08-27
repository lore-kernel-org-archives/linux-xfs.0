Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3B787F3F
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 03:53:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F827AC001
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 01:53:23 -0700 (PDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
	[209.85.217.177]) by cuda.sgi.com with ESMTP id
	LIKknPUY4B806h8X (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Aug 2014 01:53:18 -0700 (PDT)
Received: by mail-lb0-f177.google.com with SMTP id l4so2712143lbv.22
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 01:53:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140826131354.GK20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
	<20140825090843.GE20518@dastard>
	<CAKEtwsU4gywG7fVVMVU1Y_TG9Pgg_-sFV0=SPg_7Ob5EV6FTew@mail.gmail.com>
	<20140825222657.GF20518@dastard>
	<CAGpXXZL2=ynv4x6hhBSsBPZmBG9Ac8mPOgE-Ekjs3tLvQO9Uaw@mail.gmail.com>
	<20140826023754.GH20518@dastard>
	<CAKEtwsW=6Wh3rdaNvmNbiOq1iUm+=xAwL0FsNhcmpKwkQrN9Ww@mail.gmail.com>
	<20140826131354.GK20518@dastard>
Date: Wed, 27 Aug 2014 16:53:17 +0800
Message-ID: <CAKEtwsVwXq4NXcGKCXob-qte3AT2MJ6qgzPB9Sb5Av12WxjCMw@mail.gmail.com>
Subject: Re: bad performance on touch/cp file on XFS system
From: Zhang Qiang <zhangqiang.buaa@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3551421425526592959=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, xfs-oss <xfs@oss.sgi.com>

--===============3551421425526592959==
Content-Type: multipart/alternative; boundary=001a1134615216d3a70501988d40

--001a1134615216d3a70501988d40
Content-Type: text/plain; charset=UTF-8

2014-08-26 21:13 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Tue, Aug 26, 2014 at 06:04:52PM +0800, Zhang Qiang wrote:
> > Thanks Dave/Greg for your analysis and suggestions.
> >
> > I can summarize what I should do next:
> >
> > - backup my data using xfsdump
> > - rebuilt filesystem using mkfs with options: agcount=32 for 2T disk
> > - mount filesystem with option inode64,nobarrier
>
> Ok up to here.
>
> > - applied patches about adding free list inode on disk structure
>
> No, don't do that. You're almost certain to get it wrong and corrupt
> your filesysetms and lose data.
>
> > As we have about ~100 servers need back up, so that will take much
> effort,
> > do you have any other suggestion?
>
> Just remount them with inode64. Nothing else. Over time as you add
> and remove files the inodes will redistribute across all 4 AGs.
>
OK.

How I can see  the layout number of inodes on each AGs? Here's my checking
steps:

1) Check unmounted file system first:
[root@fstest data1]# xfs_db -c "sb 0"  -c "p" /dev/sdb1 |egrep
'icount|ifree'
icount = 421793920
ifree = 41
[root@fstest data1]# xfs_db -c "sb 1"  -c "p" /dev/sdb1 |egrep
'icount|ifree'
icount = 0
ifree = 0
[root@fstest data1]# xfs_db -c "sb 2"  -c "p" /dev/sdb1 |egrep
'icount|ifree'
icount = 0
ifree = 0
[root@fstest data1]# xfs_db -c "sb 3"  -c "p" /dev/sdb1 |egrep
'icount|ifree'
icount = 0
ifree = 0
2) mount it with inode64 and create many files:

[root@fstest /]# mount -o inode64,nobarrier /dev/sdb1 /data
[root@fstest /]# cd /data/tmp/
[root@fstest tmp]# fdtree.bash -d 16 -l 2 -f 100 -s 1
[root@fstest /]# umount /data

3) Check with xfs_db again:

[root@fstest data1]# xfs_db -f -c "sb 0"  -c "p" /dev/sdb1 |egrep
'icount|ifree'
icount = 421821504
ifree = 52
[root@fstest data1]# xfs_db -f -c "sb 1"  -c "p" /dev/sdb1 |egrep
'icount|ifree'
icount = 0
ifree = 0

So, it seems that inodes only on first AG. Or icount/ifree is not the
correct value to check, and how should I check how many inodes on each AGs?


I am finding  a way to improve the performance based on current filesystem
and kernel just remounting with inode64, I am trying how to make all inodes
redistribute on all AGs averagely.

Is there any good way?, for example backup half of data to another device
and remove it, then copy back it.


> > What I am testing (ongoing):
> >  - created a new 2T partition filesystem
> >  - try to create small files and fill whole spaces then remove some of
> them
> > randomly
> >  - check the performance of touch/cp files
> >  - apply patches and verify it.
> >
> > I have got more data from server:
> >
> > 1) flush all cache(echo 3 > /proc/sys/vm/drop_caches), and umount
> filesystem
> > 2) mount filesystem and testing with touch command
> >   * The first touch new file command take about ~23s
> >   * second touch command take about ~0.1s.
>
> So it's cache population that is your issue. You didn't say that
> first time around, which means the diagnosis was wrong. Again, it's having
> to
> search a btree with 220 million inodes in it to find the first free
> inode, and that btree has to be pulled in from disk and searched.
> Once it's cached, then each subsequent allocation will be much
> faster becaue the majority of the tree being searched will already
> be in cache...
>
> > I have compared the memory used, it seems that xfs try to load inode bmap
> > block for the first time, which take much time, is that the reason to
> take
> > so much time for the first touch operation?
>
> No. reading the AGI btree to find the first free inode to allocate
> is what is taking the time. If you spread the inodes out over 4 AGs
> (using inode64) then the overhead of the first read will go down
> proportionally. Indeed, that is one of the reasons for using more
> AGs than 4 for filesystems lik ethis.
>
OK, I see.


> Still, I can't help but wonder why you are using a filesystem to
> store hundreds of millions of tiny files, when a database is far
> better suited to storing and indexing this type and quantity of
> data....
>

OK, this is a social networking website back end servers, actually the CDN
infrastructure, and different server located different cities.
We have a global sync script to make all these 100 servers have the same
data.

For each server we use RAID10 and XFS (CentOS6.3).

There are about 3M files (50K in size) generated every day, and we track
the path of each files in database.

Do you have any suggestions to improve our solution?



> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a1134615216d3a70501988d40
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">2014-08-26 21:13 GMT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>=
&gt;</span>:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div>On Tue, Aug 26, 2014 at 06:04:52PM +0800, Zhang Qiang=
 wrote:<br>


&gt; Thanks Dave/Greg for your analysis and suggestions.<br>
&gt;<br>
&gt; I can summarize what I should do next:<br>
&gt;<br>
&gt; - backup my data using xfsdump<br>
&gt; - rebuilt filesystem using mkfs with options: agcount=3D32 for 2T disk=
<br>
&gt; - mount filesystem with option inode64,nobarrier<br>
<br>
</div>Ok up to here.<br>
<div><br>
&gt; - applied patches about adding free list inode on disk structure<br>
<br>
</div>No, don&#39;t do that. You&#39;re almost certain to get it wrong and =
corrupt<br>
your filesysetms and lose data.<br>
<div><br>
&gt; As we have about ~100 servers need back up, so that will take much eff=
ort,<br>
&gt; do you have any other suggestion?<br>
<br>
</div>Just remount them with inode64. Nothing else. Over time as you add<br=
>
and remove files the inodes will redistribute across all 4 AGs.<br></blockq=
uote><div>OK.</div><div><br></div><div>How I can see =C2=A0the layout numbe=
r of inodes on each AGs? Here&#39;s my checking steps:</div><div><br></div>

<div>1) Check unmounted file system first:</div><div><div>[root@fstest data=
1]# xfs_db -c &quot;sb 0&quot; =C2=A0-c &quot;p&quot; /dev/sdb1 |egrep &#39=
;icount|ifree&#39;</div><div>icount =3D 421793920</div><div>ifree =3D 41</d=
iv><div>

[root@fstest data1]# xfs_db -c &quot;sb 1&quot; =C2=A0-c &quot;p&quot; /dev=
/sdb1 |egrep &#39;icount|ifree&#39;</div><div>icount =3D 0</div><div>ifree =
=3D 0</div><div>[root@fstest data1]# xfs_db -c &quot;sb 2&quot; =C2=A0-c &q=
uot;p&quot; /dev/sdb1 |egrep &#39;icount|ifree&#39;</div>

<div>icount =3D 0</div><div>ifree =3D 0</div><div>[root@fstest data1]# xfs_=
db -c &quot;sb 3&quot; =C2=A0-c &quot;p&quot; /dev/sdb1 |egrep &#39;icount|=
ifree&#39;</div><div>icount =3D 0</div><div>ifree =3D 0</div></div><div>2) =
mount it with inode64 and create many files:</div>

<div><br></div><div><div>[root@fstest /]# mount -o inode64,nobarrier /dev/s=
db1 /data</div><div>[root@fstest /]# cd /data/tmp/</div><div>[root@fstest t=
mp]# fdtree.bash -d 16 -l 2 -f 100 -s 1</div></div><div>[root@fstest /]# um=
ount /data<br>

</div><div><br></div><div>3) Check with xfs_db again:<br><br></div><div><di=
v>[root@fstest data1]# xfs_db -f -c &quot;sb 0&quot; =C2=A0-c &quot;p&quot;=
 /dev/sdb1 |egrep &#39;icount|ifree&#39;</div><div>icount =3D 421821504</di=
v>
<div>
ifree =3D 52</div><div>[root@fstest data1]# xfs_db -f -c &quot;sb 1&quot; =
=C2=A0-c &quot;p&quot; /dev/sdb1 |egrep &#39;icount|ifree&#39;</div><div>ic=
ount =3D 0</div><div>ifree =3D 0</div></div><div><br></div><div>So, it seem=
s that inodes only on first AG. Or icount/ifree is not the correct value to=
 check, and how should I check how many inodes on each AGs?</div>

<div><br></div><div><br></div><div>I am finding =C2=A0a way to improve the =
performance based on current filesystem and kernel just remounting with ino=
de64, I am trying how to make all inodes redistribute on all AGs averagely.=
</div>

<div><br></div><div>Is there any good way?, for example backup half of data=
 to another device and remove it, then copy back it.</div><div><br></div><b=
lockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-le=
ft-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;pad=
ding-left:1ex">

<div><br>
&gt; What I am testing (ongoing):<br>
&gt;=C2=A0 - created a new 2T partition filesystem<br>
&gt;=C2=A0 - try to create small files and fill whole spaces then remove so=
me of them<br>
&gt; randomly<br>
&gt;=C2=A0 - check the performance of touch/cp files<br>
&gt;=C2=A0 - apply patches and verify it.<br>
&gt;<br>
&gt; I have got more data from server:<br>
&gt;<br>
&gt; 1) flush all cache(echo 3 &gt; /proc/sys/vm/drop_caches), and umount f=
ilesystem<br>
&gt; 2) mount filesystem and testing with touch command<br>
&gt;=C2=A0 =C2=A0* The first touch new file command take about ~23s<br>
&gt;=C2=A0 =C2=A0* second touch command take about ~0.1s.<br>
<br>
</div>So it&#39;s cache population that is your issue. You didn&#39;t say t=
hat<br>
first time around, which means the diagnosis was wrong. Again, it&#39;s hav=
ing to<br>
search a btree with 220 million inodes in it to find the first free<br>
inode, and that btree has to be pulled in from disk and searched.<br>
Once it&#39;s cached, then each subsequent allocation will be much<br>
faster becaue the majority of the tree being searched will already<br>
be in cache...<br>
<div><br>
&gt; I have compared the memory used, it seems that xfs try to load inode b=
map<br>
&gt; block for the first time, which take much time, is that the reason to =
take<br>
&gt; so much time for the first touch operation?<br>
<br>
</div>No. reading the AGI btree to find the first free inode to allocate<br=
>
is what is taking the time. If you spread the inodes out over 4 AGs<br>
(using inode64) then the overhead of the first read will go down<br>
proportionally. Indeed, that is one of the reasons for using more<br>
AGs than 4 for filesystems lik ethis.<br></blockquote><div>OK, I see.=C2=A0=
</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);bord=
er-left-style:solid;padding-left:1ex">


<br>
Still, I can&#39;t help but wonder why you are using a filesystem to<br>
store hundreds of millions of tiny files, when a database is far<br>
better suited to storing and indexing this type and quantity of<br>
data....<br></blockquote><div><br></div><div>OK, this is a social networkin=
g website back end servers, actually the CDN infrastructure, and different =
server located different cities.</div><div>We have a global sync script to =
make all these 100 servers have the same data.<br>

</div><div><br></div><div>For each server we use RAID10 and XFS (CentOS6.3)=
.</div><div><br></div><div>There are about 3M files (50K in size) generated=
 every day, and we track the path of each files in database.</div><div>

<br></div><div>Do you have any suggestions to improve our solution?</div><d=
iv><br></div><div><br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,20=
4);border-left-style:solid;padding-left:1ex">


<div><div><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</div></div></blockquote></div><br></div></div>

--001a1134615216d3a70501988d40--


--===============3551421425526592959==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3551421425526592959==--
