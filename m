Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Oct 2006 16:24:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k93NOTaG024237
	for <xfs@oss.sgi.com>; Tue, 3 Oct 2006 16:24:30 -0700
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28482D17A48E
	for <xfs@oss.sgi.com>; Tue,  3 Oct 2006 15:26:06 -0700 (PDT)
Subject: Re: Review: clean up inode i_flags handling
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061003051325.GR4695059@melbourne.sgi.com>
References: <20061003051325.GR4695059@melbourne.sgi.com>
Content-Type: text/plain
Date: Wed, 04 Oct 2006 08:26:13 +1000
Message-Id: <1159914373.32536.9.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 2006-10-03 at 15:13 +1000, David Chinner wrote:
> 

This part seems like overkill, I'd just do that inline like the clear
variant, since its just one instruction ...

+static inline void
+__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+{
+       ip->i_flags |= flags;
+}

Oh, ditto for the test inline func, I guess.

cheers.

-- 
Nathan
