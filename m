Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DF367F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 08:18:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0EC1BAC008
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 06:18:25 -0700 (PDT)
Received: from na3sys009aog128.obsmtp.com (na3sys009aog128.obsmtp.com
	[74.125.149.141]) by cuda.sgi.com with SMTP id 1YuwXfP4Iju19IOg
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 06:18:24 -0700 (PDT)
Received: by mail-ve0-f200.google.com with SMTP id ox1so2761334veb.11
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 06:18:23 -0700 (PDT)
MIME-Version: 1.0
From: Robert Bennett <rbennett@mail.crawford.com>
Date: Wed, 17 Apr 2013 09:18:00 -0400
Message-ID: <CAFcHYYBBfsoxdaxNaRjnfyG3yVrRJYYfuoA5vNurdmu+1AUCyA@mail.gmail.com>
Subject: Practical file system size question
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4124297147496947253=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4124297147496947253==
Content-Type: multipart/alternative; boundary=20cf3074b9d6e3f17a04da8e5133

--20cf3074b9d6e3f17a04da8e5133
Content-Type: text/plain; charset=ISO-8859-1

We have been running our Storage on XFS for over three years now and are
extremely happy.  We are running each file system on LSI Hardware Raid with
3 RAID groups of 12+2 with 3 Hot Spares, and 8 file systems per Head Node.
These are running on 2TB SAS HDDs.  The individual file system size is 66TB
in this configuration.  The time has come to look into moving to 3TB SAS
HDDs.  With very rudimentary math, this should move us to the neighborhood
of 99TB per file system.  Our OS is linux 2.6.32-279.11.1.el6.x86_64.

The question is - does anyone have experience with this type of
configuration and in particular with 3TB HDDs and a file system size of
99TB?  The rebuild time with 2TB drives is ~ 24 hours.  Should I expect the
rebuild time for the 3TB drives to be ~ 36 hours?

Thanks for all the hard work all of you do on a file system that continues
to dazzle.

-bob
**

--20cf3074b9d6e3f17a04da8e5133
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br clear=3D"all"><div><div>We have been running our Stora=
ge on XFS for over three years now and are extremely happy.=A0 We are runni=
ng each file system on LSI Hardware Raid with 3 RAID groups of 12+2 with 3 =
Hot Spares, and 8 file systems per Head Node.=A0 These are running on 2TB S=
AS HDDs.=A0 The individual file system size is 66TB in this configuration.=
=A0 The time has come to look into moving to 3TB SAS HDDs.=A0 With very rud=
imentary math, this should move us to the neighborhood of 99TB per file sys=
tem.=A0 Our OS is linux 2.6.32-279.11.1.el6.x86_64.<br>

<br></div><div>The question is - does anyone have experience with this type=
 of configuration and in particular with 3TB HDDs and a file system size of=
 99TB?=A0 The rebuild time with 2TB drives is ~ 24 hours.=A0 Should I expec=
t the rebuild time for the 3TB drives to be ~ 36 hours?<br>

<br></div><div>Thanks for all the hard work all of you do on a file system =
that continues to dazzle.<br><br></div><div>-bob<br></div><div dir=3D"ltr">=
<b><span style=3D"font-size:10pt;color:rgb(31,73,125)"></span></b></div></d=
iv>


</div>

--20cf3074b9d6e3f17a04da8e5133--


--===============4124297147496947253==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4124297147496947253==--
