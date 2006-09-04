Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Sep 2006 18:31:36 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k841VLDW011078
	for <xfs@oss.sgi.com>; Sun, 3 Sep 2006 18:31:31 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k840cDnx017901
	for <xfs@oss.sgi.com>; Sun, 3 Sep 2006 19:38:13 -0500
Message-ID: <44FB75CB.8050809@sgi.com>
Date: Mon, 04 Sep 2006 01:39:39 +0100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: review: minor cleanup in xfs_read locking
References: <20060904101711.A3331169@wobbly.melbourne.sgi.com>
In-Reply-To: <20060904101711.A3331169@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

Looking a little closer... you could probably do away with the extra
pair of parentheses in the call to unlikely().

Nathan Scott wrote:
> Hi Lachlan,
> 
> Could you check this for me - it just folds the second direct I/O
> conditional added in your recent deadlock fix back into the prior
> branch, which is also direct I/O specific...
> 
> thanks.
> 
