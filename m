Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D2ABC7CA2
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 12:04:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96B653040AA
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 10:04:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OBX6Pb2O11HJlUD7 for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 10:04:07 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B8EF5142F
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 12:04:07 -0500 (CDT)
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
Date: Thu, 30 Jun 2016 12:04:07 -0500
MIME-Version: 1.0
In-Reply-To: <SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
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
To: xfs@oss.sgi.com



On 6/30/16 11:59 AM, Anthony l wrote:
> I don't think this is a multi tape dump. But then again i don't know for sure. I recently got a job and this is my first 'project'. I have about 10 tapes each are labeled a month and a year, so I don't think they are multi tape because they span like 3 years 2004-2007 . Although for the current tape I am working on right now if I select 1 skip, I'll get to another back up labeled "incremental backup 1" or something similar. Using the verbosity output here is what I got. (also using interactive restore). I went ahead and specified byte size 4096. Through earlier test using the dd command I determined that was the correct size. Ill post one without byte size specified too. I just saw it in that post and thought it might help.
> 
> Here is the output with verbosity.
> 
> http://pastebin.com/Nd6BqNc5
> 
> The out is the same with or without -b 4096.
> 
> http://pastebin.com/0dxbCvyc (no -b)


interactively restore from this dump?
1: skip
2: interactively restore
 (default)
->2
++++================++++
missing some stuff------

^^^ is that your comment, or actual output?

Looks like it eventually encountered a short read:

xfsrestore: drive op: read: wanted 131072 (0x20000)
xfsrestore: tape op: reading 245760 bytes
xfsrestore: tape op read of 245760 bytes short: nread == 4096
xfsrestore: tape op: get status
xfsrestore: tape status = wprot onl
xfsrestore: short read record 1 (nread == 4096)
xfsrestore: drive op read returning error rval=1

in dmesg, is there any sort of IO error from the tape?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
