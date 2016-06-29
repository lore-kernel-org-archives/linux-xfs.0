Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3EE2F7CA1
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 14:29:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9CADEAC006
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 12:29:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1OSDj1yBAiFMSY4R for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2016 12:29:06 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6F4A21F1C
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 14:29:06 -0500 (CDT)
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7e2ec911-1079-2339-b72d-8f86b13d5501@sandeen.net>
Date: Wed, 29 Jun 2016 14:29:05 -0500
MIME-Version: 1.0
In-Reply-To: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
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

On 6/29/16 1:48 PM, Anthony l wrote:
> Hello Anthony here,
> 
> I'm not sure if this is the correct place to send a question, If I am
> wrong I would appreciate if you could send me in the right direction.
> I have come across the oss.sgi forums a lot looking for a solution to
> my problem but I could not find much.
> 

Sure, it's a fine place.  Question below.

> 
> Here's my situation.
> 
> I have a bunch a tapes that were created way back when using an IRIX
> system. Some kind of version 6, perhaps even the latest version.
> anyway I am able to peak at the headers to determind the the file
> type on the drive is indeed:
> 
> xFSdump0.... or when I make a sample using 'dd if=/dev/nst0
> of=./test.img' '+ 'file test.img' I get XFSDUMP archive (version 2)
> 
> So, instinctively to get the data off the tapes I would think would
> be as simple as:
> 
> sudo xfsrestore -f /dev/nst0 ./path to where I want it stored
> 
> Then I get:
> 
> using dump format 3
> 
> xfsrestore: searching media for dump
> 
> xfsrestore: preparing drive
> 
> xfsrestore: examining media file 1
> 
> ...
> 
> xfsrestore examining media file xx
> 
> the following dump has been found on drive 0:
> 
> hostname: isp---------(stuff)
> 
> mount point: /isp-iga
> 
> volume: /dev/rdsk/sks0d2s7
> 
> session time: Mon Jan 10 11:47:42 2005
> 
> media label: "backup"
> 
> file system id: xxx....
> 
> session id: xxx...
> 
> media id:...
> 
> restore this dump?
> 
> 1: skip
> 
> 2: restore (default)
> 
>> 2 (enter)
> 

> ====== 
> 
> examining media file 0
> reading directories
> examining media file 1
> reading directories
> ... and so on
> no files selected for restoral

That doesn't seem to be an actual xfsdump error string, is it?

Maybe you can capture and include the entire xfsdump output, or put it
in a pastebin somewhere?  By the time things get hand-transcribed it's
easy to lose important bits.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
