Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 08:42:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NGgMqw007076
	for <linux-xfs@oss.sgi.com>; Tue, 23 Jan 2007 08:42:23 -0800
Message-ID: <45B63AA1.8010504@sandeen.net>
Date: Tue, 23 Jan 2007 10:41:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Will xfs_growfs succeed on a full file system?
References: <45B6277F.20506@falconstor.com>
In-Reply-To: <45B6277F.20506@falconstor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: linux-xfs@oss.sgi.com

Geir A. Myrestrand wrote:
> Does xfs_growfs depend on some space left on the file system in order to 
> be able to grow it?
> 
> I have a colleague who ran into an issue where a file system resize 
> failed. The file system is 100% full.
> 
> Aside from analyzing what happened in his case, should XFS be able to 
> grow a file system that is 100% full?
> 
> The device has already been expanded, it is the XFS file system that 
> fails to resize. I just wonder if that is by design, or whether it is an 
> issue.
> 

Off the top of my head, I think it should work ok even if full, although
I could be (and apparently I am) wrong here.  How exactly did the growfs
fail?

I actually wasn't able to completely fill my filesystem, got stuck at
20k left.  :)  but growing that from 50M to 100M worked fine for me.

-Eric
