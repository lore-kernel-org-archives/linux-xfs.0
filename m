Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 12:23:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8JJN2aG032733
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 12:23:03 -0700
Received: from limpet.umeoce.maine.edu (limpet.umeoce.maine.edu [130.111.192.115])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3448D176759
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 12:22:23 -0700 (PDT)
Date: Tue, 19 Sep 2006 15:22:16 -0400 (EDT)
From: Steve Cousins <cousins@limpet.umeoce.maine.edu>
Reply-To: cousins@umit.maine.edu
Subject: Re: swidth with mdadm and RAID6
In-Reply-To: <Pine.LNX.4.10.10609191335491.2460-100000@limpet.umeoce.maine.edu>
Message-ID: <Pine.LNX.4.10.10609191517590.2460-100000@limpet.umeoce.maine.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>




On Tue, 19 Sep 2006, Steve Cousins wrote:

> This is a 2.6.17 kernel.  So, with this in mind, is there a change that I
> should try in libdisk/md.c?  Tim had suggested:
> 
> 	s/nr_disks/raid_disks/
> 
> Would this be sufficient? Or should nr_disks be initialized as raid_disks
> and then go into the switch clause?

I ended up just adding:

	md.nr_disks = md.raid_disks;

right be fore the switch statement and it worked fine in my situation.
Not sure how this would work with other kernels etc. but I'll let you
figure that out.  

Thanks very much for your help.

Steve
