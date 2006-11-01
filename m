Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 31 Oct 2006 16:45:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA10jSaG011854
	for <linux-xfs@oss.sgi.com>; Tue, 31 Oct 2006 16:45:30 -0800
Message-ID: <4547EDFD.8020407@sgi.com>
Date: Wed, 01 Nov 2006 11:44:45 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net>
In-Reply-To: <4547DA70.4040107@Groves.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: John Groves <John@Groves.net>
Cc: linux-xfs@oss.sgi.com, Dean Roehrich <roehrich@clink.americas.sgi.com>

John Groves wrote:
> I'm running up against a difficult situation because dm_path_to_handle 
> does not return a handle, if the path is to a directory.  Is this a 
> known issue, or perhaps fixed in a recent version?  Or is there 
> another way get the handle of a directory by path?  When any file type 
> is renamed, I (for various reasons) *must* know not just the old & new 
> parent handles, but also the handle of the renamed thingy.  If the 
> thingy is a directory, I'm stuck at the moment.
>
> My test system has dmapi 2.2.1-5, which I don't think is current, but 
> I can't seem to get access to the oss.sgi.com server to check.
>
> Any advice or info appreciated.  I'm willing to try and submit a 
> patch, but I'd appreciate first knowing whether there was a specific 
> reason or problem that led to the current behavior.
>
> Thanks,
> John Groves
>
Hi John,

If your path is longer than 2000 characters dm_path_to_handle used to fail.
This bug was fixed in August 2006. Please update your tree from here:

http://oss.sgi.com/projects/xfs/download.html

Regards,
Vlad
