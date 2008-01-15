Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 07:18:23 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0FFHnQu027243
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 07:17:51 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEB1851F1A5
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 07:18:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id GRCUC4r4kROJbVYs for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 07:18:06 -0800 (PST)
Message-ID: <478CCEAC.9010008@sandeen.net>
Date: Tue, 15 Jan 2008 09:18:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Question related to XFS sync , especially fsync
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>	 <20080114224245.GT155259@sgi.com> <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
In-Reply-To: <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Chris Wedgwood <cw@f00f.org>, Matthias Schniedermeyer <ms@citd.de>, =?windows-1252?Q?Olaf_Fra=3Bczyk?= <olaf@cbk.poznan.pl>, Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

Gopala Krishna wrote:
> Hi All,
> Thanks a lot for your response.
> I never thought it might be in a log and not flushed to disk.
> Very good clue.
> 
>>>> It is not XFS problem. It is your problem ;)
> Good comment. Agreed : -).
> 
>>> How are you finding and inode off disk
> 
> I have lot of code getting in to that. To explain that I have to go through
> that complex part of the code to explain in detail.
> 
> Basically once we get indoe number for a given file from the available
> system call, we only depending upon the XFS layout and it's structure.  We
> are  reading super block from a particular disk offset  and calculating
> address for inode offset and its address on the disk and reading directly
> from the disk offset. We are totally depending on XFS on disk layout.

Can I ask why you are doing this? :)

-Eric
