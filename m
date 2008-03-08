Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 20:33:15 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m284X4Io030966
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 20:33:07 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C372F42EDC
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2008 20:33:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id jUKY0lhHteQUaVHy for <xfs@oss.sgi.com>; Fri, 07 Mar 2008 20:33:34 -0800 (PST)
Message-ID: <47D2171D.7070202@sandeen.net>
Date: Fri, 07 Mar 2008 22:33:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
References: <47D20F78.7000103@sandeen.net> <47D216A3.9040406@sgi.com>
In-Reply-To: <47D216A3.9040406@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: ianc@melbourne.sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Ian Costello wrote:
> CXFS does use this to mount filesystems, i.e. on a client read the sb 
> get the uuid and use the uuid to lookup the MDS to request the mount...

Well, this isn't removing the sb uuid... it's this special file type
XFS_DINODE_FMT_UUID... which is cxfs using?

-Eric

> Having said that if it is removed then it will force us to look at 
> another method to mount a cxfs filesystem, and also remove the necessity 
> for cxfs clients to not read the superblock (which is the only metadata 
> cxfs clients read off disk at this point)...
> 
> Regards,
> 
