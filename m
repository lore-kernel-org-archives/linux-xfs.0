Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 08:45:33 -0700 (PDT)
Received: from smtp108.sbc.mail.mud.yahoo.com (smtp108.sbc.mail.mud.yahoo.com [68.142.198.207])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l34FjRfB026359
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 08:45:28 -0700
Date: Wed, 4 Apr 2007 08:45:23 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070404154523.GA20096@tuatara.stupidest.org>
References: <20070404130535.GE18320@mail3b.westend.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404130535.GE18320@mail3b.westend.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 04, 2007 at 03:05:35PM +0200, Thomas Kaehn wrote:

> I've got a strange problem on one machine using XFS. Deleting large
> directories (containing about 100000 files, 20k each) using "rm -rf"
> lasts nearly as long as creating the the files using a bash loop.

quite possible

> RAM: 4 GB
> RAID10: 4x 320 GB disks connected to 3ware 9550SXU-8LP
>  (Firmware Version = FE9X 3.08.00.004)


> The XFS was first created using default options and later on with
> "-d su=64k,sw=2 -l su=64k" which improved overall performance
> but not delete performance.

have you tried w/o using the hw raid?

> Has anyone realized similar effects? On a different server (Dell
> 6850) the directory can be deleted within seconds. What could be the
> reason for the huge difference in delete performance?

a lot of log updates; does the other server have a battery-backed
write-cache like many cards to these days?

> | # time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 >/dev/null 2>&1; done
> |
> | real    6m6.814s
> | user    0m30.290s
> | sys     2m42.562s

that's about the same as my quick single-spindle cheap-desktop test
here

> | # time rm -rf y
> |
> | real    5m18.034s
> | user    0m0.036s
> | sys     0m8.169s

v2 logs? what logbufs & logbsize is used?

testing with my cheap crappy desktop workstation thing with a
single disk I get "1m25.004s" for the delete
