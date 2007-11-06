Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 12:56:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA6Ku13c015102
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 12:56:04 -0800
Date: Wed, 7 Nov 2007 07:55:56 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs crash
Message-ID: <20071106205556.GZ995458@sgi.com>
References: <20071105215135.GA12238@e-m.fr> <20071106082632.GU995458@sgi.com> <20071106092157.GB16694@e-m.fr> <20071106160721.GB25295@e-m.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106160721.GB25295@e-m.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Cedric - Equinoxe Media <cedric@e-m.fr>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Nov 06, 2007 at 05:07:21PM +0100, Cedric - Equinoxe Media wrote:
> I just had exactly the same crash again today :
> /dev/sda4 on /filer type xfs (rw,noexec,nosuid,nodev,noatime)

What did xfs_check tell you about the corruption?

> Seems to be again on a setattr() ?

Doing a truncation freeing some blocks.

What is the client doing (i.e. io patterns, application, etc) to
cause this? can you reproduce it without NFS being used? To track
this down I'm going to need a reproducable test case....

Seeing this is a brand new server, have you run and soak or stress
test on the raw storage to confirm it is error free?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
