Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6NAS3Wt120781 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 05:28:03 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id qjyQF9OE74TxVFkF
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 03:28:02 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id F335C6C139
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 05:28:01 -0500 (CDT)
Message-ID: <500D2731.5050004@hardwarefreak.com>
Date: Mon, 23 Jul 2012 05:28:01 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Delay in folder access
References: <assp.1551ac5709.500CEF4B.8020400@amfes.com>
In-Reply-To: <assp.1551ac5709.500CEF4B.8020400@amfes.com>
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

On 7/23/2012 1:29 AM, Daniel L. Miller wrote:
> I have an XFS partition on simple 4-disk RAID-10 array.  The array is
> mounted at /raid.  I have a variety of subfolders - one of which is
> /raid/data - which in turn has a number of subfolders.
> 
> Doing a simple "ls /raid" has no problems.  Similarly, no issues with
> "ls /raid/data/stuff".  But ... executing "ls /raid/data" results in a
> delay, sometimes in minutes, before it returns.

How many files are in /raid/data, excluding subdirs?  If it's many tens
of thousands ls will be slow, but I'd not think multiple minutes worth
of slow.

Please post output of 'df /raid'

Likewise, 'xfs_db -c frag /dev/[device] -r'

device being that upon which the XFS resides.

> I don't see any errors in dmesg or syslog.  Does this indicate a pending
> crash?

Probably not.  It probably indicates a very full and fragmented filesystem.

> Also, I do have a ".fsr" folder under /raid.  All the folders listed,
> which appear empty, are dated 11/1/2010.  Is it safe to delete ".fsr"?

That may be related to xfs_fsr.  I've never seen such a file and I use
xfs_fsr regularly.  I'd wait for one of the devs to respond here before
deleting it.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
