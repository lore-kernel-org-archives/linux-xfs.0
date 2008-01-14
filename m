Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 14:42:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0EMgaQ4029308
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 14:42:40 -0800
Date: Tue, 15 Jan 2008 09:42:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Question related to XFS sync , especially fsync
Message-ID: <20080114224245.GT155259@sgi.com>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 14, 2008 at 05:44:22PM +0530, Gopala Krishna wrote:
> Hi,
> I am seeing some strange problem with XFS and would like to know  the
> expected behavior and if it is faulty is there any patches to resolve the
> problem.
> 
> Problem:
> ======
> Basically I am extracting metadata information for a given file by reading
> the inode structure from the particular disk offset (based on it's  position
> calculated by published inode structure and super block structure
>  information). Before reading the metada data information from the disk, I
> am calling fsync (I used to call sync, but later I changed to fsync, since
> sync is not guranteed to flush all meta data)  to ensure all metadata
> related to file is flushed to disk. Later I am reading particular disk
> offset as per calculation.   I am getting XFS magic field properly after
> mapping to XFs inode structure. However I am not getting dimode properly in
> some cases (not all cases) and it shows 00000 even for regular file and
> directory.

How are you finding and reading the inode off disk?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
