Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28J63qY057122 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 13:06:03 -0600
Received: from webrelay-aldf.mr.itd.umich.edu (webrelay-aldf.mr.itd.umich.edu
	[141.211.14.43]) by cuda.sgi.com with ESMTP id UAMPSdugARmRAX79
	for <xfs@oss.sgi.com>; Thu, 08 Mar 2012 11:06:02 -0800 (PST)
Message-ID: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
Date: Thu, 08 Mar 2012 14:06:00 -0500
From: Sean Thomas Caron <scaron@umich.edu>
Subject: Safe to use XFS in production in Linux 3.2.9?
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: scaron@umich.edu

Hi all,

We're currently using Linux 3.0.12 with Cristoph's  
xfs-bulletproof-sync patch and it seems to be working very well for  
us. Unfortunately this kernel is vulnerable to the recent  
CVE-2012-0056 no permission checking on writes to /proc/(pid)/mem  
local root exploit, so we've got to leave it behind.

I see that the newest recommended stable kernel on kernel.org is  
3.2.9. Have there been any major changes to XFS between 3.0.12 and  
3.2.9 that would be considered "risky" in a production environment? Is  
there any reason why we shouldn't be using 3.2.9 in production? We got  
bit pretty hard by various sync failure bugs in 2.6.38 that resulted  
in major data loss - so I want to make absolutely sure there aren't  
any "snakes in the grass" before we try a newer kernel.

If 3.2.9 is not suitable, is there at least a kernel in 3.2-train that  
is fairly safe as far as XFS goes?

I assume the xfs-bulletproof-sync patch has already been committed to  
the code base in 3.2-train, so we shouldn't have to worry about that  
any longer?

I'm not subscribed to the list; please CC any replies to my personal  
e-mail and expect some delay in response; I'm just watching the  
mailing list through the archives.

Thank you!

-Sean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
