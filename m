Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 18:44:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0H2ibOr028557
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 18:44:39 -0800
Date: Thu, 17 Jan 2008 13:44:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Question related to XFS sync , especially fsync
Message-ID: <20080117024443.GG155259@sgi.com>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com> <20080114224245.GT155259@sgi.com> <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com> <478CCEAC.9010008@sandeen.net> <1200436012.9463.184.camel@edge.scott.net.au> <d711080c0801152243h7613bbean9daeab8658f75408@mail.gmail.com> <20080116064840.GA5725@puku.stupidest.org> <d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com> <p73ejchkzv7.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ejchkzv7.fsf@bingen.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Gopala Krishna <gopalakrishna.n.m@gmail.com>, Chris Wedgwood <cw@f00f.org>, nscott@aconex.com, xfs@oss.sgi.com

On Thu, Jan 17, 2008 at 02:25:00AM +0100, Andi Kleen wrote:
> "Gopala Krishna" <gopalakrishna.n.m@gmail.com> writes:
> 
> > we need to get information about
> > file like it's extent information and associated block numbers etc.
>  To
> > extract these there is no system call 
> 
> Actually there is the FIOBMAP ioctl for data blocks. e.g. it's used by
> boot loaders like lilo to create a block map to read a file without
> knowledge of the file system. Should work on all file systems that
> support lilo.

On XFS, you should use XFS_IOC_GETBMAPX. It's much faster
and returns lots more information than FIOBMAP. It can also
be used on the attribute fork of the inode, and it works on
directories as well.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
