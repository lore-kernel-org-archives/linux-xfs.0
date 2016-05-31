Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A67EB7CA0
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:39:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7403B304048
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 02:39:45 -0700 (PDT)
Received: from gourmet8.spamgourmet.com (gourmet.spamgourmet.com
	[216.75.62.102]) by cuda.sgi.com with ESMTP id CWa1FYL2Zh1Y1z77
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 02:39:42 -0700 (PDT)
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <xfs.pkoch@dfgh.net>) id 1b7g9G-00050m-1N
	for xfs@oss.sgi.com; Tue, 31 May 2016 09:39:42 +0000
MIME-Version: 1.0
Date: Tue, 31 May 2016 11:39:39 +0200
Message-ID: <CAPhCz3RUi-HBXtEnheE1XyT5jVsORQ4ZL9cFjzLrxtv-dXwvBw@mail.gmail.com>
Subject: Re: xfsrestore performance
From: xfs.pkoch@dfgh.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8266242486315117128=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8266242486315117128==
Content-Type: multipart/alternative; boundary=001a114b31f0e67c4305342026bb

--001a114b31f0e67c4305342026bb
Content-Type: text/plain; charset=UTF-8

Dear Dave:

Thanks very much for your explanations

2016-05-30 1:20 GMT+02:00 Dave Chinner - david@fromorbit.com <
xfs.pkoch.2540fe3cfd.david#fromorbit.com@ob.0sg.net>:

> ....
> Oh, dear. There's a massive red flag. I'll come back to it...
>



> > 5: xfsdump the temporary xfs fs to /dev/null. took 20 hours
>
> Nothing to slow down xfsdump reading from disk. Benchmarks lie.
>

dump is fast - restore is the slow point because it has to recreate
> everything. That's what limits the speed of dump - the pipe has a
> bound limit on data in flight, so dump is throttled to restore
> speed when you run this.
>
> And, as I said I'll come back to, restore is slow because:
>

The filesystem is not exactly as you described.  Did you notice that
> xfs_restore realises that it has to restore 20 million directories
> and *274 million* directory entries? i.e. for those 7 million inodes
> containing data, there is roughly 40 hard links pointing to each
> inode. There are also 3 directory inodes for every regular file.
> This is not a "data mostly" filesystem - it has vastly more metadata
> than it has data, even though the data takes up more space.
>

Our backup-server has 46 versions of our home-directories and 158
versions of our mailserver, so if a file has not been changed for more
than a year it will exist once on the backup server together with
45 / 157 hard links.

I'm astonished myself. Firstly about the numbers and also about
the fact that our backup-strategy does work quite well.

Also rsync does a very good job. It was able to copy all these hard links
in 6 days from a 16TB ext3 filesystem on a RAID10-volume to a
15TB xfs filesystem on a RAID5-volume.

And right now 4 rsync processes are copying the 15TB xfs filesystem
back to a 20TB xfs-filesystem. And it seems as if this will finish
today (after 3 days only). Very nice.

Keep in mind that it took dump the best part of 7 hours just to read
> all the inodes and the directory structure to build the dump
> inventory. This matches with the final ext3 rsync pass of 10 hours
> which should have copied very little data.  Creating 270 million
> hard links in 20 million directories from scratch takes a long time,
> and xfs_restore will be no faster at that than rsync....
>

That was my misunderstanding. I was believing/hoping that a tool
that was built for a specific filesystem would outperform a generic
tool like rsync. I thought xfsdump would write all used filesystem
blocks into a data stream and xfsrestore would just read the
blocks from stdin and write them back to the destination filesystem.
Much like a dd-process that knows about the device-content and
can skip unused blocks.


> > Seems like 2 days was a little optimistic
>
> Just a little. :/
>

It would have taken approx 1000 hours


> Personally, I would have copied the data using rsync to the
> temporary XFS filesystem of the same size and shape of the final
> destination (via mkfs parameters to ensure stripe unit/width match
> final destination) and then used xfs_copy to do a block level copy
> of the temporary filesystem back to the final destination. xfs_copy
> will run *much* faster than xfsdump/restore....
>

Next time I will do it like you suggest with one minor change. Instead
of xfs_copy I would use dd, which makes sense if the filesystem is
almost filled. Or do you believe that xfs_copy is faster then dd?
Or will the xfs_growfs create any problems?

I used dd on saturday to copy the 15TB xfs filesystem back
into the 20TB raid10 volume and enlarged the filesystem with
xfs_growfs. The result was a xfs-filesystem with layout-parameters
matching the temporary raid5 volume built from 16 1TB disks
with a 256K chunksize. But the new raid10-volume consists of
20 2TB disks using a chunksize of 512K. And growing the filesystem
raised the allocation group count from 32 to 45.

I reformatted the 20TB volume with a fresh xfs-filesystem and I
let mkfs.xfs decide about the layout.

Does that give me an optimal layout? I will enlarge the filesystem
in the future. This will increase my allocation group count. Is that
a problem that I should better have avoided in advance by reducing
the agcount?

Kind regards and thanks very much for the useful infose

Peter Koch

-- 
Peter Koch
Passauer Strasse 32, 47249 Duisburg
Tel.: 0172 2470263

