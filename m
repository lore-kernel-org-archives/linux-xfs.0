Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 640617CA1
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 23:44:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 244508F8040
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 21:44:32 -0700 (PDT)
Received: from nm17-vm5.access.bullet.mail.gq1.yahoo.com
	(nm17-vm5.access.bullet.mail.gq1.yahoo.com [216.39.63.135]) by
	cuda.sgi.com with ESMTP id eVhqNHrquKNn5GJu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jun 2016 21:44:29 -0700 (PDT)
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
	<20160630220737.GS12670@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20160630220737.GS12670@dastard>
Message-Id: <BFF5CB1A-BA65-4212-9607-2F25F427433B@animezone.org>
From: Andrew Ho <andrewho@animezone.org>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Date: Fri, 1 Jul 2016 00:44:26 -0400
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

I did restore the irix tape on Linux by using the command "tar".  tar xv is for restore.
If the tape was backup by a propriety backup software on SGI Irix, it is difficult to restore on Linux.

     Andrew

     Pressure creates diamond.

> On Jun 30, 2016, at 6:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
>> On Thu, Jun 30, 2016 at 12:04:07PM -0500, Eric Sandeen wrote:
>> 
>> 
>>> On 6/30/16 11:59 AM, Anthony l wrote:
>>> I don't think this is a multi tape dump. But then again i don't know for sure. I recently got a job and this is my first 'project'. I have about 10 tapes each are labeled a month and a year, so I don't think they are multi tape because they span like 3 years 2004-2007 . Although for the current tape I am working on right now if I select 1 skip, I'll get to another back up labeled "incremental backup 1" or something similar. Using the verbosity output here is what I got. (also using interactive restore). I went ahead and specified byte size 4096. Through earlier test using the dd command I determined that was the correct size. Ill post one without byte size specified too. I just saw it in that post and thought it might help.
>>> 
>>> Here is the output with verbosity.
>>> 
>>> http://pastebin.com/Nd6BqNc5
>>> 
>>> The out is the same with or without -b 4096.
>>> 
>>> http://pastebin.com/0dxbCvyc (no -b)
>> 
>> 
>> interactively restore from this dump?
>> 1: skip
>> 2: interactively restore
>> (default)
>> ->2
>> ++++================++++
>> missing some stuff------
>> 
>> ^^^ is that your comment, or actual output?
>> 
>> Looks like it eventually encountered a short read:
>> 
>> xfsrestore: drive op: read: wanted 131072 (0x20000)
>> xfsrestore: tape op: reading 245760 bytes
>> xfsrestore: tape op read of 245760 bytes short: nread == 4096
>> xfsrestore: tape op: get status
>> xfsrestore: tape status = wprot onl
>> xfsrestore: short read record 1 (nread == 4096)
>> xfsrestore: drive op read returning error rval=1
>> 
>> in dmesg, is there any sort of IO error from the tape?
> 
> So xfs_reatore is wanting to find the session inventory in that
> last media file, and it would appear that it isn't there or shorter
> than expected. A tape problem, perhaps? Have you tried running
> xfs_restore using the minimal tape protocol (-m)?
> 
> Another option is to try to restore the dump files from tape to a
> local file on disk and see if that can be parsed instead.
> 
> The other thing you might want to do is upgrade xfsdump to the
> latest version - you're running 3.1.1 and the current version is
> 3.1.6. I doubt it will change the behaviour, but at least it will
> give us something to work from...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
