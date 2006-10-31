Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 31 Oct 2006 16:24:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA10ONaG008421
	for <linux-xfs@oss.sgi.com>; Tue, 31 Oct 2006 16:24:23 -0800
Received: from n007.sc1.cp.net (smtpout1472.sc1.he.tucows.com [64.97.157.172])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 138D0D1B5B54
	for <linux-xfs@oss.sgi.com>; Tue, 31 Oct 2006 15:21:16 -0800 (PST)
Message-ID: <4547DA70.4040107@Groves.net>
Date: Tue, 31 Oct 2006 17:21:20 -0600
From: John Groves <John@Groves.net>
MIME-Version: 1.0
Subject: XFS dmapi: dm_path_to_handle fails if the path is a directory
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Dean Roehrich <roehrich@clink.americas.sgi.com>

I'm running up against a difficult situation because dm_path_to_handle 
does not return a handle, if the path is to a directory.  Is this a 
known issue, or perhaps fixed in a recent version?  Or is there another 
way get the handle of a directory by path?  When any file type is 
renamed, I (for various reasons) *must* know not just the old & new 
parent handles, but also the handle of the renamed thingy.  If the 
thingy is a directory, I'm stuck at the moment.

My test system has dmapi 2.2.1-5, which I don't think is current, but I 
can't seem to get access to the oss.sgi.com server to check.

Any advice or info appreciated.  I'm willing to try and submit a patch, 
but I'd appreciate first knowing whether there was a specific reason or 
problem that led to the current behavior.

Thanks,
John Groves
