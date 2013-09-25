Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F2387F3F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 07:56:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0095304032
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 05:56:15 -0700 (PDT)
Received: from mail-oa0-f45.google.com (mail-oa0-f45.google.com
	[209.85.219.45]) by cuda.sgi.com with ESMTP id cu02S3voC8rWx8Mv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Sep 2013 05:56:13 -0700 (PDT)
Received: by mail-oa0-f45.google.com with SMTP id o17so959349oag.32
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 05:56:13 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Sep 2013 13:56:13 +0100
Message-ID: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
Subject: xfs hardware RAID alignment over linear lvm
From: Stewart Webb <stew@messeduphare.co.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8494542312913600004=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8494542312913600004==
Content-Type: multipart/alternative; boundary=047d7b33d5a0354b7d04e734c7e6

--047d7b33d5a0354b7d04e734c7e6
Content-Type: text/plain; charset=ISO-8859-1

Hi All,

I am trying to do the following:
3 x Hardware RAID Cards each with a raid 6 volume of 12 disks presented to
the OS
all raid units have a "stripe size" of 512 KB

so given the info on the xfs.org wiki - I sould give each filesystem a
sunit of 512 KB and a swidth of 10 (because RAID 6 has 2 parity disks)

all well and good

But - I would like to use Linear LVM to bring all 3 cards into 1 logical
volume -
here is where my question crops up:
Does this effect how I need to align the filesystem?

Regards

-- 
Stewart Webb

--047d7b33d5a0354b7d04e734c7e6
Content-Type: text/html; charset=ISO-8859-1

<div dir="ltr">Hi All,<div><br></div><div>I am trying to do the following:</div><div>3 x Hardware RAID Cards each with a raid 6 volume of 12 disks presented to the OS</div><div>all raid units have a &quot;stripe size&quot; of 512 KB</div>
<div><br></div><div>so given the info on the <a href="http://xfs.org">xfs.org</a> wiki - I sould give each filesystem a sunit of 512 KB and a swidth of 10 (because RAID 6 has 2 parity disks)</div><div><br></div><div>all well and good</div>
<div><br></div><div>But - I would like to use Linear LVM to bring all 3 cards into 1 logical volume -</div><div>here is where my question crops up:</div><div>Does this effect how I need to align the filesystem?</div><div>
<br></div><div>Regards</div><div><br></div><div>-- <br><div dir="ltr"><div></div>Stewart Webb<br></div>
</div></div>

--047d7b33d5a0354b7d04e734c7e6--


--===============8494542312913600004==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8494542312913600004==--
