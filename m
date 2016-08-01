Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 504EB7D15
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 07:23:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14ACB304048
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 05:23:45 -0700 (PDT)
Received: from smtp.movistar.es (smtp21.acens.net [86.109.99.145]) by
	cuda.sgi.com with ESMTP id zxoDf7n3fR7soA57 for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 05:23:43 -0700 (PDT)
Received: from minas-tirith.valinor (95.126.209.47) by smtp.movistar.es
	(8.6.122.03) (authenticated as robin.listas2)
	id 574060E703944F45 for xfs@oss.sgi.com; Mon, 1 Aug 2016 12:23:42 +0000
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 554071814D5
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 14:23:41 +0200 (CEST)
Date: Mon, 1 Aug 2016 14:23:41 +0200 (CEST)
From: "Carlos E. R." <robin.listas@telefonica.net>
Subject: Re: partition 100% full No space left on device. looks like xfs
	iscorrupted or a bug
In-Reply-To: <57CF7681619F42CCB4C0CF589E9686E5@dinulap>
Message-ID: <alpine.LSU.2.20.1608011410500.18210@zvanf-gvevgu.inyvabe>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<20160729233524.GD16044@dastard>
	<57CF7681619F42CCB4C0CF589E9686E5@dinulap>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	BOUNDARY="-1463758550-1059158630-1470053550=:18210"
Content-ID: <alpine.LSU.2.20.1608011420580.18210@zvanf-gvevgu.inyvabe>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463758550-1059158630-1470053550=:18210
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.20.1608011412381.18210@zvanf-gvevgu.inyvabe>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.20.1608011420580.18210@zvanf-gvevgu.inyvabe>


El 2016-08-01 a las 15:00 +0300, Lista Unx escribió:
> El 2016-07-30 a las 09:35 +1000, Dave Chinner escribió:

>> That is, inodes are dynamically allocated so the number of supported
>> inodes is directly proportional to the amount of free space left in
>> the filesystem. You have filesystems with different amounts
>
> NO! Booth systems are almost identical (minor differencies) and this has been 
> stated very clear on my first post. That's not necessary to comment each line 
> in my post, just to point us in the right direction.

They are identical, except that one has free space and the other does 
not.

Number of inodes is dynamic and associated to free space. No free space, 
thus, almost no inodes available. One thing follows from the other.

>> That's probably because there are open but unlinked files present in
>> the filesystem, and du will not find them. e.g. large O_TMPFILE
>> files, or files that applications are using as scratch space. You
>> may even have zombie processes hanging about holding unlinked files
>> open.

> Has been mentioned on my first post, reboot does not solve problem, 
> there are no (large, small or any kind of files)
> exahusting inodes!

Dave refers to a unix/linux "feature". Files can be deleted, but if 
they are in use at the time, the contents are not deleted. Disk shows an 
ammount of free space that does not match the total - used space.

However, a reboot clears this situation, and you did say in the original 
post you had rebooted the system.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlefP00ACgkQja8UbcUWM1xEEQD+P6UaCgpP4L/ZES7wmVBBgLib
Rx78tVXJJKE5+FCQAY8BAI+6boqtqicVZA3PeOYM8PCa9IrRKyHffx3l5ty0LKpI
=h9xF
-----END PGP SIGNATURE-----
---1463758550-1059158630-1470053550=:18210
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463758550-1059158630-1470053550=:18210--
