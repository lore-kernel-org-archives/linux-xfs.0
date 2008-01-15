Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 14:24:24 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0FMOI78010797
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 14:24:20 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFBFA522B04
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 14:24:32 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id pp0bD6ULC8UZuxxt for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 14:24:32 -0800 (PST)
Subject: Re: Question related to XFS sync , especially fsync
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <478CCEAC.9010008@sandeen.net>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
	 <20080114224245.GT155259@sgi.com>
	 <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
	 <478CCEAC.9010008@sandeen.net>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 09:26:52 +1100
Message-Id: <1200436012.9463.184.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, Chris Wedgwood <cw@f00f.org>, Matthias Schniedermeyer <ms@citd.de>, "Olaf Fra;czyk" <olaf@cbk.poznan.pl>, Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

On Tue, 2008-01-15 at 09:18 -0600, Eric Sandeen wrote:
> 
> > I have lot of code getting in to that. To explain that I have to go
> through
> > that complex part of the code to explain in detail.
> > 
> > Basically once we get indoe number for a given file from the
> available
> > system call, we only depending upon the XFS layout and it's
> structure.  We
> > are  reading super block from a particular disk offset  and
> calculating
> > address for inode offset and its address on the disk and reading
> directly
> > from the disk offset. We are totally depending on XFS on disk
> layout.
> 
> Can I ask why you are doing this? :)
> 

This would be good to know.  If you absolutely must use inode numbers
instead of path names, you should use the "by-handle" interface (like
xfsdump, xfs_fsr, etc) and not use the ondisk structures directly -
doing so is always "broken by design" and you'll get little sympathy
here for doing so. :)

cheers.

-- 
Nathan
