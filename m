Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB53UOMs235991 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 21:30:25 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AfTGN1sB6Fv5nbbD
	for <xfs@oss.sgi.com>; Tue, 04 Dec 2012 19:32:48 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 5A1716C097
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2012 21:32:47 -0600 (CST)
Message-ID: <50BEC05B.1040009@hardwarefreak.com>
Date: Tue, 04 Dec 2012 21:32:43 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfsdump INTERRUPT issue
References: <CCE40B17.B056E%jellis@dhnet.us>
In-Reply-To: <CCE40B17.B056E%jellis@dhnet.us>
Reply-To: stan@hardwarefreak.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 12/4/2012 7:18 PM, J. Ellis wrote:
> Hi, Stan--
> 
> Ok, I truly apologize for my ignorance, but I don't know how to dump the
> contents to a file. Is it something like:
> 
> xfsdump -J - somefile_xfsdump.txt

~$ man xfsdump

Look at option "-f".

> xfsrestore -J - somefile_xfsrestore.txt

~$ man xfsrestore

See options "-f" "-t" and "-v".

The point of this exercise I believe is to see what errors are thrown by
xfsdump or xfsrestore when they are executed independently, vs through a
pipe.  Do note that this may not be the final step in testing before you
have an answer.  Post any errors or informational output that results
from these commands.

Note that the file written by xfsdump is going to be about the same size
as the filesystem being dumped.  I.e. if the filesystem being dumped is
1TB then you need 1TB of free space on the device where the target
directory resides--you're dumping an entire XFS filesystem into a single
file.  Also, be sure to use "-t" so xfsrestore doesn't actually write
anything.  Did you read "-v"?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
