Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 20:41:31 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3J3fPfB013491
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 20:41:27 -0700
Subject: Re: [PATCH] Fix xfs_fsr so the temp dir is not world
	readable/writable
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <op.tq0ge6wtf8dyj1@pc-bnaujok.melbourne.sgi.com>
References: <op.tq0ge6wtf8dyj1@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 13:42:35 +1000
Message-Id: <1176954155.6273.143.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2007-04-19 at 13:10 +1000, Barry Naujok wrote:
> 

Looks good.

> -static time_t endtime;
> +static time_t endtime = 0; 

This line of the change is unnecessary though.

cheers.

-- 
Nathan
