Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 08:21:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9VFLMJc015247
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 08:21:26 -0700
Message-ID: <47289D75.7030300@sandeen.net>
Date: Wed, 31 Oct 2007 10:21:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net> <47267EC7.8000906@sgi.com> <177CA06B-41D3-4E4A-9EA6-5688C952CD63@loreland.org>
In-Reply-To: <177CA06B-41D3-4E4A-9EA6-5688C952CD63@loreland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: James Braid <jamesb@loreland.org>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

James Braid wrote:
> On 30 Oct 2007, at 00:45, Timothy Shimmin wrote:
>> It might be interesting if people let us know what non-default
>> mkfs and mount options that they are using for their various
>> configurations/classes.
>> Didn't Russell C. have some survey years ago - can't remember if
>> that was for h/ware or what now.
> 
> We have a ~100TB filesystem that was made with the default mkfs.xfs  
> options from memory. The only mount option we use is inode64.

Hm, which has been another pet peeve of mine; shouldn't inode64 flag the
SB when the first >32bit inode is created?  It always bothered me that
inode64 was a mount option which appears to be something you could turn
back off, even though there may be >32bit inodes on disk already.

-Eric
