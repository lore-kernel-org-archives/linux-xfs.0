Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 02:38:47 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m25AcNAl002746
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 02:38:26 -0800
Received: from merkurneu.hrz.uni-giessen.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C1E211F8F00
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2008 02:38:50 -0800 (PST)
Received: from merkurneu.hrz.uni-giessen.de (merkurneu.hrz.uni-giessen.de [134.176.2.3]) by cuda.sgi.com with ESMTP id jwMQE8SBmsegnMtL for <xfs@oss.sgi.com>; Wed, 05 Mar 2008 02:38:50 -0800 (PST)
From: Marc <Marc.Dietrich@ap.physik.uni-giessen.de>
Subject: Re: filesystem corruption in linus tree
Date: Wed, 5 Mar 2008 09:33:57 +0100
References: <03F8FD43-322F-41E3-A7A0-CD4E9AD8B4DE@ap.physik.uni-giessen.de> <200802262100.18631.marc.dietrich@ap.physik.uni-giessen.de> <47CB7D52.2030704@sgi.com>
In-Reply-To: <47CB7D52.2030704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200803050934.00814.marc.dietrich@ap.physik.uni-giessen.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com


Hi,

Am Montag 03 März 2008 05:23:46 schrieb Lachlan McIlroy:
> Marc Dietrich wrote:
> > Hi again,
> >
> > On Tuesday 26 February 2008 08:38:50 Lachlan McIlroy wrote:
> >> Marc Dietrich wrote:
> >>> Hi,
> >>>
> >>> On Monday 25 February 2008 01:36:28 Barry Naujok wrote:
> >>>> On Sun, 24 Feb 2008 20:58:26 +1100, Marc Dietrich
> >>>>
> >>>> <Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
> >>>>> Hi,
> >>>>>
> >>>>> somewhere after the release of 2.6.24 my xfs filesystem got
> >>>>> corrupted. Initialy I thought it was only related to the readdir bug.
> >>>>> (http://oss.sgi.com/archives/xfs/2008-02/msg00027.html) So I waited
> >>>>> for the fix to go into mainline. Yesterday I tried again, but got
> >>>>> this error during boot:
> >
> > <sniped>
> >
> >> We've had a few problems reported with XFS on 32-bit powermacs and the
> >> culprit appears to be some changes to bit manipulation routines.  Could
> >> you please try reverse applying the attached patches and see if the
> >> problem is resolved?
> >
> > I saw, that you already pushed it into mainline - for a good reason ;-)
> > Works as expeted.
> >
> > Please also don't forget 2.6.24-stable !
>
> The changes that caused this regression went into 2.6.25-rc1 so no need for
> a 2.6.24 stable fix.

yes - and I could have sworn, that 2.6.24 is also affected. My fault.

Thanks 

Marc


-- 
	"Those who question our statements are traitors", 
Lord Arthur Ponsonby, "Falsehood in Wartime: Propaganda Lies of the First 
World War", 1928
