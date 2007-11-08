Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 06:41:38 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA8EfSDM021423
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 06:41:32 -0800
Message-ID: <4733201C.9060802@sandeen.net>
Date: Thu, 08 Nov 2007 08:41:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 7Tb XFS partition lost on reboot
References: <473072FD.4070104@jamendo.com> <alpine.LRH.0.9999.0711061144540.17301@hogwarts.egr.duke.edu> <4730B98C.5090008@sandeen.net> <47330B8E.5010008@jamendo.com>
In-Reply-To: <47330B8E.5010008@jamendo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Amandine AUPETIT <amandine@jamendo.com>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, xfs@oss.sgi.com

Amandine AUPETIT wrote:
> Hi,
> Thanks for the advice !
> I checked the label with xfs_admin -l :
> # xfs_admin -l /dev/cciss/c1d0p1
> label = ""
> 
> I tried to blank it in case there is something invisible :
> # xfs_admin -L -- /dev/cciss/c1d0p1
> writing all SBs
> new label = ""
> 
> But it seems to be the same. :(

No, not the filesystem label, the disklabel, otherwise known as the
partition table - dos vs. gpt.  This is something you set with parted or
fdisk, not xfs_admin.

-Eric
