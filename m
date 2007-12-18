Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 06:49:08 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIEmt1S008511
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:49:01 -0800
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C30664970A8
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:49:05 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204]) by cuda.sgi.com with ESMTP id 2qnQc3FiBSbZDEGU for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:49:05 -0800 (PST)
Date: Tue, 18 Dec 2007 15:49:02 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Do not reset xfsquota flags on quotaless ro mount
In-Reply-To: <20071218143849.GP4396912@sgi.com>
Message-ID: <Pine.LNX.4.64.0712181547090.32270@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712181459210.32270@fbirervta.pbzchgretzou.qr>
 <20071218143849.GP4396912@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>


On Dec 19 2007 01:38, David Chinner wrote:
>> 
>> In https://bugzilla.novell.com/show_bug.cgi?id=345338 it is
>> claimed that resetting the quota flags in the mounting sequence
>> rw,ro,rw is a bug, but I would say this is not the case,
>
>You mounted without quotas in the middle step, thereby invalidating
>them.
>
That's clear to me, but according to the commenter, the filesystem is
in read-only mode (that is, if no recovery was necessary for the ro
mount), hence they should not be invalidated as they cannot change
anyway. Or can they?
