Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 18:31:57 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L2VnA6029210
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 18:31:53 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6237253E5B1
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 18:32:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id jXXjziANWAfJisWs for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 18:32:06 -0800 (PST)
Message-ID: <47940404.1000009@sandeen.net>
Date: Sun, 20 Jan 2008 20:31:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW 2/2] Case insensitive support for XFS - user-space
References: <op.t43zfeiz3jf8g2@pc-bnaujok.melbourne.sgi.com> <479118CF.1020302@sandeen.net> <47919214.9000807@sandeen.net> <op.t49b6jkr3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.t49clfbc3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t49clfbc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:

>>>         error =  libxfs_trans_reserve(tp, XFS_CREATE_LOG_RES(mp), 0, 0,
>>> 0, 0);
>> Can you try this instead?
>>
>> 	error =  libxfs_trans_reserve(tp, XFS_IALLOC_BLOCKS(mp) +
>> 			(XFS_IN_MAXLEVELS(mp) - 1), 0, 0, 0, 0);
> 
> BTW. this fix works for me :)

Ok, I'll trust you then.  I haven't looked at what those macros do,
context, etc...  and probably not going to go look right now :)

-Eric
