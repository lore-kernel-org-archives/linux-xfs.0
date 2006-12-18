Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Dec 2006 15:50:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBINoDqw000450
	for <linux-xfs@oss.sgi.com>; Mon, 18 Dec 2006 15:50:16 -0800
Message-Id: <200612182349.KAA23525@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
Date: Tue, 19 Dec 2006 10:54:49 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
In-Reply-To: <em5il9$tge$1@sea.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-2?Q?'Marcin_Zaj=B1czkowski'?= <mszpak@wp.pl>, linux-xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Marcin Zajaczkowski
> Sent: Monday, 18 December 2006 7:15 PM
> To: linux-xfs@oss.sgi.com
> Subject: Re: xfs_ncheck (actually xfs_db) eats a lot of 
> memory and is killed
> 
> Barry Naujok wrote:
> >> Btw, xfs_check shows two lines:
> >> link count mismatch for inode 1572882 (name ?), nlink 16, 
> counted 15
> >> link count mismatch for inode 2102297 (name ?), nlink 2, counted 3
> >> Can it be reason for strange xfs_db behavior?
> > 
> > No, this shouldn't be causing the xfs_db strange behaviour, but the
> > nlink count mismatch is a problem with xfs_repair 2.8.11. 
> Try and use
> > xfs_repair 2.8.16 and later to fix this issue. Older versions before
> > 2.8.11 will also fix the nlink issue.
> 
> I have some old system rescue CD with xfs_progs from line 
> 2.7.x. Would 
> it be ok?

Yes, that should be fine AFAIK.

Barry.
