Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7FHErT6196058
	for <linux-xfs@oss.sgi.com>; Sun, 15 Aug 2010 12:14:54 -0500
Received: from snt0-omc3-s3.snt0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7289C170DAAE
	for <linux-xfs@oss.sgi.com>; Sun, 15 Aug 2010 10:15:20 -0700 (PDT)
Received: from snt0-omc3-s3.snt0.hotmail.com (snt0-omc3-s3.snt0.hotmail.com
	[65.55.90.142]) by cuda.sgi.com with ESMTP id WAX197v40nEYjZZo
	for <linux-xfs@oss.sgi.com>; Sun, 15 Aug 2010 10:15:20 -0700 (PDT)
Message-ID: <SNT104-W533E69E197AA3214D7B9AA99A0@phx.gbl>
From: Jason de Ugalde <jasondeugalde@hotmail.com>
Subject: Possible bug in getfattr program
Date: Sun, 15 Aug 2010 17:15:20 +0000
In-Reply-To: <SNT104-W4309E4DD3E068292EA086FA99A0@phx.gbl>
References: <SNT104-W4309E4DD3E068292EA086FA99A0@phx.gbl>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7043647906984807028=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com, a.gruenbacher@bestbits.at

--===============7043647906984807028==
Content-Type: multipart/alternative;
	boundary="_837d6354-4709-483b-b11b-ca0d806dcad1_"

--_837d6354-4709-483b-b11b-ca0d806dcad1_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hi=2C

I'm not sure whether this is a deliberate feature or a bug=2C but for some =
reason the getfattr command won't give me a list of a file's system extende=
d attributes when I use the -d option.

For example=2C all of my files have a system.ntfs_times extended attribute.=
 But when I type the following:

getfattr -d -m "^system\." *

or=20

getfattr -d -m "^system\\." *

I get no output (incidentally can you tell me why a double backslash is req=
uired?)

However=2C if I type:

getfattr -d -n system.ntfs_times *

I do get a list of attributes.

Can you tell me if I'm doing something wrong=2C or whether this is a bug?

Thanks=2C

Jason de Ugalde

 		 	   		  =

--_837d6354-4709-483b-b11b-ca0d806dcad1_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Tahoma
}
--></style>
</head>
<body class=3D'hmmessage'>
Hi=2C<br><br>I'm not sure whether this is a deliberate feature or a bug=2C =
but for some reason the getfattr command won't give me a list of a file's s=
ystem extended attributes when I use the -d option.<br><br>For example=2C a=
ll of my files have a system.ntfs_times extended attribute. But when I type=
 the following:<br><br>getfattr -d -m "^system\." *<br><br>or <br><br>getfa=
ttr -d -m "^system\\." *<br><br>I get no output (incidentally can you tell =
me why a double backslash is required?)<br><br>However=2C if I type:<br><br=
>getfattr -d -n system.ntfs_times *<br><br>I do get a list of attributes.<b=
r><br>Can you tell me if I'm doing something wrong=2C or whether this is a =
bug?<br><br>Thanks=2C<br><br>Jason de Ugalde<br><br> 		 	   		  </body>
</html>=

--_837d6354-4709-483b-b11b-ca0d806dcad1_--


--===============7043647906984807028==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7043647906984807028==--
