Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81319Bt099179 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 22:01:10 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 052AF41100
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 20:01:48 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id H7QelS3N4b3sfKEZ
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 20:01:48 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id CDEBA6C3F6
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 22:01:47 -0500 (CDT)
Message-ID: <4C7DC21B.1040705@hardwarefreak.com>
Date: Tue, 31 Aug 2010 22:01:47 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
References: <201009010130.41500@zmi.at> <20100901000631.GO705@dastard>
In-Reply-To: <20100901000631.GO705@dastard>
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

Dave Chinner put forth on 8/31/2010 7:06 PM:

> You're probably CPU bound, not IO bound.

7200 rpm is the highest spindle speed for 2TB drives--5400 is most
common.  None of them are going to do much over 200 random seeks/second,
if that.  That's 400 tops for two drives.

Using any modern Intel/AMD ~2 GHz CPU, you think he's CPU bound?
Apparently this "rm -rf" type operation is much more complex than I
previously believed.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
