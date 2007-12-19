Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 11:44:10 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBJJi29k012521
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 11:44:06 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9A1F118A98C
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 11:44:14 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id Icq7a2iPIBtcW67K for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 11:44:14 -0800 (PST)
Message-ID: <50214.192.168.3.1.1198093481.squirrel@mail.aconex.com>
In-Reply-To: <3136.132.250.11.79.1198081432.squirrel@webmail.nerp.net>
References: <3136.132.250.11.79.1198081432.squirrel@webmail.nerp.net>
Date: Thu, 20 Dec 2007 06:44:41 +1100 (EST)
Subject: Re: Real time volume free space
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan <dan@nerp.net>
Cc: xfs@oss.sgi.com

>
> I've been trying to figure out how to determine the free space of a real
> time volume.  It seems xfs_db might hold the key but no luck so far...
> Simply running df -h tells me the free space of the meta-data drive only
> which basically doesn't change even after Terabyte data collections.
>
> I created the filesystem like this:
>
> mkfs.xfs -r rtdev=/dev/md0 /dev/sda
>
> How would I tell how much space is left on /dev/md0?

The XFS_IOC_FSCOUNTS ioctl exposes this information, and you can use the
xfs_quota "free" command to see it (even if you're not using quotas).  The
df command has no knowledge of the realtime subvolume.

cheers.

--
Nathan
