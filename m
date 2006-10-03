Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Oct 2006 16:59:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k93NxOaG028101
	for <xfs@oss.sgi.com>; Tue, 3 Oct 2006 16:59:26 -0700
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57C7246A3A7
	for <xfs@oss.sgi.com>; Tue,  3 Oct 2006 16:58:43 -0700 (PDT)
Subject: Re: Review: clean up inode i_flags handling
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <1159914373.32536.9.camel@edge>
References: <20061003051325.GR4695059@melbourne.sgi.com>
	 <1159914373.32536.9.camel@edge>
Content-Type: text/plain
Date: Wed, 04 Oct 2006 09:58:50 +1000
Message-Id: <1159919930.32536.14.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 2006-10-04 at 08:26 +1000, Nathan Scott wrote:
> On Tue, 2006-10-03 at 15:13 +1000, David Chinner wrote:
> > 
> 
> This part seems like overkill, I'd just do that inline like the clear
> variant, since its just one instruction ...
> 

..but I guess you did it for consistency, as that one instruction is
otherwise going to have to be open coded in a few places ... *shrug*
looks good to me either way.

cheers.

-- 
Nathan
