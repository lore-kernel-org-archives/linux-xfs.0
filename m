Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Mar 2007 01:35:25 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2L8ZK6p007315
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 01:35:21 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id 1F9DBE67
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 09:26:21 +0100 (CET)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 02163-19 for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2007 09:26:14 +0100 (CET)
From: "Daniele P." <daniele@interline.it>
Subject: Re: xfsrepair memory consumption
References: <200703202343.KAA28746@larry.melbourne.sgi.com>
In-Reply-To: <200703202343.KAA28746@larry.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 21 Mar 2007 09:35:07 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703210935.07809.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wednesday 21 March 2007 00:48, you wrote:
> Hi Daniele,
>
> The nlink/phase 7 patch I recently sent out does reduce this
> inode memory requirements which should address the issue you
> see.

Hi Barry, 
maybe this could help. A simple ps -u during xfs_repair show
an increasing memory usage in phase 6 and 7 for 2.8.18-1.
Unfortunately with 2.6.20-1 the memory usage is exploding in
phase 2.

Regards,
Daniele P.
