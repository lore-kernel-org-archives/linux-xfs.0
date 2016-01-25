Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 552DD7CA1
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 13:00:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21AE18F8033
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 11:00:57 -0800 (PST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id ilTl78pjlf86qIsi
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2016 11:00:53 -0800 (PST)
Received: by mail-wm0-f41.google.com with SMTP id 123so78174347wmz.0
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 11:00:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A66869.3080506@ddn.com>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
	<56A66869.3080506@ddn.com>
Date: Mon, 25 Jan 2016 14:00:52 -0500
Message-ID: <CAC2B=ZEJ7cSnpzpfRBfwfEnZUsLBQe=YW2fuvbVF75OjmYmOOw@mail.gmail.com>
Subject: Re: xfs and swift
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6235785808769716861=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Bernd Schubert <bschubert@ddn.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

--===============6235785808769716861==
Content-Type: multipart/alternative; boundary=001a113c808c1dc745052a2d30e1

--001a113c808c1dc745052a2d30e1
Content-Type: text/plain; charset=UTF-8

hey bernd, long time no chat.  it turns out you don't have to know what
swift is because I've been able to demonstrate this behavior with a very
simple python script that simply creates files in a 3-tier hierarchy.  the
third level directories each contain a single file which for my testing are
all 1K.

I have played wiht cache_pressure and it doesn't seem to make a difference,
though that was awhlle ago and perhaps it is worth revisiting. one thing
you may get a hoot out of, being a collectl user, is I have an xfs plugin
that lets you look at a ton of xfs stats either in realtime or after the
fact just like any other collectl stat.  I just havent' added it to the kit
yet.

-mark

On Mon, Jan 25, 2016 at 1:24 PM, Bernd Schubert <bschubert@ddn.com> wrote:

> Hi Mark!
>
> On 01/06/2016 04:15 PM, Mark Seger wrote:
> > I've recently found the performance our development swift system is
> > degrading over time as the number of objects/files increases.  This is a
> > relatively small system, each server has 3 400GB disks.  The system I'm
> > currently looking at has about 70GB tied up in slabs alone, close to 55GB
> > in xfs inodes and ili, and about 2GB free.  The kernel
> > is 3.14.57-1-amd64-hlinux.
> >
> > Here's the way the filesystems are mounted:
> >
> > /dev/sdb1 on /srv/node/disk0 type xfs
> >
> (rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota)
> >
> > I can do about 2000 1K file creates/sec when running 2 minute PUT tests
> at
> > 100 threads.  If I repeat that tests for multiple hours, I see the number
> > of IOPS steadily decreasing to about 770 and the very next run it drops
> to
> > 260 and continues to fall from there.  This happens at about 12M files.
> >
> > The directory structure is 2 tiered, with 1000 directories per tier so we
> > can have about 1M of them, though they don't currently all exist.
>
> This sounds pretty much like hash directories as used by some parallel
> file systems (Lustre and in the past BeeGFS). For us the file create
> slow down was due to lookup in directories if a file with the same name
> already exists. At least for ext4 it was rather easy to demonstrate that
> simply caching directory blocks would eliminate that issue.
> We then considered working on a better kernel cache, but in the end
> simply found a way to get rid of such a simple directory structure in
> BeeGFS and changed it to a more complex layout, but with less random
> access and so we could eliminate the main reason for the slow down.
>
> Now I have no idea what a "swift system" is and in which order it
> creates and accesses those files and if it would be possible to change
> the access pattern. One thing you might try and which should work much
> better since 3.11 is the vfs_cache_pressure setting. The lower it is the
> less dentries/inodes are dropped from cache when pages are needed for
> file data.
>
>
>
> Cheers,
> Bernd

--001a113c808c1dc745052a2d30e1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">hey bernd, long time no chat. =C2=A0it turns out you don&#=
39;t have to know what swift is because I&#39;ve been able to demonstrate t=
his behavior with a very simple python script that simply creates files in =
a 3-tier hierarchy. =C2=A0the third level directories each contain a single=
 file which for my testing are all 1K.<div><br></div><div>I have played wih=
t cache_pressure and it doesn&#39;t seem to make a difference, though that =
was awhlle ago and perhaps it is worth revisiting. one thing you may get a =
hoot out of, being a collectl user, is I have an xfs plugin that lets you l=
ook at a ton of xfs stats either in realtime or after the fact just like an=
y other collectl stat.=C2=A0 I just havent&#39; added it to the kit yet.</d=
iv><div><br></div><div>-mark</div></div><div class=3D"gmail_extra"><br><div=
 class=3D"gmail_quote">On Mon, Jan 25, 2016 at 1:24 PM, Bernd Schubert <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:bschubert@ddn.com" target=3D"_blank">bs=
chubert@ddn.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi =
Mark!<br>
<span class=3D""><br>
On 01/06/2016 04:15 PM, Mark Seger wrote:<br>
&gt; I&#39;ve recently found the performance our development swift system i=
s<br>
&gt; degrading over time as the number of objects/files increases.=C2=A0 Th=
is is a<br>
&gt; relatively small system, each server has 3 400GB disks.=C2=A0 The syst=
em I&#39;m<br>
&gt; currently looking at has about 70GB tied up in slabs alone, close to 5=
5GB<br>
&gt; in xfs inodes and ili, and about 2GB free.=C2=A0 The kernel<br>
&gt; is 3.14.57-1-amd64-hlinux.<br>
&gt;<br>
&gt; Here&#39;s the way the filesystems are mounted:<br>
&gt;<br>
&gt; /dev/sdb1 on /srv/node/disk0 type xfs<br>
&gt; (rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=3D8,logbsize=3D=
256k,sunit=3D512,swidth=3D1536,noquota)<br>
&gt;<br>
&gt; I can do about 2000 1K file creates/sec when running 2 minute PUT test=
s at<br>
&gt; 100 threads.=C2=A0 If I repeat that tests for multiple hours, I see th=
e number<br>
&gt; of IOPS steadily decreasing to about 770 and the very next run it drop=
s to<br>
&gt; 260 and continues to fall from there.=C2=A0 This happens at about 12M =
files.<br>
&gt;<br>
&gt; The directory structure is 2 tiered, with 1000 directories per tier so=
 we<br>
&gt; can have about 1M of them, though they don&#39;t currently all exist.<=
br>
<br>
</span>This sounds pretty much like hash directories as used by some parall=
el<br>
file systems (Lustre and in the past BeeGFS). For us the file create<br>
slow down was due to lookup in directories if a file with the same name<br>
already exists. At least for ext4 it was rather easy to demonstrate that<br=
>
simply caching directory blocks would eliminate that issue.<br>
We then considered working on a better kernel cache, but in the end<br>
simply found a way to get rid of such a simple directory structure in<br>
BeeGFS and changed it to a more complex layout, but with less random<br>
access and so we could eliminate the main reason for the slow down.<br>
<br>
Now I have no idea what a &quot;swift system&quot; is and in which order it=
<br>
creates and accesses those files and if it would be possible to change<br>
the access pattern. One thing you might try and which should work much<br>
better since 3.11 is the vfs_cache_pressure setting. The lower it is the<br=
>
less dentries/inodes are dropped from cache when pages are needed for<br>
file data.<br>
<br>
<br>
<br>
Cheers,<br>
Bernd</blockquote></div><br></div>

--001a113c808c1dc745052a2d30e1--


--===============6235785808769716861==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6235785808769716861==--
