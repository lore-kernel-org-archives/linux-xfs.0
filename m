Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B1FC7CBF
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 07:04:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1ACE230406B
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 05:04:19 -0800 (PST)
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	a2yZ9J0C7V62EMH3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Feb 2013 05:04:18 -0800 (PST)
Received: by mail-ob0-f181.google.com with SMTP id ni5so557307obc.12
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 05:04:17 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 22 Feb 2013 14:04:17 +0100
Message-ID: <CAGot=x-aiATNxBty7FXxV_td7Wx1_Mh8c8ta=mr4hpHxtmv6Nw@mail.gmail.com>
Subject: dozens of xfsaild threads
From: Erik Knight <kutuzof@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2380541025495872505=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2380541025495872505==
Content-Type: multipart/alternative; boundary=e89a8fb201742f9ec804d64fd4da

--e89a8fb201742f9ec804d64fd4da
Content-Type: text/plain; charset=ISO-8859-1

Hi there,

We've recently noticed that our system is experiencing extreme performance
problems when running large workloads. The problem seems to come from
excessive System CPU time. Specifically dozens of xfsaild threads. We used
to have SSD drives but recently switched to HDD, so some of us are thinking
that there may be a configuration issue within XFS that is optimized for
SSD but performs terribly slow on HDD.

Can anyone explain what these threads do, what would cause so many of them
to be running simultaneously or consume so much CPU?

Thanks,
Erik

--e89a8fb201742f9ec804d64fd4da
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi there,<div><br></div><div style>We&#39;ve recently noti=
ced that our system is experiencing extreme performance problems when runni=
ng large workloads. The problem seems to come from excessive System CPU tim=
e. Specifically dozens of xfsaild threads. We used to have SSD drives but r=
ecently switched to HDD, so some of us are thinking that there may be a con=
figuration issue within XFS that is optimized for SSD but performs terribly=
 slow on HDD.=A0</div>
<div style><br></div><div style>Can anyone explain what these threads do, w=
hat would cause so many of them to be running simultaneously or consume so =
much CPU?=A0</div><div style><br></div><div style>Thanks,</div><div style>
Erik</div></div>

--e89a8fb201742f9ec804d64fd4da--


--===============2380541025495872505==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2380541025495872505==--
