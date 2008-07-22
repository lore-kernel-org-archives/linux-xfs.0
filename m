Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 19:06:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M26OTJ031587
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:06:25 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB7BAE71D0A
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:07:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Q5hcfiv9BjIDL6Qp for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:07:34 -0700 (PDT)
Message-ID: <488540E3.7030702@sandeen.net>
Date: Mon, 21 Jul 2008 21:07:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_lblock
References: <4880AEF8.2080906@cape-horn-eng.com> <48815AA6.3080102@sgi.com> <488457F3.2050405@cape-horn-eng.com> <4884B527.1030104@sandeen.net> <48851E5C.8010005@sgi.com>
In-Reply-To: <48851E5C.8010005@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Richard Ems <Richard.Ems@cape-horn-eng.com>, xfs@oss.sgi.com, Bill O'Donnell <billodo@sgi.com>

Mark Goodwin wrote:
> 
> Eric Sandeen wrote:
>> Richard Ems wrote:
>>> Mark Goodwin wrote:
>>>> Hi Richard,
>>>>
>>>> this looks like XFS b-tree corruption of some sort. We have some patches
>>>> that should help here. The patches are being back-ported to SLES10 and
>>>> should also apply to OpenSUSE. We should have something ready early next
>>>> week.
>>> Thanks Mark. The most annoying thing is that, after many repairs, it's
>>> working again! But my big question is ... for how long? How stable is
>>> the filesystem now? Should I better recreate it? WHY did this happen?
>>> Why did the FS fail again after some repairs?  8(
>>>
>>> Where can I get more info about these patches? Is there a developer
>>> mailing list? Or some webpage to follow the development progress?
>> This *is* the developer mailing list, and I am honestly a bit frustrated
>> that said bugs & patches are not being aired & reviewed in public, honestly.
> 
> I'm sorry Eric for not being very clear. Nothing "secret" going on here,
> nor intended. The problems have all been reported (or mostly, but I'm
> not going to report every problem seen by every SGI customer). The issues
> I'm referring to are extent list corruption (causing hangs), bmap corruption
> due to failed allocs in full AGs (and locking hierarchy issues), and invalid
> btree cursors following btree splits. Lachlan and others have posted patches
> for all of these over the past couple of months (I'll dredge the archives
> and post the references if you want). The changes are all reviewed, checked
> in and available in CVS. Some made it into .26 and others will appear in .27
> in a day or two.

Great.  From your earlier reply I had the impression that they were
patches still internal to SGI - which of course SGI has every right to
do, but patch reviews have the potential to be better if more eyes can
see them - but if they're all already out there on the list, then thanks
and sorry for the noise.  :)

-Eric
