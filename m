Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 18:09:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0O28tqw014968
	for <linux-xfs@oss.sgi.com>; Tue, 23 Jan 2007 18:08:57 -0800
Date: Wed, 24 Jan 2007 13:07:50 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Will xfs_growfs succeed on a full file system?
Message-ID: <20070124020750.GD44411608@melbourne.sgi.com>
References: <45B6277F.20506@falconstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B6277F.20506@falconstor.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Cc: linux-xfs@oss.sgi.com

On Tue, Jan 23, 2007 at 10:19:27AM -0500, Geir A. Myrestrand wrote:
> Does xfs_growfs depend on some space left on the file system in order to 
> be able to grow it?

Yes, it does require some space to be left because growing the
filesystem can require extending the original last AG to the full
size and that means there may be btree work to be journalled
and hence we have to reserve blocks for that to succeed in all
cases.

> I have a colleague who ran into an issue where a file system resize 
> failed. The file system is 100% full.

Yup, we hit that in QA recently and have an open bug for it.

> Aside from analyzing what happened in his case, should XFS be able to 
> grow a file system that is 100% full?

Yes, it should.

> The device has already been expanded, it is the XFS file system that 
> fails to resize. I just wonder if that is by design, or whether it is an 
> issue.

It's a bug, really, but one you can easily work around by freeing
up about 50k of space. If you've got a really large filesystem, then
you might need to free more space than that.

At some point in my copious amounts of free time I'll fix it properly...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
