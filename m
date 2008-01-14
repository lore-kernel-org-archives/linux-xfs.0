Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 06:06:25 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0EE6I9P002187
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:06:19 -0800
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06191517AFB
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:06:35 -0800 (PST)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id PhWCzEe99HVcEuNR for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:06:35 -0800 (PST)
Subject: Re: Question related to XFS sync , especially fsync
From: Andi Kleen <andi@firstfloor.org>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
Date: Mon, 14 Jan 2008 15:06:32 +0100
In-Reply-To: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com> (Gopala Krishna's message of "Mon\, 14 Jan 2008 17\:44\:22 +0530")
Message-ID: <p734pdgmrh3.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: xfs@oss.sgi.com

"Gopala Krishna" <gopalakrishna.n.m@gmail.com> writes:
> ======
> Basically I am extracting metadata information for a given file by reading
> the inode structure from the particular disk offset (based on it's  position
> calculated by published inode structure and super block structure
>  information). Before reading the metada data information from the disk, I
> am calling fsync (I used to call sync, but later I changed to fsync, since
> sync is not guranteed to flush all meta data) 

sync is guaranteed to flush all metadata. But it has other problems
like livelocks.

 to ensure all metadata
> related to file is flushed to disk. Later I am reading particular disk
> offset as per calculation.   I am getting XFS magic field properly after
> mapping to XFs inode structure. However I am not getting dimode properly in
> some cases (not all cases) and it shows 00000 even for regular file and
> directory.

I suspect it's flushed to the log only. You could probably write some other
metadata until the log is completely full and fsync it, then eventually
the first change should be guaranteed to be flushed to the rest of 
the disk.

> If I am doing something wrong 

Well yes it sounds certainly weird what you're attempting.

-Andi
