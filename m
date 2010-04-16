Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GAftCZ242557 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 05:41:55 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A56A72C909C
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:43:50 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id uSrOdPT3FCspO9bF
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:43:50 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 5F4586C002
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 05:43:50 -0500 (CDT)
Message-ID: <4BC83F65.4040309@hardwarefreak.com>
Date: Fri, 16 Apr 2010 05:43:49 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr question for improvement
References: <201004161043.11243@zmi.at>
In-Reply-To: <201004161043.11243@zmi.at>
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

Michael Monnerie put forth on 4/16/2010 3:43 AM:

> To prevent this, xfs_fsr should do a "compress" phase after 
> defragmentation finished, in order to move all the files behind each 
> other:
> file 1GB
> file 1GB
> file 1GB
> file 1GB
> freespace 3600M
> That would also help fill the filesystem from front to end, reducing 
> disk head moves.

What happens if those are frequently written/appended files, such as logs or
mbox mail files, database files, etc?  If you pack them nose to tail with
this "compress" phase they will instantly be fragmented upon the next append
operation.  Leaving some free sectors at the tail end of a file is what
helps prevent fragmentation.  I don't think this compression would be a good
default behavior.  I think "packing" is probably a better term as
"compression" has a long standing connotation.

Sounds like you have a corner case.  If this "packing" was implemented,
maybe it would be best to make it a command line option only.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
