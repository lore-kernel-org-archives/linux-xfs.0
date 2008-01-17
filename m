Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 12:10:22 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0HKAFst031000
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 12:10:18 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C2E4C777BA
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 12:10:32 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id O4ha35fHTRDoxFZX for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 12:10:32 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Repairing a possibly incomplete xfs_growfs command?
Date: Thu, 17 Jan 2008 12:04:47 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F02535954@pvn-3001.purevideo.local>
In-Reply-To: <478FA832.7030200@sandeen.net>
References: <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local> <478FA832.7030200@sandeen.net>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com


> -----Original Message-----
> From: Eric Sandeen [mailto:sandeen@sandeen.net]
> Sent: Thursday, January 17, 2008 11:11 AM
> To: Mark Magpayo
> Cc: David Chinner; xfs@oss.sgi.com
> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
> 
> Mark Magpayo wrote:
> 
> > Someone else asked for the size of the block devices... here's the
> > output from /proc/partitions:
> >
> > 152     0 9523468862 etherd/e1.0
> > 152    16 9523468862 etherd/e0.0
> 
> 
> are those two assembled into your actual block device?  They look each
> about 8T.
> 
> Is the lvm device also in /proc/partitions?
> 
> -Eric

Here's the entire output:

major minor  #blocks  name

   3     0     512000 hda
   3     1     511528 hda1
 152     0 9523468862 etherd/e1.0
 152    16 9523468862 etherd/e0.0
 254     0 19046932480 dm-0


I believe dm-0 is the lvm device.

Thanks,

Mark
