Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2LYMEU095343 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 15:34:23 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1242B14D0ADB
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 13:34:35 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Yb6o2wt9qDo2Evag for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 13:34:35 -0800 (PST)
Message-ID: <4AEF506A.8060803@sandeen.net>
Date: Mon, 02 Nov 2009 15:34:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS and DPX files
References: <4AEC2CF4.8040703@aol.com> <20091031151825.46210b6a@galadriel.home>
	<4AEC4BAA.20606@aol.com>
In-Reply-To: <4AEC4BAA.20606@aol.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "AndrewL733@aol.com" <AndrewL733@aol.com>
Cc: xfs@oss.sgi.com

AndrewL733@aol.com wrote:
> 
>> Maybe  you should try mounting the XFS filesystem with these options :
>> nobarrier,noatime
>>
>>   
> Thanks.  Already doing that -- 3ware controller does not support 
> barriers, so that's automatically ruled out (you see a message in the 
> syslog when mounting the filesystem that barriers will not be used).  
> Already mounting with "noatime".  Also have been trying "filestreams".


Filestreams is really only useful if you have multiple threads writing 
in this manner - for example 2 different movie streams.

Normally an allocation group is chosen for all new files in a directory, 
so if you have 2 streams to 2 directories you are writing to 2 ag's ... 
all is good until those ags get full and things spill over.  At that 
point you may wind up interleaving those files from both streams in a 
3rd ag.

the filestreams option more or less locks out the new ag from other 
streams, so that stuff stays segregated.

If this is your situation (multiple streams, each to their own 
directory), then filestreams may help.  I think for a single stream of 
files, for a single video source, it won't matter.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
