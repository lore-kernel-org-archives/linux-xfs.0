Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:22:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NMkih020290
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:22:48 -0700
Received: from rn-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FB4873BAE6
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 16:23:22 -0700 (PDT)
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.184]) by cuda.sgi.com with ESMTP id TATIqfTwXXDjLIkv for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:23:22 -0700 (PDT)
Received: by rn-out-0910.google.com with SMTP id j40so2987148rnf.12
        for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:23:22 -0700 (PDT)
Message-ID: <4f52331f0804031623hc880b03i90f1eed342e97f3c@mail.gmail.com>
Date: Thu, 3 Apr 2008 16:23:22 -0700
From: "Fong Vang" <sudoyang@gmail.com>
Subject: Re: xfs_check running out of memory
In-Reply-To: <1207264560.21048.153.camel@edge.scott.net.au>
MIME-Version: 1.0
References: <4f52331f0804031556n1f00e435g3273c516aacc5d95@mail.gmail.com>
	 <1207263793.21048.150.camel@edge.scott.net.au>
	 <4f52331f0804031611u30e706ddk10aa7a4d011df6a2@mail.gmail.com>
	 <1207264560.21048.153.camel@edge.scott.net.au>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com

good to know.  Doesn't xfs_check also repair?  with xfs_repair -n, this
doesn't do any repair.  SO the right approach on big volumes would be to run
xfs_repair -n first to detect problem then xfs_repair to fix?

thank you for the info.  much appreciated.  just, curious.  where did you
get this info?

On Thu, Apr 3, 2008 at 4:16 PM, Nathan Scott <nscott@aconex.com> wrote:

> On Thu, 2008-04-03 at 16:11 -0700, Fong Vang wrote:
> >
> > if that's the case then why is it running out of memory?  This is a
> > 6.5TB file systems with millions of files.  The system has 24GB of
> > RAM.  It needs to hold everything in memory?
>
> xfs_check has 3 per-fs-block arrays that are held all in memory, IIRC.
> Use xfs_repair -n, which has been revamped to scale a whole lot better
> than check.
>
> --
> Nathan
>
>


[[HTML alternate version deleted]]
