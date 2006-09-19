Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 13:07:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8JK7laG005828
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 13:07:48 -0700
Received: from limpet.umeoce.maine.edu (limpet.umeoce.maine.edu [130.111.192.115])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EC2E456BC7
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 13:07:09 -0700 (PDT)
Date: Tue, 19 Sep 2006 13:52:45 -0400 (EDT)
From: Steve Cousins <cousins@limpet.umeoce.maine.edu>
Reply-To: cousins@umit.maine.edu
Subject: Re: swidth with mdadm and RAID6
In-Reply-To: <fc.004c4d192b3470d73b9aca0029fcf469.2b349301@umit.maine.edu>
Message-ID: <Pine.LNX.4.10.10609191335491.2460-100000@limpet.umeoce.maine.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>



On Tue, 19 Sep 2006, Shailendra Tripathi wrote:

> >> Hi Shailendra,
> >> 
> >> I ran the program and it reports:
> >> 
> >> 	Level 6, disks=11 spare_disks=1 raid_disks=10
> >> 
> >> which looks good.   I don't understand why you got:
> >> 
> >> 	Level 5, disks=7 spare_disks=3 raid_disks=5
> >> 
> >> Why would it have 3 spare_disks?
> >
> Perhaps you are running more recent kernel than mine, and, spare_disks 
> now reports only actual spares. It did appear little weired that it 
> reported spare_disks as 3. get_array_info is changed in recent kernels 
> and that should explain this difference.

This is a 2.6.17 kernel.  So, with this in mind, is there a change that I
should try in libdisk/md.c?  Tim had suggested:

	s/nr_disks/raid_disks/

Would this be sufficient? Or should nr_disks be initialized as raid_disks
and then go into the switch clause?

Steve
