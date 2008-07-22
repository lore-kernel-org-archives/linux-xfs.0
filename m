Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 04:26:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6MBQauW000753
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 04:26:39 -0700
Message-ID: <4885C425.9020309@sgi.com>
Date: Tue, 22 Jul 2008 21:27:33 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_lblock
References: <4880AEF8.2080906@cape-horn-eng.com> <48815AA6.3080102@sgi.com> <4884B419.6080603@thebarn.com> <488552EC.8060803@sgi.com> <4885BB2E.3010508@cape-horn-eng.com>
In-Reply-To: <4885BB2E.3010508@cape-horn-eng.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Ems <Richard.Ems@cape-horn-eng.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com, Bill O'Donnell <billodo@sgi.com>



Richard Ems wrote:
> Mark Goodwin wrote:
>> Some of the above might not refer directly to the final committed
>> patches but the thread URLs should be accurate. These are bug fixes
>> that go a long way back and really do need to be back-ported and
>> pushed out for the mentioned distros. There are probably other patches
>> not listed above that should be considered too.
>
> Hi Mark, thanks for the list and clarifications.
>
> But still some more questions ... who does the backporting for the
> distros? SGI or the distros themselves?

Generally the distros, except for SGI storage platforms and SLES where
SGI has a contractural support agreement with Novell.

> Is someone from Novell / SUSE / openSUSE reading here?

Andreas Gruenbacher is probably listening

> When can we *expect* to have these patches backported? In one month?
> Three months? More?

For SLES, within a week. For OpenSuSE presumeably the SLES folks will
follow-up with OpenSuSE, but I can't predict when. For Fedora, Eric
Sandeen.  For RHEL (on anything except SGI storage platforms), nobody
since XFS is not supported directly by Redhat. For all other distros
and server & NAS vendors, it's entirely up to their maintainers and
respective support organization - generally they track a release or
two behind kernel.org.

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
