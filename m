Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9V9rQun119543 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 04:53:26 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 455D61BC35B4
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 02:54:46 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id J9J0aGRApAk7zIDR
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 02:54:46 -0700 (PDT)
Message-ID: <4CCD3CE6.8060407@hardwarefreak.com>
Date: Sun, 31 Oct 2010 04:54:46 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair of critical volume
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
In-Reply-To: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
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
To: xfs@oss.sgi.com
Cc: ermorris@ucsc.edu

Eli Morris put forth on 10/31/2010 2:54 AM:
> Hi,
> 
> I have a large XFS filesystem (60 TB) that is composed of 5 hardware RAID 6 volumes. One of those volumes had several drives fail in a very short time and we lost that volume. However, four of the volumes seem OK. We are in a worse state because our backup unit failed a week later when four drives simultaneously went offline. So we are in a bad very state. I am able to mount the filesystem that consists of the four remaining volumes. I was thinking about running xfs_repair on the filesystem in hopes it would recover all the files that were not on the bad volume, which are obviously gone. Since our backup is gone, I'm very concerned about doing anything to lose the data that will still have. I ran xfs_repair with the -n flag and I have a lengthly file of things that program would do to our filesystem. I don't have the expertise to decipher the output and figure out if xfs_repair would fix the filesystem in a way that would retain our remaining data or if it would, let's say
 
 t!
>  runcate the filesystem at the data loss boundary (our lost volume was the middle one of the five volumes), returning 2/5 of the filesystem or some other undesirable result. I would post the xfs_repair -n output here, but it is more than a megabyte. I'm hoping some one of you xfs gurus will take pity on me and let me send you the output to look at or give me an idea as to what they think xfs_repair is likely to do if I should run it or if anyone has any suggestions as to how to get back as much data as possible in this recovery.

This isn't the storage that houses the genome data is it?

Unfortunately I don't have an answer for you Eli, or, at least, not one
you would like to hear.  One of the devs will be able to tell you if you
need to start typing the letter of resignation or loading the suicide
pistol.  (Apologies if the attempt at humor during this difficult time
is inappropriate.  Sometimes a grin, giggle, or laugh can help with the
stress, even if for only a moment or two. :)

One thing I recommend is simply posting the xfs_repair output to a web
page so you don't have to email it to multiple people.  If you don't
have an easily accessible resource for this at the university I'll
gladly post it on my webserver and post the URL here to the XFS
list--takes me about 2 minutes.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
