Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF0487F3F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:46:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3367304062
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 01:46:35 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id NAXxW4OdAnuxiuM4
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 01:46:15 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 112A66C184
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:46:15 -0600 (CST)
Message-ID: <52AAD766.8080405@hardwarefreak.com>
Date: Fri, 13 Dec 2013 03:46:14 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
References: <20131211172725.GA4606@redhat.com>	<68DD7157-6ACE-4548-A466-C1EBD31B6DEB@colorremedies.com>	<20131211185746.GA11861@redhat.com>
	<2A0A637F-7ED6-4743-8791-E57E22306139@colorremedies.com>
In-Reply-To: <2A0A637F-7ED6-4743-8791-E57E22306139@colorremedies.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 12/11/2013 6:19 PM, Chris Murphy wrote:
...
> I suspect we've only just begun to see the myriad ways in which SSDs
> could fail. I ran across this article earlier today: 
> http://techreport.com/review/25681/the-ssd-endurance-experiment-testing-data-retention-at-300tb
>
>  What I thought was eye opening was a hashed file failing multiple
> times in a row with *different* hash values, being allowed to rest
> unpowered for five days and then passing. Eeek. Talk about a great
> setup for a lot of weird transient problems with that kind of
> reversal. What I can't tell is if there were read errors report to
> the SATA driver, or if (different) bad data from a particular page
> was sent to the driver.

The drive that exhibited this problem, the Samsung 840, is (one of) the
first on the market to use triple level cell NAND.  The drive is
marketed at consumers only.  The anomaly occurred after 100 TB of
writes, well beyond what is expected for a consumer drive.  After the
anomaly occurred the drive ran flawlessly up to 300 TB.

The rest of the drives, including the Samsung 840 Pro, use two cell MLC
NAND, and none of them have shown problems in their testing.  They've
been flawless.  So I disagree with your statement "we've only just begun
to see the myriad ways in which SSDs could fail".

What we have here is what we've always had.  A manufacturer using a
bleeding edge technology didn't have all the bugs identified and fixed
with the first rev of the product.  This isn't a problem with SSDs in
general, but one manufacturer, one new drive model, using a brand new
NAND type.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
