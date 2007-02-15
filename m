Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Feb 2007 06:08:53 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1FE8jm7028055
	for <linux-xfs@oss.sgi.com>; Thu, 15 Feb 2007 06:08:47 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: mkfs and mount tips?
Date: Thu, 15 Feb 2007 16:10:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
In-Reply-To: <5BFF2CB07B4CB49FEC7310C7@timothy-shimmins-power-mac-g5.local>
Message-Id: <20070215141309.383D619323@mail.edu.haifa.ac.il>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Timothy Shimmin' <tes@sgi.com>, linux-xfs@oss.sgi.com



> -----Original Message-----
> From: Timothy Shimmin [mailto:tes@sgi.com]
> Sent: Thursday, February 15, 2007 3:19 AM
> To: Leon Kolchinsky; linux-xfs@oss.sgi.com
> Subject: Re: mkfs and mount tips?
> 
> Hi Leon,
> 
> --On 13 February 2007 10:48:15 AM +0200 Leon Kolchinsky
> <leonk@construct.haifa.ac.il> wrote:
> 
> > I've also seen "–d unwritten=0" option:
> >
> > So my question:
> > Is it safe to add –d unwritten=0 option to increase performance like
> this
> > (or will I lose some essential functionality)?:
> >
> 
> My understanding (although I'm not familiar with that code),
> is that unwritten extents are used in space preallocation.
> So unless you reserve space for a file it will not have an effect.
> And if you do, then setting "unwritten=0" will speed up writes because it
> doesn't
> need to flag the unwritten extents and write out the extra transactions
> for this.
> If the unwritten extents aren't flagged as such then there can be a
> security issue
> where one can read old data (other's data) for these unwritten parts.
> In fact, the security issue on preallocation (1997-98 sgi-pv#705217) was
> what motivated
> the idea of flagging extents as unwritten in the first place.
> 

Thanks for clearing that out :)

> --Tim
