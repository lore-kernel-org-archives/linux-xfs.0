Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8FBF7F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 02:24:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EF418F804C
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 00:24:46 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iP7bdK7qlLlLWFi2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 May 2014 00:24:45 -0700 (PDT)
Message-ID: <53731B07.9040606@oracle.com>
Date: Wed, 14 May 2014 15:28:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/9] xfs: error sign fixes for 3.15-rc6
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On 05/13/2014 04:56 PM, Dave Chinner wrote:
> Hi folks,
> 
> I've been working through the mess that is the
> error sign impedance mismatch between the core XFS code and the rest
> of the kernel. I'm about half way through the codebase, and I've
> found a bunch of incorrect error signs throughout the VFS interface
> layers.
> 
> These were effectively all found by inspection, and is
> further evidence that we need to convert all of XFS to negative
> errors as quickly as possible. 

Would you like to find a volunteer to deal with that? I have a colleague
is trying to study XFS these days, looks this is a good task to him.

BTW, before doing negative errors converting, should we have libxfs infrastructure
support at first?


Cheers,
-Jeff


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
