Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 09:24:09 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NHO48G011223
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:24:06 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CFFC122F2EE
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:24:21 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id 2AKTUj7sAsQhIY5N for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 09:24:21 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: XFS file system corrupted beyond repair?
Date: Wed, 23 Jan 2008 09:18:56 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F02535972@pvn-3001.purevideo.local>
In-Reply-To: <4f52331f0801230915p1d3c4c3ala010d9066addb411@mail.gmail.com>
References: <4f52331f0801230915p1d3c4c3ala010d9066addb411@mail.gmail.com>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Fong Vang <sudoyang@gmail.com>, xfs@oss.sgi.com


> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of
> Fong Vang
> Sent: Wednesday, January 23, 2008 9:16 AM
> To: xfs@oss.sgi.com
> Subject: XFS file system corrupted beyond repair?
> 
> One of our servers cannot mount an XFS file system after reboot.
> xfs_check
> and xfs_repair cannot fix the problem.  Both indicate that there are
no
> valid superblock can be found.  Are there any tool that can help
> reconstruct
> the file system.  Doing a hexdump of the partition, it appears there
are
> valid filenames still on there.  Also, the disk has no bad block or
> hardware
> issues.
> 
> Is there anyone on the XFS development team that we can hire to
examine
> the
> file system more closely and see if it can be reconstructed?
> 
> 
> [[HTML alternate version deleted]]
> 

Check the archive for a thread entitled "Repairing a possibly incomplete
xfs_growfs command?"  (It's pretty recent)  I had this issue last week
and the XFS guys were able to help me out.  Maybe there is something in
there that can help.  Most notably, check the output of this command:

# xfs_db -r -c 'sb 0' -c p <device>

If you see agcount = 160, then the solutions provided may apply to your
situation as well.

Cheers,

Mark
