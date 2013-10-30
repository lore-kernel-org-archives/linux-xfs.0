Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD14C29E05
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 09:46:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6BFA1AC0B0
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 07:46:20 -0700 (PDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
	[209.85.217.175]) by cuda.sgi.com with ESMTP id
	kZq6FiSHVQ0twvwp (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 07:46:18 -0700 (PDT)
Received: by mail-lb0-f175.google.com with SMTP id z5so1280193lbh.6
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 07:46:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131030095903.GA8077@citd.de>
References: <CALtWs4-q==CXVZ=jjRnrZGANP98y2Gyot_DV_hGTgxQoRF25UA@mail.gmail.com>
	<20131030095903.GA8077@citd.de>
Date: Wed, 30 Oct 2013 10:46:16 -0400
Message-ID: <CALtWs494cAew-SxMZqZecA+RHSOpAxhQpps-o6Cbe5Qj1GybFw@mail.gmail.com>
Subject: Re: agsize and performance
From: K T <mailkarthikt@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7626926661089612348=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

--===============7626926661089612348==
Content-Type: multipart/alternative; boundary=089e01160f5641ef9e04e9f66575

--089e01160f5641ef9e04e9f66575
Content-Type: text/plain; charset=ISO-8859-1

I meant sync not fsync(O_SYNC flag).

My main question is why there is better throughput when I make the agsize
smaller?


On Wed, Oct 30, 2013 at 5:59 AM, Matthias Schniedermeyer <ms@citd.de> wrote:

> On 29.10.2013 18:10, K T wrote:
> > Hi,
> >
> > I have a 1 TB SATA disk(WD1003FBYX) with XFS. In my tests, I preallocate
> a
> > bunch of 10GB files and write data to the files one at a time. I have
> > observed that the default mkfs setting(4 AGs) gives very low throughput.
> > When I reformat the disk with a agsize of 256mb(agcount=3726), I see
> better
> > throughput. I thought with a bigger agsize, the files will be made of
> fewer
> > extents and hence perform better(due to lesser entries in the extent map
> > getting updated). But, according to my tests, the opposite seems to be
> > true. Can you please explain why this the case? Am I missing something?
> >
> > My test parameters:
> >
> > mkfs.xfs -f /dev/sdbf1
> > mount  -o inode64 /dev/sdbf1 /mnt/test
> > fallocate -l 10G fname
> > dd if=/dev/zero of=fname bs=2M count=64 oflag=direct,sync conv=notrunc
> seek=0
>
> I get the same bad performance with your dd statement.
>
> fallocate -l 10G fname
> time dd if=/dev/zero of=fname bs=2M count=64 oflag=direct,sync
> conv=notrunc seek=0
> 64+0 records in
> 64+0 records out
> 134217728 bytes (134 MB) copied, 4,24088 s, 31,6 MB/s
>
> After pondering the really hard to read dd-man-page.
> Sync is for 'synchronized' I/O. aka REALLY BAD PERFORMANCE. And i assume
> you don't really that.
>
> I think what you meant is fsync. (a.k.a. File (and Metadata) has hit
> stable-storage before dd exits).
> That is: conv=fsync
>
> So:
> time dd if=/dev/zero of=fname bs=2M count=64 oflag=direct
> conv=notrunc,fsync seek=0
> 64+0 records in
> 64+0 records out
> 134217728 bytes (134 MB) copied, 1,44088 s, 93,2 MB/s
>
> That gets much better performance, and in my case it can't get any
> better because the HDD (and encryption) just can't go any faster.
>
>
>
>
> --
>
> Matthias
>

--089e01160f5641ef9e04e9f66575
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I meant sync not fsync(O_SYNC flag).<div><br></div><div>My=
 main question is why there is better throughput when I make the agsize sma=
ller?</div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quo=
te">
On Wed, Oct 30, 2013 at 5:59 AM, Matthias Schniedermeyer <span dir=3D"ltr">=
&lt;<a href=3D"mailto:ms@citd.de" target=3D"_blank">ms@citd.de</a>&gt;</spa=
n> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On 29.10.2013 18:10, K T wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I have a 1 TB SATA disk(WD1003FBYX) with XFS. In my tests, I prealloca=
te a<br>
&gt; bunch of 10GB files and write data to the files one at a time. I have<=
br>
&gt; observed that the default mkfs setting(4 AGs) gives very low throughpu=
t.<br>
&gt; When I reformat the disk with a agsize of 256mb(agcount=3D3726), I see=
 better<br>
&gt; throughput. I thought with a bigger agsize, the files will be made of =
fewer<br>
&gt; extents and hence perform better(due to lesser entries in the extent m=
ap<br>
&gt; getting updated). But, according to my tests, the opposite seems to be=
<br>
&gt; true. Can you please explain why this the case? Am I missing something=
?<br>
&gt;<br>
&gt; My test parameters:<br>
&gt;<br>
&gt; mkfs.xfs -f /dev/sdbf1<br>
&gt; mount =A0-o inode64 /dev/sdbf1 /mnt/test<br>
&gt; fallocate -l 10G fname<br>
&gt; dd if=3D/dev/zero of=3Dfname bs=3D2M count=3D64 oflag=3Ddirect,sync co=
nv=3Dnotrunc seek=3D0<br>
<br>
</div>I get the same bad performance with your dd statement.<br>
<br>
fallocate -l 10G fname<br>
time dd if=3D/dev/zero of=3Dfname bs=3D2M count=3D64 oflag=3Ddirect,sync co=
nv=3Dnotrunc seek=3D0<br>
<div class=3D"im">64+0 records in<br>
64+0 records out<br>
</div>134217728 bytes (134 MB) copied, 4,24088 s, 31,6 MB/s<br>
<br>
After pondering the really hard to read dd-man-page.<br>
Sync is for &#39;synchronized&#39; I/O. aka REALLY BAD PERFORMANCE. And i a=
ssume<br>
you don&#39;t really that.<br>
<br>
I think what you meant is fsync. (a.k.a. File (and Metadata) has hit<br>
stable-storage before dd exits).<br>
That is: conv=3Dfsync<br>
<br>
So:<br>
time dd if=3D/dev/zero of=3Dfname bs=3D2M count=3D64 oflag=3Ddirect conv=3D=
notrunc,fsync seek=3D0<br>
<div class=3D"im">64+0 records in<br>
64+0 records out<br>
</div>134217728 bytes (134 MB) copied, 1,44088 s, 93,2 MB/s<br>
<br>
That gets much better performance, and in my case it can&#39;t get any<br>
better because the HDD (and encryption) just can&#39;t go any faster.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
<br>
<br>
--<br>
<br>
Matthias<br>
</font></span></blockquote></div><br></div>

--089e01160f5641ef9e04e9f66575--


--===============7626926661089612348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7626926661089612348==--
