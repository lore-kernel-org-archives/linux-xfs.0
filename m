Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 11:46:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47IkAfB010835
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 11:46:12 -0700
Message-ID: <463F7368.8090101@sandeen.net>
Date: Mon, 07 May 2007 13:43:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RESVSP problems
References: <200705072004.22848.lucke@o2.pl>
In-Reply-To: <200705072004.22848.lucke@o2.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lucke@o2.pl
Cc: xfs@oss.sgi.com

Łukasz Fibinger wrote:
> Hello, guys,
> 
> I've been trying to implement RESVSP-based allocation in rtorrent. From the 
> very beginning it has, alas, misbehaved, thus (also considering my very basic 
> programming skills and experience and unfamiliarity with rtorrent's code) 
> after hours of trying to determine what's wrong, I finally observed that 
> blocks of files allocated with RESVSP (previously ftruncated to a proper 
> size) and being downloaded in rtorrent don't have their unwritten flags 
> removed (as confirmed by xfs_bmap -vp).

You've probably hit:
http://oss.sgi.com/bugzilla/show_bug.cgi?id=418
unwritten extents remain unwritten after mmap() modifies them

Bug dchinner about it... ;-)

> In the effect downloaded file 
> promptly corrupts (read: changes its md5sum). What is interesting, files 
> RESVSP-allocated in ktorrent and then imported to rtorrent seem to download 
> properly.
> 
> Everything works properly with ALLOCSP (although I've noticed that while 
> RESVSP worked with l_start = 0 and l_length = size, ALLOCSP worked with 
> l_start = size and l_length = 0; is that intended?).

yeah... ISTR that the arguments are funky.  I can't remember if it's a
bug or not.  :)  FWIW, allocsp just writes zeros to the file, so you
could do it just as well from userspace w/ no fancy ioctls...  ALLOCSP
is a bit pointless if you ask me... though maybe someone knows why it's
there :)

-Eric

> I'm not quite sure what's at fault here. Perhaps rtorrent, as it prides itself 
> on "directly between file pages mapped to memory by the mmap() function and 
> the network stack". I haven't been yet able to determine how it actually 
> writes chunks to files (aforementioned lacks of skills, experience and 
> familiarity). Perhaps it's somehow XFS's fault, hence my posting to this ML. 
> Any help/suggestions would be appreciated.
> 
> Cheers,
> 
> Luke
> 
> 
