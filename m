Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:29:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L5T9hW016944
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:29:12 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2973A53EB71
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:29:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 8kprRHVRjr8y8MgY for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:29:28 -0800 (PST)
Message-ID: <47942DB5.6040708@sandeen.net>
Date: Sun, 20 Jan 2008 23:29:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: small problem w/ new xfs defaults patch
References: <4794159F.9070505@sandeen.net> <20080121051341.GA31708862@melbourne.sgi.com>
In-Reply-To: <20080121051341.GA31708862@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Niv Sardi wrote:
> * Eric Sandeen <sandeen@sandeen.net> [2008-01-20 21:46:39 -0600]:
> 
>> Index: xfsprogs-2.9.4/growfs/xfs_growfs.c
>> ===================================================================
> [...]
>> couple things... you lost a "\n" off the end of the data section there...
> 
> That has been fixed, I guess it needs to be sent to oss  (barry?)

Ok, see that.  Sorry... grabbed the original patch and didn't check cvs
for updates.

Thanks,
-Eric

>> Also, do you really want to drop reporting of unwritten extents?  Even
>> if you're disallowing the selection on new mkfs's there may still be
>> different flavors of filesystems in existence, should it still be reported?
> 
> I don't really care, whatever the oss/xfs-master people like best.
> 
> Cheers
