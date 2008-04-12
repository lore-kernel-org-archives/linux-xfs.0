Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 20:01:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3C31CEh029726
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 20:01:14 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9608B9B8041
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 20:01:51 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id E9pDnRzpMztItnxa for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 20:01:51 -0700 (PDT)
Date: Fri, 11 Apr 2008 23:01:50 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] de-duplicate calls to xfs_attr_trace_enter
Message-ID: <20080412030150.GB5431@josefsipek.net>
References: <480024CC.8040407@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480024CC.8040407@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 11, 2008 at 09:56:12PM -0500, Eric Sandeen wrote:
> Every call to xfs_attr_trace_enter() shares the exact 
> same 16 args in the middle... just send in the context
> pointer and let the next level down split it into the
> ktrace.
> 
> Compile tested only.
 
Very nice.

Josef 'Jeff' Sipek.

-- 
I think there is a world market for maybe five computers.
		- Thomas Watson, chairman of IBM, 1943.
