Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 23:52:11 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0G7q2fX022717
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:52:05 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9C2E525121
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:52:20 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154]) by cuda.sgi.com with ESMTP id DBXJw2NW3vNOECgi for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:52:20 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so197659fga.8
        for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 23:52:19 -0800 (PST)
Date: Wed, 16 Jan 2008 08:52:15 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: Question related to XFS sync , especially fsync
Message-ID: <20080116075215.GA26822@teal.hq.k1024.org>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com> <20080114224245.GT155259@sgi.com> <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com> <478CCEAC.9010008@sandeen.net> <1200436012.9463.184.camel@edge.scott.net.au> <d711080c0801152243h7613bbean9daeab8658f75408@mail.gmail.com> <20080116064840.GA5725@puku.stupidest.org> <d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: Chris Wedgwood <cw@f00f.org>, nscott@aconex.com, xfs@oss.sgi.com

On Wed, Jan 16, 2008 at 12:55:17PM +0530, Gopala Krishna wrote:
> If there is a user level system call to deal with the extent information
> etc, we can use , but many file system is not providing that. Basically if
> we give file it should eb in aposition to display metadata informations
> including extents and corresponding logical block numbers and device
> offsets.
> 
> I have to do it programitically and hence if I have some system call rather
> than command, that would be helpful. Freeze/unfreeze is a command it seems
> right?

Well, most commands are backed by a system call, right? For example,
strace xfs_freeze to see what system calls it does. IIRC, only xfs_db
has to access the raw device.

For the block mapping, look at xfs_bmap (and its backend xfs_io), which
should do exactly what you want.

iustin
