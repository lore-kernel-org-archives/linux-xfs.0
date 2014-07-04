Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A47A29DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 20:29:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CA6E30405F
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 18:29:49 -0700 (PDT)
Received: from mail-we0-f177.google.com (mail-we0-f177.google.com
	[74.125.82.177]) by cuda.sgi.com with ESMTP id by6nXAmenHuXleua
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Jul 2014 18:29:48 -0700 (PDT)
Received: by mail-we0-f177.google.com with SMTP id u56so988887wes.22
	for <xfs@oss.sgi.com>; Thu, 03 Jul 2014 18:29:47 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90]) by mx.google.com with ESMTPSA id
	i12sm65550940wjr.32.2014.07.03.18.29.45 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 03 Jul 2014 18:29:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id DF97960E0E
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 03:29:43 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Wu7YMSMDDQwK for <xfs@oss.sgi.com>;
	Fri,  4 Jul 2014 03:29:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id B9CE860D9B
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 03:29:43 +0200 (CEST)
Date: Fri, 4 Jul 2014 03:29:31 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <20140704000426.GX4453@dastard>
Message-ID: <alpine.LSU.2.11.1407040317120.9881@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703094347.GU4453@dastard>
	<alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
	<20140704000426.GX4453@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Friday, 2014-07-04 at 10:04 +1000, Dave Chinner wrote:
> On Fri, Jul 04, 2014 at 01:34:52AM +0200, Carlos E. R. wrote:

>> Ah, but my problem would then not happen always on the same
>> partition. It would affect others, would not?
>
> It needs a busy/dirty filesystem. if the other filesystems are
> mostly idle, then they are unlikely to trip over the problem.

Right...

>> Ok, true, there is no formal "Oops".
>>
>> But no, the system does not remains fine, I had to hit the hardware
>> reset or power off button to get out.
>
> That usually only happens when the root filesystem is shut down and
> you can't access any of the binaries needed to run the system. Is
> the filesystem that is shutting down the root?

No, it is not. Root is separate and using ext4. The problematic one is 
/home.


What I did, as far I remember, was, when I noticed that home had failed 
and was read only, to switch to runlevel 1, umount /home (killing the apps 
that were still using it), then tried to mount it again to replay the log, 
prior to using xfs-repair on it. Mount hung. ctrl-alt-supr failed, or 
appeared to fail. So reset button...



>> But it only happens on the /home partition, not on the email
>> partition, for instance, also in the same hard disk.
>
> /home is typically where all the application have open files and are
> writing data to.
>
> Email partitions are unlikely to have problems because email
> programs are pretty good about using fsync() to ensure your email
> doesn't go missing and so aren't dirty at the time of a hibernation.

Ok, understood.


>> No, the on disk filesystem is not healthy. If I continue using it,
>> after reboot and using "xfs_repair" several times, it fails again
>> within a day.
>
> After at least one hibernation and thaw cycle, right?

Yes. 3, I think.

But there were kernel errors right after boot (XFS_WANT_CORRUPTED_RETURN).


> FWIW, to rule out other issues with repair, you should probably
> upgrade to the 3.2.0 xfsprogs release...

I may try that... I see it is available on http://download.opensuse.org/repositories/filesystems/openSUSE_13.1/,
version xfsprogs-3.2.0


Ok, I'll work on it.


- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlO2A4cACgkQtTMYHG2NR9UABgCfZm0bbTGbOU80+V7BKyCi9cdB
yqAAn16udhFKpvx+ABdb/rplzZV7Kal+
=jaUl
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
