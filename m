Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 02:45:41 -0700 (PDT)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k859jADW022409
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 02:45:20 -0700
Message-ID: <44FD476C.3080009@sgi.com>
Date: Tue, 05 Sep 2006 10:46:20 +0100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: review: propogate return codes from flush routines
References: <44FC0D0F.60403@sgi.com> <1157442848.5844.38.camel@localhost.localdomain>
In-Reply-To: <1157442848.5844.38.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stewart Smith <stewart@flamingspork.com>
Cc: xfs@oss.sgi.com

Stewart Smith wrote:
> On Mon, 2006-09-04 at 12:25 +0100, Lachlan McIlroy wrote:
> 
>>Here's a patch to handle error return values in fs_flush_pages and
>>fs_flushinval_pages.  It changes the prototype of fs_flushinval_pages
>>so we can propogate the errors and handle them at higher layers.  I also 
>>modified xfs_itruncate_start so that it could propogate the error further.
> 
> 
> IMHO this is always a good idea. Although I guess the only concern can
> be getting the right error back (and a useful one). 
In all but one case the patch passes the error back up to the next layer
unmodified.  In xfs_inactive() I've converted the error into VN_INACTIVE_CACHE
since that follows the existing convention.

> 
> 
>>The motivation behind this change was the recent BUG reported due to a
>>direct I/O read trying to write to delayed alloc extents.  While the exact
>>cause of this problem is not known it is possible that fs_flushinval_pages
>>ignored an error while flushing, truncated the pages on the file anyway,
>>and failed to convert all delayed alloc extents.
> 
> 
> from a quick look the patch seems to do as advertised.
> 
> i probably just haven't looked hard enough - but I'm assuming the layers
> higher up deal with the error and: report to user, write log message or
> something if there's a really catastrophic error?
> 
What's a really catastrophic error?

I'll let the higher layers handle the error in their own way - most likely
any errors will result in a failed system call.
