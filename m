Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Oct 2006 16:34:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k93NYYaG025282
	for <xfs@oss.sgi.com>; Tue, 3 Oct 2006 16:34:34 -0700
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5906469BBB
	for <xfs@oss.sgi.com>; Tue,  3 Oct 2006 15:17:13 -0700 (PDT)
Subject: Re: Review: prevent deadlock via async iput from xfs_iunpin
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061003050654.GQ4695059@melbourne.sgi.com>
References: <20061003050654.GQ4695059@melbourne.sgi.com>
Content-Type: text/plain
Date: Wed, 04 Oct 2006 08:17:19 +1000
Message-Id: <1159913839.32536.4.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 2006-10-03 at 15:06 +1000, David Chinner wrote:
> In fixing the recent problems with inode use-after-free in
> xfs_iunpin, we introduced a new deadlock. When iput() is called, it
> can trigger new transactions on the inode if we are dropping the
> final reference. This is a bad thing to do from a xfslogd because it
> is theonly thread that can move the tail of the log forwards.

*nod*, sounds reasonable & your fix looks good to me, Dave.

cheers.

-- 
Nathan
