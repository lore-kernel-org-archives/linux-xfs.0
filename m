Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9C4GWmg037660 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 23:16:32 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEF411BE430
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 21:13:29 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id SREsicfA8Ky10zI3
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 21:13:29 -0700 (PDT)
Message-ID: <4E9513EA.2070709@hardwarefreak.com>
Date: Tue, 11 Oct 2011 23:13:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
References: <20111011091757.GA32589@otto.nzcorp.net>
	<20111011133448.GA10692@infradead.org>
	<20111011141338.GA11808@otto.nzcorp.net>
	<20111012003526.GI3159@dastard>
In-Reply-To: <20111012003526.GI3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, aradford@gmail.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 10/11/2011 7:35 PM, Dave Chinner wrote:

> FWIW, if it's a repeatable problem, you might want to update the
> driver and controller firmware to something more recent and see if
> that solves the problem....

New firmware was released on 08/11/2011 for the SAS2208 dual core ASIC
based cards, the 9265-8i and 9285-8i.  I'd say the odds are good that
the OP's card(s) shipped with the original firmware, given this one was
released exactly two months ago today.

Complete list of bug fixes and enhancements in this firmware:
http://kb.lsi.com/KnowledgebaseArticle16557.aspx

I didn't count them but it looks like a few hundred, which makes this a
major product refresh, and seems to indicate the original firmware for
these two cards was a bit buggy.  This is the 2nd firmware release.

Firmware file:
http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/23.1.1-0004_SAS_FW_Image_3.140.15-1320.zip

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
