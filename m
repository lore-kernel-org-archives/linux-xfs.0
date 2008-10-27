Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 07:10:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDsfB3028560
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:54:42 -0700
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6544D54B98E
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:54:39 -0700 (PDT)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by cuda.sgi.com with ESMTP id d29g7XiyeVWTdtYA for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:54:39 -0700 (PDT)
Message-ID: <4905C81B.50103@aei.mpg.de>
Date: Mon, 27 Oct 2008 14:54:35 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com>
In-Reply-To: <4905BC13.3030402@drutsystem.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Soltys <nozo@drutsystem.com>
Cc: xfs@oss.sgi.com

Hi Michal

Michal Soltys wrote:
> 
> Wouldn't something like (under xfs_db) :
> 
> getblock -b #block -n
> ncheck -i #inode
> 
> where required #inode is reported by getblock
> 
> do the thing ?
> 

Sounds nice, but my (ancient? 2.8.11) version of xfs_db does not know
getblock (only blockget) since that also matches the command line and
the usage looks about to be right, I'm currently trying that one, e.g.

smartctl reports a bad LBA at 36922326. fdisk tells me the partition
starts at 31069773, hence the block under question is 5852553.

xfs_info tells be a bsize of 4096 which I take as the block size, thus
the xfs block to look at should be 731569, right?

xfs_db> blockget -b 731569 -n
setting block 0/731569 to free1
setting block 0/731569 to free2
xfs_db>

hmm, no inode number. Does that mean this block is not used by any file
currently - which might be perfectly fine since this partition is only
31% full.

Everything right so far?

Cheers

Carsten
