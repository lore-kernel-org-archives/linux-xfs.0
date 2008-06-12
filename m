Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 13:15:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5CKFMSD024730
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 13:15:51 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C410ECA056D
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 13:16:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id v4Fcv4D4YOgl6xnt for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 13:16:19 -0700 (PDT)
Message-ID: <4851840F.6060404@sandeen.net>
Date: Thu, 12 Jun 2008 15:16:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Does XFS support sharing blocks?
References: <485157D2.5050906@op.pl>
In-Reply-To: <485157D2.5050906@op.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bogdan <bogdandr@op.pl>
Cc: xfs@oss.sgi.com

Bogdan wrote:
>   Hello.
> 
>   I have a question: does the XFS filesystem support sharing blocks 
> between objects (files, symlinks, fifos, ...). I mean, can 2 distinct 
> objects have their data inside one physical block? If not, what is the 
> "offset" field for in xfs_db output:
> 
> xfs_db> inode 19331
> xfs_db> bmap -d
> data offset 0 startblock 1212 (0/1212) count 1 flag 0

it's simply the block number in the file.

You have a 1 block file, it's first (and only) block is at physical
block 1212 (block 1212 in AG 0)

-Eric
