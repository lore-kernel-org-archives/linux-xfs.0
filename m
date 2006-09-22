Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 17:17:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8M0H7aG031291
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 17:17:09 -0700
Date: Fri, 22 Sep 2006 10:16:19 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_read_buf error 5.
Message-ID: <20060922001619.GW3034@melbourne.sgi.com>
References: <43FB1967D03EC7449A77FA91322E364802A9AA07@SVL1XCHCLUPIN01.enterprise.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43FB1967D03EC7449A77FA91322E364802A9AA07@SVL1XCHCLUPIN01.enterprise.veritas.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nikhil Kulkarni <nikhil_kulkarni@symantec.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 21, 2006 at 03:52:18PM -0700, Nikhil Kulkarni wrote:
> Hi,
> 
>  
> 
> We are running the latest stable kernel 2.6.18 on RedHat Enterprise 4
> Update 4.
> 
> When I create an xfs partition and assign it a size > 2GB, I get the
> following errors during bootup:
....
> If the partition size is < 2GB then everything works smoothly. The
> filesystem mounts successfully.

Sounds like a partition problem, not an XFS problem...
What is the size of the partitions in both cases according to
/proc/partitions?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
