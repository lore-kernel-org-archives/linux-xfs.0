Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Mar 2008 09:47:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2RGl9HG024790
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:47:11 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4F9D6F8F4D
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:47:43 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id mZlXzp4yvjuOsGPd for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:47:43 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m2RGUn3G022386
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2008 09:31:52 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m2R1fIdk030363
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 18:41:18 -0700
Message-ID: <47EAFB54.1050106@agami.com>
Date: Wed, 26 Mar 2008 18:41:40 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: accounting disk quotas in space reservation
References: <47EAF0BA.4040909@agami.com>
In-Reply-To: <47EAF0BA.4040909@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

Yes, I was missing something.  I just figured out how disk quota
objects are reserved/allocated.

Michael Nishimoto wrote:
> Hi,
> 
> When allocating a space reservation at xfs_trans_reserve time,
> it doesn't look like xfs takes into account new disk blocks which
> might get allocated in the quota DBs.  There is code to handle the
> log reservation for disk quotas, but I don't see anything for
> the space reservation.
> 
> Am I missing something?
> 
> thanks,
> 
>    Michael
> 
> 
