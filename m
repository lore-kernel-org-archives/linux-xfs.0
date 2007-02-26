Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Feb 2007 11:10:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1QJAFm7015358
	for <xfs@oss.sgi.com>; Mon, 26 Feb 2007 11:10:16 -0800
Message-ID: <45E32FE0.4070204@sandeen.net>
Date: Mon, 26 Feb 2007 13:07:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 8.2TB->16.4TB xfs_growfs problem
References: <Pine.OSX.4.64.0702261301250.1185@powerbook.localdomain>
In-Reply-To: <Pine.OSX.4.64.0702261301250.1185@powerbook.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgixfs@foxengines.net
Cc: xfs@oss.sgi.com

XFS User wrote:
> Hello,
> 
> I am experiencing a problem that I'm not sure how to resolve. I do not see
> this in the FAQ, nor have I found it in Bugzilla or the mailing lists, 
> (they both seemed to be having search problems last week which prevented 
> me from using them, I used Google to search into the site so I might've missed 
> something).
> 
> In summary, I have an 8.2TB filesystem on an 16.4TB LVM2 volume on a
> Linux 2.6.18 x86_64 with 4GB RAM.
> If I issue the 'xfs_growfs /mounted_volume' command, the command will
> complete without printing any errors and the command exits on 0.
> 
> I can umount, then mount again, see the new 16TB volume.
> 
> If for any reason, I run xfs_repair, all changes will be lost and the
> filesystem size will revert to it's original size (e.g it'll shrink
> back down to 8.2TB).

There have been userspace & kernelspace fixes to growfs lately...

TAKE 959492 - xfs_growfs should return an error on failure
http://oss.sgi.com/archives/xfs/2006-12/msg00224.html

TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
http://oss.sgi.com/archives/xfs/2007-01/msg00082.html

I'd make sure you have those fixes, first.

-Eric
