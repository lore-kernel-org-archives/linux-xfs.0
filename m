Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OIr0r9094261 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 13:53:00 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id ysFItYyTtaqAdzAK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 11:52:58 -0700 (PDT)
Date: Sat, 24 Mar 2012 20:52:47 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
In-Reply-To: <4F6E0D28.7000203@sandeen.net>
Message-ID: <alpine.LRH.2.02.1203242029260.18754@mail.vlasiu.net>
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
	<4F6CD1DC.7010706@sandeen.net>
	<alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
	<4F6CD799.9090903@sandeen.net>
	<alpine.LRH.2.02.1203232220010.4760@mail.vlasiu.net>
	<4F6CE137.3020405@sandeen.net>
	<alpine.LRH.2.02.1203232259450.5980@mail.vlasiu.net>
	<4F6E0D28.7000203@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Eric.

On Sat, 24 Mar 2012, Eric Sandeen wrote:

> Any idea what's the oldest kernel this filesystem has been run under?  
> (or maybe more to the point, what kernel versions this particular file 
> was created & modified under?)  There was an attribute fork offset 
> calculation bug long ago, but it's long-since fixed....
The filesystem was created around the end of February 2010 - 25 or 26 - (I 
know that because the previous hdd had some problems and it was replaced). 
The filesystem was not modified in any way since.

At that time I had fedora 12 installed. I do not known exactly what kernel 
version I was using then but I can assume it was between 
kernel-2.6.31.12-174.2.19.fc12 (added to koji on 2010-02-11) and 
kernel-2.6.32.9-64.fc12 (added to koji on 2010-02-24).
Most likely to be 2.6.31.1[12].

See:
https://koji.fedoraproject.org/koji/packageinfo?buildStart=700&packageID=8&buildOrder=-completion_time&tagOrder=name&tagStart=0#buildlist

The filesystem was _not_ created during setup of Fedora 12. I created the 
filesystem after I upgrade the kernel to the latest available at that time 
in Fedora updates or koji (koji most likely).

Since then I had Fedora 13, 14, 15 and now I have Fedora 16.


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 0xE684206E
// OpenGPG-Fingerprint: 0C3D 9F8B 725D E243 CB3C 8428 796A DB1F E684 206E
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9uF/8ACgkQeWrbH+aEIG7G8QCfXpPTZt4gfRUSMlV4xVnNt1aT
Y/kAn2kTrCVgOcu9s2MSbdQnTACPxi2t
=G7wy
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
