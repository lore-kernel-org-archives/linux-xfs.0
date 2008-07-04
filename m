Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 20:50:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m643oKkV012452
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 20:50:21 -0700
Received: from web34507.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 226321877C48
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 20:51:23 -0700 (PDT)
Received: from web34507.mail.mud.yahoo.com (web34507.mail.mud.yahoo.com [66.163.178.173]) by cuda.sgi.com with SMTP id wzh0PhFdVmhGNAHW for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 20:51:23 -0700 (PDT)
Date: Thu, 3 Jul 2008 20:51:23 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: user defined cache
In-Reply-To: <1215139205.7187.33.camel@quadski>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <328802.35603.qm@web34507.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, Warwick Boote <wboote@civica.com.au>

--- On Thu, 7/3/08, Warwick Boote <wboote@civica.com.au> wrote:
> Hi all,
> 
> Do you know of setting or layered file system that enables
> me to define
> a large buffer in main memory and cache writes to this
> buffer?
> 
> Obviously i'd need the file system to also read from
> this buffer if the
> data hasn't been flushed to the disk yet.

XFS supports the following mount options, and they do 
increase throughput somewhat on my system:

logbufs=N (helps concurrency)
logbsize=N (helps log buffering)

If you are using an internal XFS log, you may also try 
"nobarrier" to reduce force-to-disk write frequency. 
NB: I have seen this option discussed on this mailing 
list, but I do not see it in the mount(8) man page.

Bear in mind that the XFS log is for metadata, rather than 
actual file data. This may be what you're looking for, or at
least sufficient; if not, my apologies.
-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
