Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 05:51:09 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0FDp46W020069
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 05:51:05 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00E0711CF87D
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 05:51:16 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.178]) by cuda.sgi.com with ESMTP id 13ZRrErkzFP2ryeZ for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 05:51:16 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so4602580waf.18
        for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 05:51:15 -0800 (PST)
Message-ID: <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
Date: Tue, 15 Jan 2008 19:14:12 +0530
From: "Gopala Krishna" <gopalakrishna.n.m@gmail.com>
Subject: Re: Question related to XFS sync , especially fsync
In-Reply-To: <20080114224245.GT155259@sgi.com>
MIME-Version: 1.0
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
	 <20080114224245.GT155259@sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Chris Wedgwood <cw@f00f.org>, Matthias Schniedermeyer <ms@citd.de>, =?ISO-8859-2?Q?Olaf_Fr=B1czyk?= <olaf@cbk.poznan.pl>, Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

Hi All,
Thanks a lot for your response.
I never thought it might be in a log and not flushed to disk.
Very good clue.

>>>It is not XFS problem. It is your problem ;)
Good comment. Agreed : -).

>>How are you finding and inode off disk

I have lot of code getting in to that. To explain that I have to go through
that complex part of the code to explain in detail.

Basically once we get indoe number for a given file from the available
system call, we only depending upon the XFS layout and it's structure.  We
are  reading super block from a particular disk offset  and calculating
address for inode offset and its address on the disk and reading directly
from the disk offset. We are totally depending on XFS on disk layout.

 To get very much detail , step by step , I have to go through complete code
and lot of calculation involved in this process.  But it is going fine in
most of the cases except when new files are copied and all of you answered
for that.

Thanks alot for your respopnse.

-Gopal.

On 1/15/08, David Chinner <dgc@sgi.com> wrote:
>
> On Mon, Jan 14, 2008 at 05:44:22PM +0530, Gopala Krishna wrote:
> > Hi,
> > I am seeing some strange problem with XFS and would like to know  the
> > expected behavior and if it is faulty is there any patches to resolve
> the
> > problem.
> >
> > Problem:
> > ======
> > Basically I am extracting metadata information for a given file by
> reading
> > the inode structure from the particular disk offset (based on
> it's  position
> > calculated by published inode structure and super block structure
> >  information). Before reading the metada data information from the disk,
> I
> > am calling fsync (I used to call sync, but later I changed to fsync,
> since
> > sync is not guranteed to flush all meta data)  to ensure all metadata
> > related to file is flushed to disk. Later I am reading particular disk
> > offset as per calculation.   I am getting XFS magic field properly after
> > mapping to XFs inode structure. However I am not getting dimode properly
> in
> > some cases (not all cases) and it shows 00000 even for regular file and
> > directory.
>
> How are you finding and reading the inode off disk?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>


[[HTML alternate version deleted]]
