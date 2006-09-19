Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 02:08:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8J980aG011970
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 02:08:06 -0700
Received: from mail.vcc.de (mail.vcc.de [217.111.2.122])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18ABA452DDF
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 00:54:59 -0700 (PDT)
Message-ID: <450FA2A2.10909@opticalart.de>
Date: Tue, 19 Sep 2006 09:56:18 +0200
From: Frank Hellmann <frank@opticalart.de>
MIME-Version: 1.0
Subject: Re: xfs_check - out of memory | xfs_repair - superblock error reading
References: <200609181519.18448.christian.gattermair@mci.edu> <20060918222348.GY3034@melbourne.sgi.com> <8B10E861-C427-4F9F-B0C4-7A87DB77236B@astro.wisc.edu>
In-Reply-To: <8B10E861-C427-4F9F-B0C4-7A87DB77236B@astro.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephan Jansen <jansen@astro.wisc.edu>
Cc: xfs@oss.sgi.com

Hi,

Stephan Jansen wrote:
>
> Hi,
>
> I was just going to create a 3TB filesystem on a 32 bit system.  So
> xfs_check will not work?  How about xfs_repair?  I assume that will
> work but would like to know beforehand.
>
> [stuff deleted]
>
>
> ----- Stephan
>

I have a couple of 3.1TB FC arrays here and I had no real problems with
xfs on them so far. We have to reset the machines from time to time,
'cause nvidia drivers and data moving locks up the complete machine, but
even then no data losses occured. The lastest kernels we use (2.6.16)
checks the filesystems/logs without any hickups during mount phase.

Commandline xfs_check won't work (out of memory error), but checking
with xfs_repair works fine here. It will need a lot of memory though, so
have at least 3GB RAM installed.

    Cheers,
                   Frank...

-- 
--------------------------------------------------------------------------
Frank Hellmann          Optical Art GmbH           Waterloohain 7a
DI Supervisor           http://www.opticalart.de   22769 Hamburg
frank@opticalart.de     Tel: ++49 40 5111051       Fax: ++49 40 43169199 
