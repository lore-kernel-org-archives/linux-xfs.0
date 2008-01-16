Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 15:24:56 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0GNOlgr011912
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 15:24:49 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FF72C6920A
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 15:25:04 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id 4dQgQNU1I11IWCck for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 15:25:04 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: Repairing a possibly incomplete xfs_growfs command?
Date: Wed, 16 Jan 2008 15:19:19 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

So I have run across a strange situation which I hope there are some
gurus out there to help.

The original setup was a logical volume of 8.9TB.  I extended the volume
to 17.7TB and attempted to run xfs_growfs.  I am not sure whether the
command actually finished, as after I ran the command, the metadata was
displayed, but there was no nothing that stated the the number of data
blocks had changed.  I was just returned to the prompt, so I'm not sure
whether the command completed or not..

I was unable write to the logical volume I had just created.  I tried to
remount it, but I kept getting an error saying the superblock could not
be read.  I tried running an xfs_repair on the filesystem, and get the
following:

Phase 1 - find and verify superblock...
superblock read failed, offset 19504058859520, size 2048, ag 64, rval 0

fatal error -- Invalid argument


I am not very experienced with xfs (I was following commands in some
documentaion), and I was recommended to post to this mailing list.  If
anyone could provide some help, it would be greatly appreciate.  Also,
if there is any information I can provide to help, I will gladly provide
it.  Thanks in advance!

Sincerely,

Mark
