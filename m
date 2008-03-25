Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:20:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2P4Kax0026744
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:20:38 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C2EE6E1525
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:21:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id IUAsautl9AwlwzqV for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:21:10 -0700 (PDT)
Message-ID: <47E87D97.9050900@sandeen.net>
Date: Mon, 24 Mar 2008 23:20:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: call _notrun in common.dump if dump utils not
 found
References: <47E5CFBA.7060405@sandeen.net> <47E8703C.30603@sgi.com> <op.t8jyw8i63jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t8jyw8i63jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Barry Naujok wrote:
> On Tue, 25 Mar 2008 14:23:40 +1100, Timothy Shimmin <tes@sgi.com> wrote:
> 
>> Thanks, Eric.
>>
>> On IRIX:
>>  > where xfsdump xfsrestore xfsinvutil
>> /sbin/xfsdump
>> /usr/sbin/xfsdump
>> /sbin/xfsrestore
>> /usr/sbin/xfsinvutil
>>  > ls -l /sbin/xfsdump
>> lrwxr-xr-x    ... /sbin/xfsdump -> ../usr/sbin/xfsdump*
>>
>> I'll add the IRIX xfsrestore path and wait for Russell or
>> whoever to complain about BSD :)
> 
> common.config sets up environment variables for the various
> tools used and can handle these paths. It has them for the
> xfsprogs tools (XFS_REPAIR_PROG, XFS_DB_PROG, etc) but
> nothing for the xfsdump tools.

yeah, that may be better...

-Eric
