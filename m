Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 09:32:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08HWRqw028035
	for <linux-xfs@oss.sgi.com>; Mon, 8 Jan 2007 09:32:28 -0800
Message-ID: <45A27C8D.5010109@sandeen.net>
Date: Mon, 08 Jan 2007 11:17:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS and 2.6.18 -> 2.6.20-rc3
References: <45A27BC7.2020709@exegy.com>
In-Reply-To: <45A27BC7.2020709@exegy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Mr. Berkley Shands" <bshands@exegy.com>
Cc: Dave Lloyd <dlloyd@exegy.com>, linux-xfs@oss.sgi.com

Mr. Berkley Shands wrote:

> Dave Lloyd (our in-house Idea Guy) looked at the allocation groups...
> Non-sequential, random...
> 
> What data would you like to see?

xfs_bmap -v on files where you consider the allocation to have changed
between kernels, would show exactly how it has changed.

-Eric
