Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 17:25:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6O0OoDW002141
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 17:25:02 -0700
Date: Mon, 24 Jul 2006 10:23:59 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Buglet in mount(8) with large page size
Message-ID: <20060724102359.B2056114@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Adrian Bunk <bunk@stusta.de>
Cc: Arthur Corliss <acorliss@nevaeh-linux.org>, xfs@oss.sgi.com

Hi Adrian,

We have had this XFS bug report...
	http://oss.sgi.com/bugzilla/show_bug.cgi?id=704
...and Arthur has diagnosed the problem and proposed a fix.

Its in some code we "lifted" from mount(8) to attempt to detect
an existing filesystem/partition/... before overwriting it with
mkfs.xfs.

How do you want to fix this in mount_guess_fstype.c?  Options
would seem to be:
- bump up the size of the "buf" array to cater for all current
page sizes; or
- malloc the read buffer taking into account the page size.

cheers.

-- 
Nathan
