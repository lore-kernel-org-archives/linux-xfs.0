Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 01:02:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9681naG011482
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 01:01:52 -0700
Received: from zenon.apartia.fr (zenon.apartia.fr [82.66.93.83])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C514846D3DB
	for <xfs@oss.sgi.com>; Fri,  6 Oct 2006 00:53:07 -0700 (PDT)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 5E5DBF518ED0C
	for <xfs@oss.sgi.com>; Fri,  6 Oct 2006 09:52:49 +0200 (CEST)
Date: Fri, 6 Oct 2006 09:52:26 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: is quotacheck fast with xfs?
Message-ID: <20061006075226.GB2414@apartia.fr>
References: <20061005204240.GA7922@apartia.fr> <1160086501.32536.57.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1160086501.32536.57.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, Oct 06, 2006 at 08:15:01AM +1000, Nathan Scott wrote:
> On Thu, 2006-10-05 at 22:42 +0200, Louis-David Mitterrand wrote:
> > 
> > We have a 500GB mail server with 200 users presently with reiserfs. At 
> > boot time quotacheck takes close to one hour.
> > 
> > Would quotacheck be faster on xfs?
> 
> Yes, typically - XFS uses its internal "bulkstat" code to speed up
> the inode scanning process (and it only needs to be done once, on the
> initial mount, and then XFS "remembers" that the check has been done,
> for subsequent mounts and it journals all updates to the quota files),
> whereas the userspace quotacheck(1) program is filesystem independent
> (IIRC) and doesn't implement such optimisations.
> 
> FWIW, quotacheck time is a function of the number of inodes in the
> filesystem, not the number of users.

What you are saying is that userspace quotacheck is not needed with xfs 
(or only once)?
