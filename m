Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:36832 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbeKEGHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Nov 2018 01:07:00 -0500
Message-ID: <5BDF5B9B.9050201@tlinx.org>
Date: Sun, 04 Nov 2018 12:50:35 -0800
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsprogs-4.16; scrubbing and files w/o /usr dependencies...
References: <5BDD1D19.7030208@tlinx.org> <20181103045253.GT4135@magnolia>
In-Reply-To: <20181103045253.GT4135@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linux-Xfs <linux-xfs@vger.kernel.org>



On 11/2/2018 9:52 PM, Darrick J. Wong wrote:
> On Fri, Nov 02, 2018 at 08:59:21PM -0700, L.A. Walsh wrote:
>>  'xfs_scrub_all' needs
>> #!/usr/bin/python3 to run.  So wouldn't it be happier in /usr/sbin?
> 
> Hmm, good point, scrub should move to /usr/sbin.
----
	Scrub, or the python script that uses it?
	As far as I can tell, xfs_scrub, itself, 
doesn't need anything on /usr.


> /usr/lib/xfsprogs/xfs_scrub_all.cron is a sample cronjob that will get
> installed automatically some years from now when scrub is stable and
> ready to be autoconfigured as a background job.  The goal is to be able
> to handle both systemd and cron environments, and I'm not picking sides.
-----
	I was just looking at the xfs_scrub_all
cmd in /sbin.  The  cron you mention that is to run in a 
cron-only environment doesn't look right:

10 3 * * 0 root test -e /run/systemd/system || /sbin/xfs_scrub_all

	It doesn't look like it will run w/o systemd directories.

	I was looking at xfs_scrub_all and noticing that it was 
heavily based on systemd, with references (in double quotes): 

1) tail's output of "systemd-journal" (no facility to use syslog).
2) in fn "kill_systemd" uses systemd's "systemctl" to terminate 
   a "systemd unit", with no option to kill a process via 'kill'
3) "escape a path to avoid systemd mangling" leaving need for utils
reading paths from systemd to do their own decoding.

> (Note that xfs_scrub is still experimental...)
----
	Yeah.  Given the bit-ratio between content and 
meta-info, I'd be more worried about some bit changing 
in the data, considering it covers a majority of the space.
I.e. if metadata was 1/10000 of the data size, the chances 
of getting a bit changing in data would be 10,000 times
higher.  

	It seems _remiss_ to go to all this work to check 
the unlikely occurrence of random bit changes in metadata, 
when the chances of it happening in the data would be
orders of magnitude higher.

	OTOH, if one's HW does regular scans of the underlying
disk, wouldn't that be more efficient in detecting (and
repairing) random bit errors since it wouldn't have to 
read or seek around to extract semi-randomly placed metadata.


	I see where xfs_scrub can allow speedup
using multiple threads, but with a hardware RAID, the
speed-up goes up proportionately to the number of
disks -- without the CPU being loaded down by such checking.  

Somehow that seems considerably more efficient for finding
random bit-errors.
