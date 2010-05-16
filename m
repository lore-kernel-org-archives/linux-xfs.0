Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4G2uH2q139694 for <xfs@oss.sgi.com>; Sat, 15 May 2010 21:56:18 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EBD09B90E3
	for <xfs@oss.sgi.com>; Sat, 15 May 2010 19:59:22 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id pmBAAiJgC77uDwLD
	for <xfs@oss.sgi.com>; Sat, 15 May 2010 19:59:22 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 57ACE6C054
	for <xfs@oss.sgi.com>; Sat, 15 May 2010 21:58:32 -0500 (CDT)
Message-ID: <4BEF5F75.5020409@hardwarefreak.com>
Date: Sat, 15 May 2010 21:59:01 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs didn't provide redundancy for citical data structure?
References: <AANLkTimP06rpMX4BRaRIggMctQ2qR7Cul9yqcJR6Xj3O@mail.gmail.com>
In-Reply-To: <AANLkTimP06rpMX4BRaRIggMctQ2qR7Cul9yqcJR6Xj3O@mail.gmail.com>
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

hank peng put forth on 5/15/2010 10:57 AM:
> I read this paper: http://pages.cs.wisc.edu/~vshree/xfs.pdf, which
> says xfs didn't provide redundancy for citical data structure, such as
> mirror, parity. I wonder if it is so?
> If it is, is there plan to implement that for XFS developers?

This paper was published in early 2005, the research based on Linux 2.6.9,
which was released in 2004.  The analysis was performed on code that is now
~6 years old.

Are these shortcomings valid?  Have any been addressed/fixed since 2004?
Does real world usage show they're not needed, or that the development
cost/benefit ratio is too high to bother implementing the changes?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
