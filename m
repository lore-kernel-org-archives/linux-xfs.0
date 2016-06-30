Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A97B7CA0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 17:08:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8613AAC002
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 15:08:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FCXAYWUCh0lWZwwA for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 15:08:05 -0700 (PDT)
Date: Fri, 1 Jul 2016 08:07:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Message-ID: <20160630220737.GS12670@dastard>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Jun 30, 2016 at 12:04:07PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/30/16 11:59 AM, Anthony l wrote:
> > I don't think this is a multi tape dump. But then again i don't know for sure. I recently got a job and this is my first 'project'. I have about 10 tapes each are labeled a month and a year, so I don't think they are multi tape because they span like 3 years 2004-2007 . Although for the current tape I am working on right now if I select 1 skip, I'll get to another back up labeled "incremental backup 1" or something similar. Using the verbosity output here is what I got. (also using interactive restore). I went ahead and specified byte size 4096. Through earlier test using the dd command I determined that was the correct size. Ill post one without byte size specified too. I just saw it in that post and thought it might help.
> > 
> > Here is the output with verbosity.
> > 
> > http://pastebin.com/Nd6BqNc5
> > 
> > The out is the same with or without -b 4096.
> > 
> > http://pastebin.com/0dxbCvyc (no -b)
> 
> 
> interactively restore from this dump?
> 1: skip
> 2: interactively restore
>  (default)
> ->2
> ++++================++++
> missing some stuff------
> 
> ^^^ is that your comment, or actual output?
> 
> Looks like it eventually encountered a short read:
> 
> xfsrestore: drive op: read: wanted 131072 (0x20000)
> xfsrestore: tape op: reading 245760 bytes
> xfsrestore: tape op read of 245760 bytes short: nread == 4096
> xfsrestore: tape op: get status
> xfsrestore: tape status = wprot onl
> xfsrestore: short read record 1 (nread == 4096)
> xfsrestore: drive op read returning error rval=1
> 
> in dmesg, is there any sort of IO error from the tape?

So xfs_reatore is wanting to find the session inventory in that
last media file, and it would appear that it isn't there or shorter
than expected. A tape problem, perhaps? Have you tried running
xfs_restore using the minimal tape protocol (-m)?

Another option is to try to restore the dump files from tape to a
local file on disk and see if that can be parsed instead.

The other thing you might want to do is upgrade xfsdump to the
latest version - you're running 3.1.1 and the current version is
3.1.6. I doubt it will change the behaviour, but at least it will
give us something to work from...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
