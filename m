Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49EnXqu228205 for <xfs@oss.sgi.com>; Sun, 9 May 2010 09:49:33 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BEEF3233F6
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 07:51:43 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id PkQJmiMZewozlawf
	for <xfs@oss.sgi.com>; Sun, 09 May 2010 07:51:43 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9CC3D6C3D2
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 09:51:43 -0500 (CDT)
Message-ID: <4BE6CC83.5070305@hardwarefreak.com>
Date: Sun, 09 May 2010 09:53:55 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: failed to read root inode
References: <4BE55A63.8070203@purplehaze.ch>	<4BE5EB5D.5020702@hardwarefreak.com>
	<20100509152818.7481c1e1@galadriel.home>
In-Reply-To: <20100509152818.7481c1e1@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Emmanuel Florac put forth on 5/9/2010 8:28 AM:
> Le Sat, 08 May 2010 17:53:17 -0500 vous =E9criviez:
> =

>> Why did the "crash" of a single disk in a hardware RAID6 cause a
>> kernel freeze?  What is your definition of "disk crash"?  A single
>> physical disk failure should not have caused this under any
>> circumstances.  The RAID card should have handled a single disk
>> failure transparently.
> =

> The RAID array may go west if the disk isn't properly set up,
> particularly if it's a desktop-class drive. =


By design, a RAID6 pack should be able to handle two simultaneous drive
failures before the array goes offline.  According to the OP's post he lost
one drive.  Unless it's a really crappy RAID card or if he's using a bunch
of dissimilar drives causing problems with the entire array, he shouldn't
have had a problem.

This is why I'm digging for more information.  The information he presented
here doesn't really make any sense.  One physical disk failure _shouldn't_
have caused the problems he's experiencing.  I don't think we got the full
story.

Oh, btw, when it comes to SATA drives, there is no difference between
"desktop" and "enterprise" class drives.  They're all the same.  The ones
sold as "enterprise" have merely been firmware matched and QC tested with a
given vendor's SAN/NAS box and then certified for use with it.  The vendor
then sells only that one drive/firmware, maybe two certified drives so they
have a second source in case of shortages or price gouging etc, in their ar=
rays.

According to the marketing droids, the only "true" "enterprise" drives
currently on the market are SAS and fiber channel.  The number of these
drives actually shipping into the server/SAN/NAS storage marketplace is
absolutely tiny compared to SATA drives.  In total unit shipments, SATA is
owning the datacenter as well as the desktop.  Browse the various storage
offerings across the big 3 and then 10 of the 2nd tier players and you'll
find at least 8 out of 10 storage arrays are SATA, the remaining two being
SAS and FC in the "high end" category, and usually over double the price of
the SATA based arrays.  This pricing of SAS/FC is what is driving SATA
adoption.  That and really large read/write caches on the SATA arrays
boosting their performance for many workloads and negating the spindle speed
advantage of the SAS and FC drives.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
