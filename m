Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3C2uHHr209944 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 21:56:17 -0500
Received: from smtp.epoch.com (smtp.epoch.com [216.172.133.240]) by
	cuda.sgi.com with ESMTP id jHtylkiEecqsoTj7 for
	<xfs@oss.sgi.com>; Wed, 11 Apr 2012 19:56:13 -0700 (PDT)
Received: from smtp.epoch.com (localhost [127.0.0.1])
	by smtp.epoch.com (Postfix) with ESMTP id EB30535A427
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 19:56:12 -0700 (PDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com [74.125.82.48])
	by smtp.epoch.com (Postfix) with ESMTPS id 72A7D35A413
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 19:56:12 -0700 (PDT)
Received: by wgbdq10 with SMTP id dq10so1011229wgb.5
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 19:56:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120412021626.GX18323@dastard>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412021626.GX18323@dastard>
From: David Fuller <dfuller@epoch.com>
Date: Wed, 11 Apr 2012 19:55:50 -0700
Message-ID: <CADrkzim1B9fU5sK73uGicPpr7D+ANPwKWGdMS7TroyoX5ncdOw@mail.gmail.com>
Subject: Re: Fragmentation Issue We Are Having
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2872207261600019340=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2872207261600019340==
Content-Type: multipart/alternative; boundary=001636c5a63c8d3d4804bd727f73

--001636c5a63c8d3d4804bd727f73
Content-Type: text/plain; charset=ISO-8859-1

Dave,

Thanks so much for that informative read.  This helps me fight my case that
systematic
defrags are not needed and are bad for the system in general.

After reading this I did do some checks against some of our larger tables
and found that
on average we are storing about 2.5GB per extent. For me that seems pretty
reasonable
to me and does not require defrag'ing at this time.

--David Fuller


<http://www.topshelfads.com/email/sig/epochbestbilling.jpg>


On Wed, Apr 11, 2012 at 7:16 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Apr 11, 2012 at 06:04:25PM -0700, David Fuller wrote:
> > We seen to be having an issue whereby our database server
> > gets to 90% or higher fragmentation.  When it gets to this point
> > we would need to remove form production and defrag using the
> > xfs_fsr tool.
>
> Bad assumption.
>
> > The server does get a lot of writes and reads.  Is
> > there something we can do to reduce the fragmentation or could
> > this be a result of hard disk tweaks we use or mount options?
> >
> > here is some fo the tweaks we do:
> >
> > /bin/echo "512" > /sys/block/sda/queue/read_ahead_kb
> > /bin/echo "10000" > /sys/block/sda/queue/nr_requests
> > /bin/echo "512" > /sys/block/sdb/queue/read_ahead_kb
> > /bin/echo "10000" > /sys/block/sdb/queue/nr_requests
> > /bin/echo "noop" > /sys/block/sda/queue/scheduler
> > /bin/echo "noop" > /sys/block/sdb/queue/scheduler
>
> They have no effect on filesystem fragmentation.
>
> > Adn here are the mount options on one of our servers:
> >
> >  xfs     rw,noikeep,allocsize=256M,logbufs=8,sunit=128,swidth=2304
> >
> > the sunit and swidth vary on each server based on disk drives.
> >
> > We do use LVM on the volume where the mysql data is stored
> > as we need this for snapshotting.  Here is an example of a current state:
> >
> > xfs_db -c frag -r /dev/mapper/vgmysql-lvmysql
> > actual 42586, ideal 3134, fragmentation factor 92.64%
>
> Read this first:
>
>
> http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25.__Is_that_bad.3F
>
> Then decide whether 10 extents per file is really a problem or not.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001636c5a63c8d3d4804bd727f73
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dave,<div><br></div><div>Thanks so much for that informative read. =A0This =
helps me fight my case that systematic</div><div>defrags are not needed and=
 are bad for the system in general.</div><div><br></div><div>After reading =
this I did do some checks against some of our larger tables and found that<=
/div>

<div>on average we are storing about 2.5GB per extent. For me that seems pr=
etty reasonable</div><div>to me and does not require defrag&#39;ing at this=
 time.</div><div><br></div><div>--David Fuller</div><div><br><br><a href=3D=
"http://www.topshelfads.com/email/sig/epochbestbilling.jpg" target=3D"_blan=
k"></a><br>


<br><br><div class=3D"gmail_quote">On Wed, Apr 11, 2012 at 7:16 PM, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fr=
omorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div class=3D"im">On Wed, Apr 11, 2012 at 06:04:25PM -0700, David Fuller wr=
ote:<br>
&gt; We seen to be having an issue whereby our database server<br>
&gt; gets to 90% or higher fragmentation. =A0When it gets to this point<br>
&gt; we would need to remove form production and defrag using the<br>
&gt; xfs_fsr tool.<br>
<br>
</div>Bad assumption.<br>
<div class=3D"im"><br>
&gt; The server does get a lot of writes and reads. =A0Is<br>
&gt; there something we can do to reduce the fragmentation or could<br>
&gt; this be a result of hard disk tweaks we use or mount options?<br>
&gt;<br>
&gt; here is some fo the tweaks we do:<br>
&gt;<br>
&gt; /bin/echo &quot;512&quot; &gt; /sys/block/sda/queue/read_ahead_kb<br>
&gt; /bin/echo &quot;10000&quot; &gt; /sys/block/sda/queue/nr_requests<br>
&gt; /bin/echo &quot;512&quot; &gt; /sys/block/sdb/queue/read_ahead_kb<br>
&gt; /bin/echo &quot;10000&quot; &gt; /sys/block/sdb/queue/nr_requests<br>
&gt; /bin/echo &quot;noop&quot; &gt; /sys/block/sda/queue/scheduler<br>
&gt; /bin/echo &quot;noop&quot; &gt; /sys/block/sdb/queue/scheduler<br>
<br>
</div>They have no effect on filesystem fragmentation.<br>
<div class=3D"im"><br>
&gt; Adn here are the mount options on one of our servers:<br>
&gt;<br>
&gt; =A0xfs =A0 =A0 rw,noikeep,allocsize=3D256M,logbufs=3D8,sunit=3D128,swi=
dth=3D2304<br>
&gt;<br>
&gt; the sunit and swidth vary on each server based on disk drives.<br>
&gt;<br>
&gt; We do use LVM on the volume where the mysql data is stored<br>
&gt; as we need this for snapshotting. =A0Here is an example of a current s=
tate:<br>
&gt;<br>
&gt; xfs_db -c frag -r /dev/mapper/vgmysql-lvmysql<br>
&gt; actual 42586, ideal 3134, fragmentation factor 92.64%<br>
<br>
</div>Read this first:<br>
<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_comman=
d_says_I.27m_over_50.25.__Is_that_bad.3F" target=3D"_blank">http://xfs.org/=
index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25.__=
Is_that_bad.3F</a><br>


<br>
Then decide whether 10 extents per file is really a problem or not.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--001636c5a63c8d3d4804bd727f73--


--===============2872207261600019340==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2872207261600019340==--
