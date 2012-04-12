Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3C14q95145370 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 20:04:52 -0500
Received: from smtp.epoch.com (smtp.epoch.com [216.172.133.240]) by
	cuda.sgi.com with ESMTP id pkhNfOHEnKjcGO2O for
	<xfs@oss.sgi.com>; Wed, 11 Apr 2012 18:04:50 -0700 (PDT)
Received: from smtp.epoch.com (localhost [127.0.0.1])
	by smtp.epoch.com (Postfix) with ESMTP id 1753035A77E
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 18:04:48 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182])
	by smtp.epoch.com (Postfix) with ESMTPS id BB95135A60A
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 18:04:47 -0700 (PDT)
Received: by wibhr14 with SMTP id hr14so1165765wib.5
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 18:04:46 -0700 (PDT)
MIME-Version: 1.0
From: David Fuller <dfuller@epoch.com>
Date: Wed, 11 Apr 2012 18:04:25 -0700
Message-ID: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
Subject: Fragmentation Issue We Are Having
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8678237588486956467=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8678237588486956467==
Content-Type: multipart/alternative; boundary=001636c5a63c1dd30204bd70f1c3

--001636c5a63c1dd30204bd70f1c3
Content-Type: text/plain; charset=ISO-8859-1

We seen to be having an issue whereby our database server
gets to 90% or higher fragmentation.  When it gets to this point
we would need to remove form production and defrag using the
xfs_fsr tool.  The server does get a lot of writes and reads.  Is
there something we can do to reduce the fragmentation or could
this be a result of hard disk tweaks we use or mount options?

here is some fo the tweaks we do:

/bin/echo "512" > /sys/block/sda/queue/read_ahead_kb
/bin/echo "10000" > /sys/block/sda/queue/nr_requests
/bin/echo "512" > /sys/block/sdb/queue/read_ahead_kb
/bin/echo "10000" > /sys/block/sdb/queue/nr_requests
/bin/echo "noop" > /sys/block/sda/queue/scheduler
/bin/echo "noop" > /sys/block/sdb/queue/scheduler


Adn here are the mount options on one of our servers:

 xfs     rw,noikeep,allocsize=256M,logbufs=8,sunit=128,swidth=2304

the sunit and swidth vary on each server based on disk drives.

We do use LVM on the volume where the mysql data is stored
as we need this for snapshotting.  Here is an example of a current state:

xfs_db -c frag -r /dev/mapper/vgmysql-lvmysql
actual 42586, ideal 3134, fragmentation factor 92.64%



Regards,
David Fuller

--001636c5a63c1dd30204bd70f1c3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

We seen to be having an issue whereby our database server
<div>gets to 90% or higher fragmentation. =A0When it gets to this point=A0<=
/div><div>we would need to remove form production and defrag using the=A0</=
div><div>xfs_fsr=A0tool. =A0The server does get a lot of writes and reads. =
=A0Is</div>

<div>there something we can do to reduce the fragmentation or could</div><d=
iv>this be a result of hard disk tweaks we use or mount options?</div><div>=
<br></div><div>here is some fo the tweaks we do:</div><div><br></div><div>

<div>/bin/echo &quot;512&quot; &gt; /sys/block/sda/queue/read_ahead_kb</div=
><div>/bin/echo &quot;10000&quot; &gt; /sys/block/sda/queue/nr_requests</di=
v><div>/bin/echo &quot;512&quot; &gt; /sys/block/sdb/queue/read_ahead_kb</d=
iv>

<div>/bin/echo &quot;10000&quot; &gt; /sys/block/sdb/queue/nr_requests</div=
><div>/bin/echo &quot;noop&quot; &gt; /sys/block/sda/queue/scheduler</div><=
div>/bin/echo &quot;noop&quot; &gt; /sys/block/sdb/queue/scheduler</div>

</div><div><br></div><div><br></div><div>Adn here are the mount options on =
one of our servers:</div><div><br></div><div>=A0xfs =A0 =A0 rw,noikeep,allo=
csize=3D256M,logbufs=3D8,sunit=3D128,swidth=3D2304=A0</div><div><br></div><=
div>the sunit and swidth vary on each server based on disk drives.</div>

<div><br></div><div>We do use LVM on the volume where the mysql data is sto=
red</div><div>as we need this for snapshotting. =A0Here is an example of a =
current state:</div><div><br></div><div><div>xfs_db -c frag -r /dev/mapper/=
vgmysql-lvmysql</div>

<div>actual 42586, ideal 3134, fragmentation factor 92.64%</div></div><div>=
<br></div><div><br></div><div><br></div><div>Regards,</div><div>David Fulle=
r</div><div><br></div>

--001636c5a63c1dd30204bd70f1c3--


--===============8678237588486956467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8678237588486956467==--
