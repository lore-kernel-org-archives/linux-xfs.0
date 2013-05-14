Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25DC97CBF
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 00:11:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14310304066
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 22:11:18 -0700 (PDT)
Received: from postout.lrz.de (postout.lrz.de [129.187.254.115]) by
	cuda.sgi.com with ESMTP id 0INzsFXaLh3M2SXb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 22:11:17 -0700 (PDT)
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
	by postout3.mail.lrz.de (Postfix) with ESMTP id C30B0200BF
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 07:11:15 +0200 (CEST)
Received: from postout3.mail.lrz.de ([127.0.0.1])
	by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new,
	port 20024) with LMTP id zvel4L8vZ-Yb for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 07:11:15 +0200 (CEST)
Received: from [129.187.173.101] (h101.tum.vpn.lrz.de [129.187.173.101])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by postout3.mail.lrz.de (Postfix) with ESMTPSA id 0DA3F200BB
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 07:11:14 +0200 (CEST)
Message-ID: <5191C772.4020607@tum.de>
Date: Tue, 14 May 2013 07:11:14 +0200
From: Benedikt Schmidt <benedikt.schmidt@tum.de>
MIME-Version: 1.0
Subject: Re: xfs_repair force_geometry
References: <5190DB7F.2050505@tum.de> <519165F2.80902@sandeen.net>
In-Reply-To: <519165F2.80902@sandeen.net>
Reply-To: benediktibk@aon.at
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6325062780547609869=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============6325062780547609869==
Content-Type: multipart/alternative;
 boundary="------------040602080101030203060803"

This is a multi-part message in MIME format.
--------------040602080101030203060803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

First of all: Thanks for your very fast and helpful response.

I copied actually only the partition, not the whole disk: /dd_rescue 
--force -r1 /dev/sdd1 /dev/sdc1/
The cause for this is that I don't have enough space left on another 
device to store a whole copy of the faulty disk. I thought it would be 
possible, like in some examples I found with google, that you can rescue 
a partition directly.

/file -s /dev/sdc1/ says:
//dev/sdc1: data/

The disks look like this (/fdisk -l/):
/Disk /dev/sdc: 3000.6 GB, 3000592982016 bytes, 5860533168 sectors//
//Units = Sektoren of 1 * 512 = 512 bytes//
//Sector size (logical/physical): 512 bytes / 4096 bytes//
//I/O size (minimum/optimal): 4096 bytes / 4096 bytes//
//Disk identifier: 0xcba506ee//
//
//   Gerät  boot.     Anfang        Ende     Blöcke   Id System//
///dev/sdc1             256   732566645   366283195   83 Linux//
//
//Disk /dev/sdd: 2000.4 GB, 2000397852160 bytes, 3907027055 sectors//
//Units = Sektoren of 1 * 512 = 512 bytes//
//Sector size (logical/physical): 512 bytes / 512 bytes//
//I/O size (minimum/optimal): 512 bytes / 512 bytes//
//Disk identifier: 0x3c34826b//
//
//   Gerät  boot.     Anfang        Ende     Blöcke   Id System//
///dev/sdd1              63  3907024064  1953512001   83 Linux/

If it is not possible to rescue the partition this way I will have to 
extend my to RAID5 so that I can put the copy of the faulty disk on this 
one, like Michael explained in his answer. I just hoped that I can avoid 
this, because it would save me more than 100EUR.

As last information: The content of this copy is not totally lost, 
actually only the last few files I have added. All the other stuff is 
already stored on the RAID5, only the latest stuff is not contained in 
this backup. So I don't loose everything if something goes wrong (at 
least one thing :-) ).

Kind regards,
Benedikt

--------------040602080101030203060803
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">First of all: Thanks for your very fast
      and helpful response.<br>
      <br>
      I copied actually only the partition, not the whole disk: <i>dd_rescue
        --force -r1 /dev/sdd1 /dev/sdc1</i><br>
      The cause for this is that I don't have enough space left on
      another device to store a whole copy of the faulty disk. I thought
      it would be possible, like in some examples I found with google,
      that you can rescue a partition directly.<br>
      <br>
      <i>file -s /dev/sdc1</i> says:<br>
      <i>/dev/sdc1: data</i><br>
      <br>
      The disks look like this (<i>fdisk -l</i>):<br>
      <i>Disk /dev/sdc: 3000.6 GB, 3000592982016 bytes, 5860533168
        sectors</i><i><br>
      </i><i>Units = Sektoren of 1 * 512 = 512 bytes</i><i><br>
      </i><i>Sector size (logical/physical): 512 bytes / 4096 bytes</i><i><br>
      </i><i>I/O size (minimum/optimal): 4096 bytes / 4096 bytes</i><i><br>
      </i><i>Disk identifier: 0xcba506ee</i><i><br>
      </i><i><br>
      </i><i>&nbsp;&nbsp; Ger&auml;t&nbsp; boot.&nbsp;&nbsp;&nbsp;&nbsp; Anfang&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ende&nbsp;&nbsp;&nbsp;&nbsp; Bl&ouml;cke&nbsp;&nbsp; Id&nbsp;
        System</i><i><br>
      </i><i>/dev/sdc1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp; 732566645&nbsp;&nbsp; 366283195&nbsp;&nbsp; 83&nbsp;
        Linux</i><i><br>
      </i><i><br>
      </i><i>Disk /dev/sdd: 2000.4 GB, 2000397852160 bytes, 3907027055
        sectors</i><i><br>
      </i><i>Units = Sektoren of 1 * 512 = 512 bytes</i><i><br>
      </i><i>Sector size (logical/physical): 512 bytes / 512 bytes</i><i><br>
      </i><i>I/O size (minimum/optimal): 512 bytes / 512 bytes</i><i><br>
      </i><i>Disk identifier: 0x3c34826b</i><i><br>
      </i><i><br>
      </i><i>&nbsp;&nbsp; Ger&auml;t&nbsp; boot.&nbsp;&nbsp;&nbsp;&nbsp; Anfang&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ende&nbsp;&nbsp;&nbsp;&nbsp; Bl&ouml;cke&nbsp;&nbsp; Id&nbsp;
        System</i><i><br>
      </i><i>/dev/sdd1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp; 3907024064&nbsp; 1953512001&nbsp;&nbsp; 83&nbsp;
        Linux</i><br>
      <br>
      If it is not possible to rescue the partition this way I will have
      to extend my to RAID5 so that I can put the copy of the faulty
      disk on this one, like Michael explained in his answer. I just
      hoped that I can avoid this, because it would save me more than
      100&#8364;.<br>
      <br>
      As last information: The content of this copy is not totally lost,
      actually only the last few files I have added. All the other stuff
      is already stored on the RAID5, only the latest stuff is not
      contained in this backup. So I don't loose everything if something
      goes wrong (at least one thing :-) ).<br>
      <br>
      Kind regards,<br>
      Benedikt<br>
    </div>
  </body>
</html>

--------------040602080101030203060803--


--===============6325062780547609869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6325062780547609869==--
