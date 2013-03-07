Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF7F27FB8
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:04:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D77C304059
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:04:34 -0800 (PST)
Received: from mail-bk0-f44.google.com (mail-bk0-f44.google.com
	[209.85.214.44]) by cuda.sgi.com with ESMTP id zWDOkTZp57Lp37Iv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:04:33 -0800 (PST)
Received: by mail-bk0-f44.google.com with SMTP id j4so206286bkw.3
	for <xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:04:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51380FD3.5010302@hardwarefreak.com>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<51380FD3.5010302@hardwarefreak.com>
Date: Thu, 7 Mar 2013 14:04:32 +0100
Message-ID: <CAPcwv6yAHAsmwgROs12gRtCbqTXBvTPrx8F-e4kYab2YApsobg@mail.gmail.com>
Subject: Re: XFS filesystem corruption
From: Julien FERRERO <jferrero06@gmail.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

> It may be unrelated to your corruption, problem but I'm curious why you
> are specifying a 32MB log section instead of letting mkfs.xfs make the
> log size decision.

I honestly don' know, the rebuild script was written 8 years ago by an
engineer that since left the company.

Is 32MB a short log space for a 1.5 TB of data ?

>
> I would assume based on your description that this is a mobile storage
> system, often moved from one location to another, probably in a van, and
> this is why the operator simply hits the power switch?  Live news crew
> type application or similar?
>

Correct.

Moreover, the common usage is to power off all the equipment (included
ours) from a general power switch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
