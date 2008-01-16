Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 00:17:18 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0G8HCAf026546
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 00:17:14 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B42AB525284
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 00:17:30 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.178]) by cuda.sgi.com with ESMTP id npJGVCXUbE0Q2EGm for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 00:17:30 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so304225waf.18
        for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 00:17:30 -0800 (PST)
Message-ID: <d711080c0801160011g60c5aa93g17b7ab0c1bbb191@mail.gmail.com>
Date: Wed, 16 Jan 2008 13:41:17 +0530
From: "Gopala Krishna" <gopalakrishna.n.m@gmail.com>
Subject: Re: Question related to XFS sync , especially fsync
In-Reply-To: <20080116075215.GA26822@teal.hq.k1024.org>
MIME-Version: 1.0
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
	 <20080114224245.GT155259@sgi.com>
	 <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>
	 <478CCEAC.9010008@sandeen.net>
	 <1200436012.9463.184.camel@edge.scott.net.au>
	 <d711080c0801152243h7613bbean9daeab8658f75408@mail.gmail.com>
	 <20080116064840.GA5725@puku.stupidest.org>
	 <d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com>
	 <20080116075215.GA26822@teal.hq.k1024.org>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>, Chris Wedgwood <cw@f00f.org>, nscott@aconex.com, xfs@oss.sgi.com

You are right and that is the approach I will follow if there is no direct
system call.

Thanks,
Gopal.


On 1/16/08, Iustin Pop <iusty@k1024.org> wrote:
>
> On Wed, Jan 16, 2008 at 12:55:17PM +0530, Gopala Krishna wrote:
> > If there is a user level system call to deal with the extent information
> > etc, we can use , but many file system is not providing that. Basically
> if
> > we give file it should eb in aposition to display metadata informations
> > including extents and corresponding logical block numbers and device
> > offsets.
> >
> > I have to do it programitically and hence if I have some system call
> rather
> > than command, that would be helpful. Freeze/unfreeze is a command it
> seems
> > right?
>
> Well, most commands are backed by a system call, right? For example,
> strace xfs_freeze to see what system calls it does. IIRC, only xfs_db
> has to access the raw device.
>
> For the block mapping, look at xfs_bmap (and its backend xfs_io), which
> should do exactly what you want.
>
> iustin
>


[[HTML alternate version deleted]]
