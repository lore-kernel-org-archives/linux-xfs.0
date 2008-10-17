Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 20:03:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H33Hmt001686
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 20:03:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23DA9503827
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 20:05:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 1AkRyIOUZhGhRfYt for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 20:05:00 -0700 (PDT)
Message-ID: <48F800DA.1030002@sandeen.net>
Date: Thu, 16 Oct 2008 22:04:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS_ERROR use - was Re: [PATCH] prevent NULL returns from	d_obtain_alias
References: <20081015192839.GA867@lst.de> <E1KqWzC-00087u-TG@pomaz-ex.szeredi.hu> <20081016180947.GA26285@lst.de> <48F7D814.2080705@sgi.com> <20081017015301.GK25906@disturbed>
In-Reply-To: <20081017015301.GK25906@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Oct 17, 2008 at 11:11:00AM +1100, Timothy Shimmin wrote:
>> Fair enough.
>> But XFS_ERROR is used throughout the function.
>> I've found the whole idea of when and when not to use XFS_ERROR annoying :)
>>
>> I've never used it (other than calling it to stay consistent with the code).
>> Looking at the code, it is used to BUG and print a msg on particular error codes set in xfs_etrap[] -
>> and it does this in xfs_error_trap().
>> Can one not decide to do this at any error point?
>> I can't see where we hook in to set up xfs_etrap.
> 
> You break into the debugger, modify the xfs_etrap array to contain
> the set of errors you want to catch, then continue onwards.

bleah :)

Could these just be turned into tracepoints eventually?  Or maybe for
now allow modifying the array via proc or something... would be easier
to ask a user to do that if you don't have direct access to their kdb
console ;)  It is a handy thing to have, though.

-Eric
