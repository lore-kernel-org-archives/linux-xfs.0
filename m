Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 22:43:47 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0G6hc0d017906
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 22:43:42 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 368E8524DC0
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 22:43:57 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.177]) by cuda.sgi.com with ESMTP id sfJ81nCx7R4icHm5 for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 22:43:57 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so256234waf.18
        for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 22:43:54 -0800 (PST)
Message-ID: <d711080c0801152243h7613bbean9daeab8658f75408@mail.gmail.com>
Date: Wed, 16 Jan 2008 12:13:54 +0530
From: "Gopala Krishna" <gopalakrishna.n.m@gmail.com>
Subject: Re: Question related to XFS sync , especially fsync
In-Reply-To: <1200436012.9463.184.camel@edge.scott.net.au>
MIME-Version: 1.0
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
	 <20080114224245.GT155259@sgi.com>
	 <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
	 <478CCEAC.9010008@sandeen.net>
	 <1200436012.9463.184.camel@edge.scott.net.au>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com

Is there any XFS call from user level to flush metadata  for a given file or
complete log  to disk?

Thanks,
Gopal.

On 1/16/08, Nathan Scott <nscott@aconex.com> wrote:
>
> On Tue, 2008-01-15 at 09:18 -0600, Eric Sandeen wrote:
> >
> > > I have lot of code getting in to that. To explain that I have to go
> > through
> > > that complex part of the code to explain in detail.
> > >
> > > Basically once we get indoe number for a given file from the
> > available
> > > system call, we only depending upon the XFS layout and it's
> > structure.  We
> > > are  reading super block from a particular disk offset  and
> > calculating
> > > address for inode offset and its address on the disk and reading
> > directly
> > > from the disk offset. We are totally depending on XFS on disk
> > layout.
> >
> > Can I ask why you are doing this? :)
> >
>
> This would be good to know.  If you absolutely must use inode numbers
> instead of path names, you should use the "by-handle" interface (like
> xfsdump, xfs_fsr, etc) and not use the ondisk structures directly -
> doing so is always "broken by design" and you'll get little sympathy
> here for doing so. :)
>
> cheers.
>
> --
> Nathan
>
>


[[HTML alternate version deleted]]
