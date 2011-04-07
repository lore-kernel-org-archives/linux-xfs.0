Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p37EgFYM101966
	for <linux-xfs@oss.sgi.com>; Thu, 7 Apr 2011 09:42:15 -0500
Received: from nm14-vm0.bullet.mail.sp2.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 4DC1D5B4
	for <linux-xfs@oss.sgi.com>; Thu,  7 Apr 2011 07:45:31 -0700 (PDT)
Received: from nm14-vm0.bullet.mail.sp2.yahoo.com
	(nm14-vm0.bullet.mail.sp2.yahoo.com [98.139.91.246]) by
	cuda.sgi.com with SMTP id aT52LMAzuWD6ywBy for
	<linux-xfs@oss.sgi.com>; Thu, 07 Apr 2011 07:45:31 -0700 (PDT)
Message-ID: <18613.58622.qm@web112910.mail.gq1.yahoo.com>
References: <31199414.post@talk.nabble.com> <20110322051353.GA15270@dastard>
Date: Thu, 7 Apr 2011 07:45:30 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: umount fails with device is busy
In-Reply-To: <20110322051353.GA15270@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4618605380480965066=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

--===============4618605380480965066==
Content-Type: multipart/alternative; boundary="0-1725493675-1302187530=:58622"

--0-1725493675-1302187530=:58622
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

missed your reply on this one.... I'd almost given up on this one.....=0A=
=0A>Why do you need to do this?=0AI have an app which occassionally throws =
errors suggesting the fs is at fault. =0ABut in most cases, I'm not sure wh=
ether it's the fs or the raid underneath thats =0Acausing it.=0ASo I usuall=
y run xfs_repair with the -n switch.=0A=0ADid you have an oops or a filesys=
tem shutdown? i.e. anything in=0Asyslog of note?=0A=0Anot recently, but in =
the past had some unclean shutdowns and on one instance I =0Adid a umount -=
l on the raid set when it refused to unmount gracefully.=0ABut I had re-rai=
ded the server since.=0A=0A=0A=0A________________________________=0AFrom: D=
ave Chinner <david@fromorbit.com>=0ATo: stress_buster <leo1783@yahoo.com>=
=0ACc: linux-xfs@oss.sgi.com=0ASent: Tue, March 22, 2011 10:43:53 AM=0ASubj=
ect: Re: umount fails with device is busy=0A=0AOn Mon, Mar 21, 2011 at 03:5=
3:04AM -0700, stress_buster wrote:=0A> =0A> I'm trying to run xfs_repair on=
 my filesystem:=0A=0AWhy do you need to do this?=0A=0A> Firstly to unmount =
the fs=0A> =0A> Quote:=0A> umount /myfs=0A> umount: /myfs: device is busy=
=0A> umount: /myfs: device is busy=A0 =0A> =0A> Quote:=0A> lsof /dev/sda=A0=
 =0A> =0A> -show none ie nothing seems to be 'touching' the disk.=0A> confu=
sed why its still showing device is busy=0A=0ADid you have an oops or a fil=
esystem shutdown? i.e. anything in=0Asyslog of note?=0A=0ACheers,=0A=0ADave=
.=0A-- =0ADave Chinner=0Adavid@fromorbit.com=0A
--0-1725493675-1302187530=:58622
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman, new york, times, serif;=
font-size:12pt"><DIV>missed your reply on this one.... I'd almost given up =
on this one.....</DIV>=0A<DIV>&nbsp;</DIV>=0A<DIV>&gt;Why do you need to do=
 this?</DIV>=0A<DIV>I have an app which occassionally throws errors suggest=
ing the fs is at fault. But in most cases, I'm not sure whether it's the fs=
 or the raid underneath thats causing it.</DIV>=0A<DIV>So I usually run xfs=
_repair with the -n switch.</DIV>=0A<DIV>&nbsp;</DIV>=0A<DIV>Did you have a=
n oops or a filesystem shutdown? i.e. anything in<BR>syslog of note?<BR><BR=
>not recently, but in the past had some unclean shutdowns and on one instan=
ce I did a umount -l on the raid set when it refused to unmount gracefully.=
</DIV>=0A<DIV>But I had re-raided the server since.</DIV>=0A<DIV style=3D"F=
ONT-SIZE: 12pt; FONT-FAMILY: times new roman, new york, times, serif"><BR>=
=0A<DIV style=3D"FONT-SIZE: 13px; FONT-FAMILY: arial, helvetica, sans-serif=
"><FONT face=3DTahoma size=3D2>=0A<HR SIZE=3D1>=0A<B><SPAN style=3D"FONT-WE=
IGHT: bold">From:</SPAN></B> Dave Chinner &lt;david@fromorbit.com&gt;<BR><B=
><SPAN style=3D"FONT-WEIGHT: bold">To:</SPAN></B> stress_buster &lt;leo1783=
@yahoo.com&gt;<BR><B><SPAN style=3D"FONT-WEIGHT: bold">Cc:</SPAN></B> linux=
-xfs@oss.sgi.com<BR><B><SPAN style=3D"FONT-WEIGHT: bold">Sent:</SPAN></B> T=
ue, March 22, 2011 10:43:53 AM<BR><B><SPAN style=3D"FONT-WEIGHT: bold">Subj=
ect:</SPAN></B> Re: umount fails with device is busy<BR></FONT><BR>On Mon, =
Mar 21, 2011 at 03:53:04AM -0700, stress_buster wrote:<BR>&gt; <BR>&gt; I'm=
 trying to run xfs_repair on my filesystem:<BR><BR>Why do you need to do th=
is?<BR><BR>&gt; Firstly to unmount the fs<BR>&gt; <BR>&gt; Quote:<BR>&gt; u=
mount /myfs<BR>&gt; umount: /myfs: device is busy<BR>&gt; umount: /myfs: de=
vice is busy&nbsp; <BR>&gt; <BR>&gt; Quote:<BR>&gt; lsof /dev/sda&nbsp; <BR=
>&gt; <BR>&gt; -show none ie nothing seems to be 'touching' the disk.<BR>&g=
t; confused why its still showing device is
 busy<BR><BR>Did you have an oops or a filesystem shutdown? i.e. anything i=
n<BR>syslog of note?<BR><BR>Cheers,<BR><BR>Dave.<BR>-- <BR>Dave Chinner<BR>=
<A href=3D"mailto:david@fromorbit.com" ymailto=3D"mailto:david@fromorbit.co=
m">david@fromorbit.com</A><BR></DIV></DIV></div></body></html>
--0-1725493675-1302187530=:58622--


--===============4618605380480965066==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4618605380480965066==--
