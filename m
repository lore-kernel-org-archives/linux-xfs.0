Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 11:59:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5FIxmFo023561
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 11:59:48 -0700
Received: from fk-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1E031BA1D98
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 12:00:44 -0700 (PDT)
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.185]) by cuda.sgi.com with ESMTP id TrBxlp7oyZCTl4H0 for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 12:00:44 -0700 (PDT)
Received: by fk-out-0910.google.com with SMTP id 26so3471289fkx.4
        for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 12:00:43 -0700 (PDT)
Message-ID: <74d4a1e10806151200u4f00f0c5xa18e36ab5925ca77@mail.gmail.com>
Date: Sun, 15 Jun 2008 21:00:43 +0200
From: "Paul Guermonprez" <paul@guermonprez.eu>
Subject: Re: xfs_repair aborting ... dir2.c:2133
In-Reply-To: <4853F70F.6010400@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <74d4a1e10806140124s3ed8dfa6x7e5ca656fea0e06e@mail.gmail.com>
	 <4853F70F.6010400@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

hello,

> Do you mean that you did xfsrestore on a previous dump and then tried to
> repair the resulting filesystem?  Maybe the dump was corrupt?

i used dd to copy the xfs part of the original raid disk to my new disk.
in this ss4000e box, xfs partitions are contained in a big partition "IPSTOR"
(built on a raid linear) with a XML descriptor of start/end/...
for logical partitions inside.
so using regular tools was not a option as regular partitions are not seen.
the dd step seems to work fine, but of course i could always try
several times and see if the output is the same.
the output seems like a regular xfs partition,
xfs_repair then mounted as a loop
and got what i was able to get from lost+found.

> If you are willing to provide an xfs_metadump image, Barry would
> probably look into it for you :)

xfs_metadup has been running for more than 6 hours now
(xfs_db at 100% on a recent desktop CPU) and still running.
and all i have is a 230kb file, so i posted it here :
http://dl.free.fr/nHuj52ETY/xfs_metadump.bz2
in theory the important part of the disk contains about
50 folders, with 50 tif files of 30Mo in each, plus other stuff.
tried the lastest version, now using 400%, nice but same result.

> Did anything interesting go wrong before your fs got so mangled?

as i was using this box, i wasn't in contact with the filesystem,
all i can say is that the raid is OK and the disk seem OK too.
( i know it's stupid to use such a box where everything is hidden
won't do it again ! )
the last thing was probably a crach of the system, and impossibility
to reboot the embedded OS of the thing with the drives in.

> xfsrestore did this?  that's pretty weird.

xfs_repair did this. i used dd to copy the data
but again i can't be totally sure of what kind of
strange XFS version IPSTOR is using, perhaps it is not even standard ???
tried to contact them with no luck.

in fact i am trying to exploit my miserable situation to write a
rescue guide for this box, but this last xfs problem is blocking me,
so thanks a lot for your help.

thanks, paul.