--001a114b31f0e67c4305342026bb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Dear Dave:<br><br></div>Thanks very much for your exp=
lanations<br><div><div><div class=3D"gmail_extra"><br><div class=3D"gmail_q=
uote">2016-05-30 1:20 GMT+02:00 Dave Chinner - <a href=3D"mailto:david@from=
orbit.com">david@fromorbit.com</a> <span dir=3D"ltr">&lt;<a href=3D"mailto:=
xfs.pkoch.2540fe3cfd.david#fromorbit.com@ob.0sg.net" target=3D"_blank">xfs.=
pkoch.2540fe3cfd.david#fromorbit.com@ob.0sg.net</a>&gt;</span>:<br><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex">.... <br>
Oh, dear. There&#39;s a massive red flag. I&#39;ll come back to it...<br></=
blockquote><div><br>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
&gt; 5: xfsdump the temporary xfs fs to /dev/null. took 20 hours<br>
<br>
Nothing to slow down xfsdump reading from disk. Benchmarks lie.<br></blockq=
uote><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">
dump is fast - restore is the slow point because it has to recreate<br>
everything. That&#39;s what limits the speed of dump - the pipe has a<br>
bound limit on data in flight, so dump is throttled to restore<br>
speed when you run this.<br>
<br>
And, as I said I&#39;ll come back to, restore is slow because:<br></blockqu=
ote><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">
The filesystem is not exactly as you described.=C2=A0 Did you notice that<b=
r>
xfs_restore realises that it has to restore 20 million directories<br>
and *274 million* directory entries? i.e. for those 7 million inodes<br>
containing data, there is roughly 40 hard links pointing to each<br>
inode. There are also 3 directory inodes for every regular file.<br>
This is not a &quot;data mostly&quot; filesystem - it has vastly more metad=
ata<br>
than it has data, even though the data takes up more space.<br></blockquote=
><div><br></div><div>Our backup-server has 46 versions of our home-director=
ies and 158<br>versions of our mailserver, so if a file has not been change=
d for more<br>than a year it will exist once on the backup server together =
with<br>45 / 157 hard links.<br><br></div><div>I&#39;m astonished myself. F=
irstly about the numbers and also about<br>the fact that our backup-strateg=
y does work quite well.<br><br></div><div>Also rsync does a very good job. =
It was able to copy all these hard links<br></div><div>in 6 days from a 16T=
B ext3 filesystem on a RAID10-volume to a<br></div><div>15TB xfs filesystem=
 on a RAID5-volume.<br><br></div><div>And right now 4 rsync processes are c=
opying the 15TB xfs filesystem<br>back to a 20TB xfs-filesystem. And it see=
ms as if this will finish<br>today (after 3 days only). Very nice.<br><br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">
Keep in mind that it took dump the best part of 7 hours just to read<br>
all the inodes and the directory structure to build the dump<br>
inventory. This matches with the final ext3 rsync pass of 10 hours<br>
which should have copied very little data.=C2=A0 Creating 270 million<br>
hard links in 20 million directories from scratch takes a long time,<br>
and xfs_restore will be no faster at that than rsync....<br></blockquote><d=
iv><br></div><div>That was my misunderstanding. I was believing/hoping that=
 a tool<br></div><div>that was built for a specific filesystem would outper=
form a generic<br></div><div>tool like rsync. I thought xfsdump would write=
 all used filesystem<br>blocks into a data stream and xfsrestore would just=
 read the<br>blocks from stdin and write them back to the destination files=
ystem.<br>Much like a dd-process that knows about the device-content and<br=
>can skip unused blocks.<br>=C2=A0<br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

&gt; Seems like 2 days was a little optimistic<br>
<br>
Just a little. :/<br></blockquote><div><br></div><div>It would have taken a=
pprox 1000 hours<br>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

Personally, I would have copied the data using rsync to the<br>
temporary XFS filesystem of the same size and shape of the final<br>
destination (via mkfs parameters to ensure stripe unit/width match<br>
final destination) and then used xfs_copy to do a block level copy<br>
of the temporary filesystem back to the final destination. xfs_copy<br>
will run *much* faster than xfsdump/restore....<br></blockquote><div><br></=
div><div>Next time I will do it like you suggest with one minor change. Ins=
tead<br></div><div>of xfs_copy I would use dd, which makes sense if the fil=
esystem is<br></div><div>almost filled. Or do you believe that xfs_copy is =
faster then dd?<br></div><div>Or will the xfs_growfs create any problems?<b=
r></div><div><br></div><div>I used dd on saturday to copy the 15TB xfs file=
system back<br></div><div>into the 20TB raid10 volume and enlarged the file=
system with<br></div><div>xfs_growfs. The result was a xfs-filesystem with =
layout-parameters<br></div><div>matching the temporary raid5 volume built f=
rom 16 1TB disks<br></div><div>with a 256K chunksize. But the new raid10-vo=
lume consists of<br></div><div>20 2TB disks using a chunksize of 512K. And =
growing the filesystem<br></div><div>raised the allocation group count from=
 32 to 45.<br><br></div><div>I reformatted the 20TB volume with a fresh xfs=
-filesystem and I<br></div><div>let mkfs.xfs decide about the layout.<br><b=
r></div><div>Does that give me an optimal layout? I will enlarge the filesy=
stem<br>in the future. This will increase my allocation group count. Is tha=
t<br>a problem that I should better have avoided in advance by reducing<br>=
the agcount?<br><br>Kind regards and thanks very much for the useful infose=
<br><br>Peter Koch<br clear=3D"all"></div></div><br>-- <br><div class=3D"gm=
ail_signature" data-smartmail=3D"gmail_signature">Peter Koch<br>
Passauer Strasse 32, 47249 Duisburg<br>

Tel.: 0172 2470263</div>
</div></div></div></div>

--001a114b31f0e67c4305342026bb--


--===============8266242486315117128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8266242486315117128==--
