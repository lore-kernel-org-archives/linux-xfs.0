Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6I2VhET136289 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 21:31:43 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id FZRLJBJnmKHE5kio
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 19:31:42 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id E70486C1AF
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 21:31:41 -0500 (CDT)
Message-ID: <5006200E.6020408@hardwarefreak.com>
Date: Tue, 17 Jul 2012 21:31:42 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs/md filesystem hang on drive pull under IO with 2.6.35.13
References: <5005D661.8030200@dolby.com>
	<20120718000445.62135e1d@galadriel.home>
In-Reply-To: <20120718000445.62135e1d@galadriel.home>
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

On 7/17/2012 5:04 PM, Emmanuel Florac wrote:

> So far it may be a good idea to upgrade to something better than
> 2.6.35.13.

XFS delaylog wasn't the default until 2.6.39.  I think it was introduced
as experimental in 2.6.35.  It may not be relevant to your current
issue, but were you mounting XFS with delaylog?

I agree with the others.  Upgrade to a much newer kernel.  Why are you
using 2.6.35?  It's very old, it's an oddball.  AFAIK no distros use it.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
