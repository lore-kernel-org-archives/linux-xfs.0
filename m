Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 08:31:58 -0700 (PDT)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OFVpQ3027710
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 08:31:54 -0700
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: Tips on xfs creation on MIPS R5000 machine running Linux?
Date: Mon, 24 Sep 2007 17:30:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
In-Reply-To: <46F67C7B.6040405@sandeen.net>
Message-Id: <20070924153211.A73AC14EC2F@mail.edu.haifa.ac.il>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Eric Sandeen' <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> Leon Kolchinsky wrote:
> 
> >> 1) Creating FS:
> >> mkfs.xfs -l internal,size=128m -d agcount=2 –d unwritten=0 /dev/hda1
> >>
> >> 2) Mount options:
> >> mount -o noatime,nodiratime,logbufs=8
> 
> Unless you have a reason not to, I always say start with the defaults
> until proven otherwise.
> 
> Why would you want to turn off unwritten extents, or limit the agcount?
> 

Hello Eric,

Thanks for your response.
Actually these options largely taken from "XFS on steroids" topic from
gentoo forums
http://forums.gentoo.org/viewtopic-t-488215-highlight-.html?sid=cfa1762e9e57
9e184be80bd66a620abe

I want to optimize FS for maximum performance (it's not a production box).
What are your suggestions?


Regards,
Leon
