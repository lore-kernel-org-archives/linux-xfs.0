Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3S24olP238252 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 21:04:50 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	QVyOz58KKSDcjpGz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Apr 2012 19:04:49 -0700 (PDT)
Received: by obbun3 with SMTP id un3so2061601obb.26
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 19:04:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <18818650.cGNyynGa9I@saturn>
References: <CAK6JqP3ze2pocsgoKUTZx_J6w-Zc9V=StqDnqG0Gx0v5hw=FGQ@mail.gmail.com>
	<18818650.cGNyynGa9I@saturn>
Date: Fri, 27 Apr 2012 19:04:48 -0700
Message-ID: <CAK6JqP3Da7E6dumOuvF12uLKXeTKAWdLw3gYs6ZtEhw3WEDQeg@mail.gmail.com>
Subject: Re: Problem recovering XFS filesystem
From: Aaron Williams <aaron.w2@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3365828126489531490=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

--===============3365828126489531490==
Content-Type: multipart/alternative; boundary=e89a8fb1f862516c2f04beb3a560

--e89a8fb1f862516c2f04beb3a560
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Apr 27, 2012 at 2:31 PM, Michael Monnerie <
michael.monnerie@is.it-management.at> wrote:

> Am Donnerstag, 26. April 2012, 13:00:06 schrieb Aaron Williams:
> > I was able to recover the filesystem.
>
> So your RAID busted the filesystem. Maybe the devs could want an
> xfs_metadump of the FS before your repair, so they can inspect it and
> improve xfs_repair.
>
> Hi Michael,

It appears that way, or it may be the fact that I mounted with nobarrier
and in the process of recovering the RAID the information in the
battery-backed RAID cache got blown away. I have an Areca ARC-1210
controller that was in the process of rebuilding when I attempted to shut
down and reboot my Linux system after I mistakenly unplugged the wrong
drive from my RAID array. I had another drive fail on me and it had
completed rebuilding itself using a hot spare drive. I intended to remove
the bad drive to replace it but disconnected the wrong drive. After
reconnecting the good drive it went on to start rebuilding itself again. At
this point I decided it might be safer to shut down Linux to replace the
drive and thought the RAID controller would pick up where it left off in
rebuilding.

Linux did not shut down all the way however. I don't know if it was waiting
for the array to rebuild itself or if something else happened. Anyway, I
eventually hit the reset button. The RAID BIOS reported it could not find
the array and I had to go about rebuilding the array. I also did a volume
check which found about 70,000 blocks that it repaired.  Needless to say I
was quite nervous.

Once that was done Linux refused to mount the XFS partition, I think due to
corruption in the log.

I have an image of my pre-repaired filesystem by using dd and can try and
do a meta dump. The filesystem is 1.9TB in size with about 1.2TB of data in
use.

It looks like I was able to recover everything fine after blowing away the
log. I see a bunch of files recovered in lost+found but those all appear to
be files like cached web pages, etc.

I also dumped the log to a file (128M).

So far it looks like any actual data loss is minimal (thankfully) and was a
good wakeup call to start doing more frequent backups.

I also upgraded xfsprogs from 3.1.6-2.1.2 to 3.1.8 which did a much better
job at recovery than my previous attempt.

It would be nice if xfs_db would allow me to continue when the log is dirty
instead of requiring me to mount the filesystem first. It also would be
nice if xfs_logprint could try and identify the filenames of the inodes
involved.

I understand that there are plans to update XFS to include the UID in all
of the on-disk structures. Any idea on when this will happen?

-Aaron

--e89a8fb1f862516c2f04beb3a560
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Apr 2=
7, 2012 at 2:31 PM, Michael Monnerie <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:michael.monnerie@is.it-management.at" target=3D"_blank">michael.monnerie@=
is.it-management.at</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Am Donnerstag, 26. April 2012, 13:00:06 schr=
ieb Aaron Williams:<br>
<div class=3D"im">&gt; I was able to recover the filesystem.<br>
<br>
</div>So your RAID busted the filesystem. Maybe the devs could want an<br>
xfs_metadump of the FS before your repair, so they can inspect it and<br>
improve xfs_repair.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br></font></span></blockquo=
te><div>Hi Michael,</div><div><br></div><div>It appears that way, or it may=
 be the fact that I mounted with nobarrier
 and in the process of recovering the RAID the information in the=20
battery-backed RAID cache got blown away. I have an Areca ARC-1210 controll=
er that was in the process of rebuilding when I attempted to shut down and =
reboot my Linux system after I mistakenly unplugged the wrong drive from my=
 RAID array. I had another drive fail on me and it had completed rebuilding=
 itself using a hot spare drive. I intended to remove the bad drive to repl=
ace it but disconnected the wrong drive. After reconnecting the good drive =
it went on to start rebuilding itself again. At this point I decided it mig=
ht be safer to shut down Linux to replace the drive and thought the RAID co=
ntroller would pick up where it left off in rebuilding.</div>
<div><br></div><div>Linux did not shut down all the way however. I don&#39;=
t know if it was waiting for the array to rebuild itself or if something el=
se happened. Anyway, I eventually hit the reset button. The RAID BIOS repor=
ted it could not find the array and I had to go about rebuilding the array.=
 I also did a volume check which found about 70,000 blocks that it repaired=
. =A0Needless to say I was quite nervous.</div>
<div><br></div><div>Once that was done Linux refused to mount the XFS parti=
tion, I think due to corruption in the log.</div><div><br></div><div>I have=
 an image of my=20
pre-repaired filesystem by using dd and can try and do a meta dump. The=20
filesystem is 1.9TB in size with about 1.2TB of data in use.</div>

<br>

It looks like I was able to recover everything fine after blowing away=20
the log. I see a bunch of files recovered in lost+found but those all=20
appear to be files like cached web pages, etc.</div><div class=3D"gmail_quo=
te">

<br>

I also dumped the log to a file (128M).<br>

<br>So far it looks like any actual data loss is minimal (thankfully) and=
=20
was a good wakeup call to start doing more frequent backups.<br>

<br>
I also upgraded xfsprogs from 3.1.6-2.1.2 to 3.1.8 which did a much better =
job at recovery than my previous attempt.</div><div class=3D"gmail_quote"><=
br></div>It would be nice if xfs_db would allow me to continue when the log=
 is dirty instead of requiring me to mount the filesystem first. It also wo=
uld be nice if xfs_logprint could try and identify the filenames of the ino=
des involved.<br>
<br><div class=3D"gmail_quote">I understand that there are plans to update =
XFS to include the UID in all of the on-disk structures. Any idea on when t=
his will happen?<br><br>
-Aaron</div></div>

--e89a8fb1f862516c2f04beb3a560--


--===============3365828126489531490==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3365828126489531490==--
