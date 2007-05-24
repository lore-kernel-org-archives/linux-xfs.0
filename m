Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 04:20:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4OBKZWt020464
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 04:20:37 -0700
Date: Thu, 24 May 2007 07:20:35 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
In-Reply-To: <200705241318.30711.dap@mail.index.hu>
Message-ID: <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan>
References: <200705241318.30711.dap@mail.index.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pallai Roland <dap@mail.index.hu>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

Including XFS mailing list on this one.

On Thu, 24 May 2007, Pallai Roland wrote:

>
> Hi,
>
> I wondering why the md raid5 does accept writes after 2 disks failed. I've an
> array built from 7 drives, filesystem is XFS. Yesterday, an IDE cable failed
> (my friend kicked it off from the box on the floor:) and 2 disks have been
> kicked but my download (yafc) not stopped, it tried and could write the file
> system for whole night!
> Now I changed the cable, tried to reassembly the array (mdadm -f --run),
> event counter increased from 4908158 up to 4929612 on the failed disks, but I
> cannot mount the file system and the 'xfs_repair -n' shows lot of errors
> there. This is expainable by the partially successed writes. Ext3 and JFS
> has "error=" mount option to switch filesystem read-only on any error, but
> XFS hasn't: why? It's a good question too, but I think the md layer could
> save dumb filesystems like XFS if denies writes after 2 disks are failed, and
> I cannot see a good reason why it's not behave this way.
>
> Do you have better idea how can I avoid such filesystem corruptions in the
> future? No, I don't want to use ext3 on this box. :)
>
>
> my mount error:
> XFS: Log inconsistent (didn't find previous header)
> XFS: failed to find log head
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
>
>
> --
> d
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
