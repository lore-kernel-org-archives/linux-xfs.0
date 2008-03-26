Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Mar 2008 00:54:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2Q7rpbG031393
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 00:53:52 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D9B58E12DC
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 00:54:25 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id p0qyOZ5iyghj8XLB for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 00:54:25 -0700 (PDT)
Date: Wed, 26 Mar 2008 08:51:22 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Serious XFS crash
Message-ID: <20080326085122.2b60f7c7@galadriel.home>
In-Reply-To: <20080325233611.GW103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home>
	<20080325233611.GW103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Le Wed, 26 Mar 2008 10:36:11 +1100 vous écriviez:

> So none of the magic numbers for a directory block match.
> And FWIW, I can't see any XFs magic number in that block.
> 

There weren't any directory. As a matter of fact this FS was used to
dump (thru samba) big videos files for later use. After the repair,
there were several directories in lost+found, though...


> Oh, that's toast. Something has overwritten the start of the
> filesystem and it does not appear to be other metadata.  Well, not
> exactly the start of the filesystem - the superblock is untouched.
> 

That's weird. 

> What sector size is being used for the XFS filesystem?

Well the /dev/md0 uses 4KB blocks as default IIRC. I'll have to check
this.

> If it's
> not the same as teh filesystem block size, then XFS can't have done
> this itself because the offset that this garbage starts at would
> not be block aligned.....

Could it be an md bug then? I also had some IO errors on this setup
lately due to a dead disk, but I've changed it and it looked OK since
then, until yesterday.

regards,
Emmmanuel.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
