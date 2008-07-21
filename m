Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 16:39:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6LNdG4X022155
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 16:39:18 -0700
Message-ID: <48851E5C.8010005@sgi.com>
Date: Tue, 22 Jul 2008 09:40:12 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_lblock
References: <4880AEF8.2080906@cape-horn-eng.com> <48815AA6.3080102@sgi.com> <488457F3.2050405@cape-horn-eng.com> <4884B527.1030104@sandeen.net>
In-Reply-To: <4884B527.1030104@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Richard Ems <Richard.Ems@cape-horn-eng.com>, xfs@oss.sgi.com, Bill O'Donnell <billodo@sgi.com>



Eric Sandeen wrote:
> Richard Ems wrote:
>> Mark Goodwin wrote:
>>> Hi Richard,
>>>
>>> this looks like XFS b-tree corruption of some sort. We have some patches
>>> that should help here. The patches are being back-ported to SLES10 and
>>> should also apply to OpenSUSE. We should have something ready early next
>>> week.
>> Thanks Mark. The most annoying thing is that, after many repairs, it's
>> working again! But my big question is ... for how long? How stable is
>> the filesystem now? Should I better recreate it? WHY did this happen?
>> Why did the FS fail again after some repairs?  8(
>>
>> Where can I get more info about these patches? Is there a developer
>> mailing list? Or some webpage to follow the development progress?
>
> This *is* the developer mailing list, and I am honestly a bit frustrated
> that said bugs & patches are not being aired & reviewed in public, honestly.

I'm sorry Eric for not being very clear. Nothing "secret" going on here,
nor intended. The problems have all been reported (or mostly, but I'm
not going to report every problem seen by every SGI customer). The issues
I'm referring to are extent list corruption (causing hangs), bmap corruption
due to failed allocs in full AGs (and locking hierarchy issues), and invalid
btree cursors following btree splits. Lachlan and others have posted patches
for all of these over the past couple of months (I'll dredge the archives
and post the references if you want). The changes are all reviewed, checked
in and available in CVS. Some made it into .26 and others will appear in .27
in a day or two.

The topic at hand in this thread (for folks like Richard) is collecting
these fixes into a patchset and back-porting the result to the distros that
are based on 2.6.{16,18} or earlier. This affects SLES, RHEL, OpenSuSE10,
earlier FC, etc.

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
