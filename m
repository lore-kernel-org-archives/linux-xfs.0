Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 09:10:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LGAEYC014722
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 09:10:14 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8B79E74400
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 09:11:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id y6dk3nrqGtKO2n2p for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 09:11:23 -0700 (PDT)
Message-ID: <4884B527.1030104@sandeen.net>
Date: Mon, 21 Jul 2008 11:11:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_lblock
References: <4880AEF8.2080906@cape-horn-eng.com> <48815AA6.3080102@sgi.com> <488457F3.2050405@cape-horn-eng.com>
In-Reply-To: <488457F3.2050405@cape-horn-eng.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Ems <Richard.Ems@cape-horn-eng.com>
Cc: markgw@sgi.com, xfs@oss.sgi.com, Bill O'Donnell <billodo@sgi.com>

Richard Ems wrote:
> Mark Goodwin wrote:
>> Hi Richard,
>>
>> this looks like XFS b-tree corruption of some sort. We have some patches
>> that should help here. The patches are being back-ported to SLES10 and
>> should also apply to OpenSUSE. We should have something ready early next
>> week.
> 
> Thanks Mark. The most annoying thing is that, after many repairs, it's 
> working again! But my big question is ... for how long? How stable is 
> the filesystem now? Should I better recreate it? WHY did this happen? 
> Why did the FS fail again after some repairs?  8(
> 
> Where can I get more info about these patches? Is there a developer 
> mailing list? Or some webpage to follow the development progress?

This *is* the developer mailing list, and I am honestly a bit frustrated
that said bugs & patches are not being aired & reviewed in public, honestly.

-Eric
