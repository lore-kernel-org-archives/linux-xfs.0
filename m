Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Mar 2008 06:47:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2QDkvuS011487
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 06:46:58 -0700
Received: from mx1.wp.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C79EBF18C2
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 06:47:31 -0700 (PDT)
Received: from mx1.wp.pl (mx1.wp.pl [212.77.101.5]) by cuda.sgi.com with ESMTP id Z5jnpzhviz4nOVYY for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 06:47:31 -0700 (PDT)
From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: BUG: xfs on linux lvm - lvconvert random hungs when doing i/o
Date: Wed, 26 Mar 2008 15:02:19 +0100
References: <200803211520.16398.stf_xl@wp.pl> <20080324233952.GF103491721@sgi.com> <20080325020223.GB108924158@sgi.com>
In-Reply-To: <20080325020223.GB108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261502.19930.stf_xl@wp.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tuesday 25 March 2008, David Chinner wrote:
> That points to I/O not completing (not an XFS problem at all), or
> the filesystem freeze is just taking a long time to run (as it has
> to sync everything to disk). Given that this is a snapshot target,
> writing new blocks will take quite some time. Is the system still
> making writeback  progress when in this state, or is it really hung?
That is real deadlock, operations which normally takes  few minutes,
hangs for few hours until I restart machine.

This bug is very strange because I can't  catch it with more verbose
debug and tracing options,

I did more tests without debugging options and looks that version from
sgi cvs (2.6.25-rc3) works well. I did also test with two patches you suggest,
applied (with some troubles) for 2.6.24.2,  but finally  things hung after
2 days  - better than without patches, as you expected.

So, looks things are fixed in sgi cvs repository. Don't know if these are
xfs or other subsystem (device-mapper?) fixes, anyway I can't reproduce
bug on this version,  that's good news, I think.

>
> Cheers,
> 
> Dave.

Thanks
Stanislaw Gruszka
