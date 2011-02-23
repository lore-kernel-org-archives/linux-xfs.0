Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NFdXTP068381 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 09:39:33 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7198812DAE47
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:42:18 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id fRYgpNsHmQDdW9vz for
	<xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:42:18 -0800 (PST)
Date: Wed, 23 Feb 2011 10:42:17 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
In-Reply-To: <20110223163737.3c2fcd0b@harpe.intellique.com>
Message-ID: <alpine.DEB.2.02.1102231041120.15181@p34.internal.lan>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
	<alpine.DEB.2.02.1102231022470.15181@p34.internal.lan>
	<20110223163737.3c2fcd0b@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-532890823-1298475737=:15181"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Erik Gulliksson <erik@gulliksson.org>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-532890823-1298475737=:15181
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 23 Feb 2011, Emmanuel Florac wrote:

> Le Wed, 23 Feb 2011 10:29:15 -0500 (EST)
> Justin Piszcz <jpiszcz@lucidpixels.com> =E9crivait:
>
>>> /c0 Firmware Version =3D FE9X 4.10.00.007
>> The latest is:
>>
>> 9.5.1-9650-Upgrade.zip
>> 9.5.2-9650-Upgrade.zip
>> 9.5.3-9650-Upgrade.zip
>> 9650SE_9690SA_firmware_beta_fw4.10.00.016.zip
>> 9650SE_9690SA_firmware_beta_fw_4.10.00.019.zip <- latest
>
> Hum well, this is beta, I'd rather stick to released firmware :) His
> firmware is actually the latest stable version for the 9650.

Yes, but it specifically addresses issue with resets:


019:
  SCR FIRM03219 Pchip reset interrupt not handled
  SCR FIRM03220 Put parity segment to free state completely when deallocate=
 unused parity segment

016:
SCR 2196:  Unexpected controller soft resets
Fixed an issue with regards to  deferral of write and read commands to help=
 eliminate unexpected soft resets.

SCR 2217: Incomplete unit after multiple power failures when a RAID 1 unit =
is initializing after a rebuild.
This issue is fixed in this firmware version.

SCR 819: Controller may assert when cache is disabled in a RAID5/RAID6 conf=
iguration under heavy I/O load.
This issue is fixed in this firmware version.

SCR 2214: Performance drops during SES polling.
Fixed the issue where performance drops when a Storage Enclosure Processor =
(SEP) takes up to 700-800 msec to respond to SES polling.

Justin.

--655872-532890823-1298475737=:15181
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-532890823-1298475737=:15181--
