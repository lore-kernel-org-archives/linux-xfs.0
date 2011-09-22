Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8M7qEea214196 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 02:52:14 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A78C5140D482
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 00:57:40 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id qOZ424fad4b61DVw
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 00:57:40 -0700 (PDT)
Message-ID: <4E7AE92B.8000407@profihost.ag>
Date: Thu, 22 Sep 2011 09:52:11 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
References: <20110918230245.GF15688@dastard> <4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
	<20110921114237.GP15688@dastard> <20110922005312.GT15688@dastard>
	<4E7AC755.3070405@profihost.ag>
In-Reply-To: <4E7AC755.3070405@profihost.ag>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 22.09.2011 07:27, schrieb Stefan Priebe - Profihost AG:
> Am 22.09.2011 02:53, schrieb Dave Chinner:
>> On Wed, Sep 21, 2011 at 09:42:37PM +1000, Dave Chinner wrote:
>>> On Wed, Sep 21, 2011 at 09:40:03AM +0200, Stefan Priebe - Profihost
>>> AG wrote:
>
>> I found this out by disassembling the kernel code. That code has a
>> bug it in when the stuck case is hit - it fails to issue the log
>> force in that case, and that's why I've been seeing this kernel get
>> stuck. False alarm - will now try to reproduce without any dev
>> patches in the kernel.
> Sad to here that ;-( I'm now trying to prepare a 160GB dd image for you
> where it is reproducable.
>

The testimage is ready. I'm just packing it und uploading it. I'll send 
you all details via private mail.

Hope that helps.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
