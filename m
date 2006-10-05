Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 15:15:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k95MFLaG020593
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 15:15:26 -0700
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 113B64709F8
	for <xfs@oss.sgi.com>; Thu,  5 Oct 2006 15:14:40 -0700 (PDT)
Subject: Re: is quotacheck fast with xfs?
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061005204240.GA7922@apartia.fr>
References: <20061005204240.GA7922@apartia.fr>
Content-Type: text/plain
Date: Fri, 06 Oct 2006 08:15:01 +1000
Message-Id: <1160086501.32536.57.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Cc: xfs@oss.sgi.com

On Thu, 2006-10-05 at 22:42 +0200, Louis-David Mitterrand wrote:
> Hello,
> 
> We have a 500GB mail server with 200 users presently with reiserfs. At 
> boot time quotacheck takes close to one hour.
> 
> Would quotacheck be faster on xfs?
> 

Yes, typically - XFS uses its internal "bulkstat" code to speed up
the inode scanning process (and it only needs to be done once, on the
initial mount, and then XFS "remembers" that the check has been done,
for subsequent mounts and it journals all updates to the quota files),
whereas the userspace quotacheck(1) program is filesystem independent
(IIRC) and doesn't implement such optimisations.

FWIW, quotacheck time is a function of the number of inodes in the
filesystem, not the number of users.

cheers.

-- 
Nathan
