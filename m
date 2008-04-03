Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:11:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NBOwa012728
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:11:26 -0700
Received: from el-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB63891111E
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 16:12:00 -0700 (PDT)
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.180]) by cuda.sgi.com with ESMTP id tcMTuzZGnH82SCCx for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:12:00 -0700 (PDT)
Received: by el-out-1112.google.com with SMTP id y26so1866275ele.8
        for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:11:58 -0700 (PDT)
Message-ID: <4f52331f0804031611u30e706ddk10aa7a4d011df6a2@mail.gmail.com>
Date: Thu, 3 Apr 2008 16:11:58 -0700
From: "Fong Vang" <sudoyang@gmail.com>
Subject: Re: xfs_check running out of memory
In-Reply-To: <1207263793.21048.150.camel@edge.scott.net.au>
MIME-Version: 1.0
References: <4f52331f0804031556n1f00e435g3273c516aacc5d95@mail.gmail.com>
	 <1207263793.21048.150.camel@edge.scott.net.au>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com

if that's the case then why is it running out of memory?  This is a 6.5TB
file systems with millions of files.  The system has 24GB of RAM.  It needs
to hold everything in memory?

On Thu, Apr 3, 2008 at 4:03 PM, Nathan Scott <nscott@aconex.com> wrote:

>
> On Thu, 2008-04-03 at 15:56 -0700, Fong Vang wrote:
> >
> >
> >
> >
> > xfs_check on one of my 64-bit server keeps running out of memory
> > checking a
> > 6.5TB file system with millions of files.  xfsprogs is version 2.9.4
> > One of
> > the man pages online mentions a xfs_check64 version but I can't seem
> > to find
> > this anyway.  Where can I find this tool?
> >
>
> Thats an IRIX remnant.  On 64 bit Linux systems, xfs_db
> (and hence xfs_check) will be built as 64 bit binaries.
>
> Use xfs_repair -n, xfs_check does not scale (and will
> hopefully be replaced by xfs_repair -n someday).
>
> --
> Nathan
>
>


[[HTML alternate version deleted]]
