Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9713F7F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 23:50:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 76DCF8F8033
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 21:49:58 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id rI7ahvICOze5tAD1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Oct 2014 21:49:57 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id a3so1076357oib.22
	for <xfs@oss.sgi.com>; Wed, 08 Oct 2014 21:49:56 -0700 (PDT)
Received: from [192.168.5.50] ([70.88.96.213])
	by mx.google.com with ESMTPSA id my9sm2217909obb.23.2014.10.08.21.49.55
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Wed, 08 Oct 2014 21:49:56 -0700 (PDT)
Message-ID: <543613E7.70508@gmail.com>
Date: Thu, 09 Oct 2014 00:49:43 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: gather write metrics on multiple files
References: <543611CF.6030904@hardwarefreak.com>
In-Reply-To: <543611CF.6030904@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 10/09/2014 12:40 AM, Stan Hoeppner wrote:
> Does anyone know of a utility that can track writes to files in an
> XFS directory tree, or filesystem wide for that matter, and gather
> filesystem blocks written per second data, or simply KiB/s, etc?  I
> need to analyze an application's actual IO behavior to see if it
> matches what I'm being told the application is supposed to be doing.
>

We've written a few for this purpose (local IO probing).

Start with collectl (looks at /proc/diskstats), and others.  Our tools 
go to /proc/diskstats, and use this to compute BW and IOPs per device.

If you need to log it for a long time, set up a time series database (we 
use influxdb and the graphite plugin).  Then grab your favorite metrics 
tool that talks to graphite/influxdb (I like 
https://github.com/joelandman/sios-metrics for obvious reasons), and 
start collecting data.

> Thanks, Stan
>
> _______________________________________________ xfs mailing list
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
