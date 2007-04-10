Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Apr 2007 14:18:09 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3ALI4fB031461
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2007 14:18:06 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_repair leaves empty but undeletable dirs in lost+found
Date: Tue, 10 Apr 2007 22:45:00 +0200
References: <20070405162235.GA816@barkeeper1.linbit> <200704100151.LAA27963@larry.melbourne.sgi.com> <20070410092443.GA8496@barkeeper1.linbit> (sfid-20070410_134231_652510_049D094B)
In-Reply-To: <20070410092443.GA8496@barkeeper1.linbit>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704102245.00734.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lars Ellenberg <lars.ellenberg@linbit.com>, Barry Naujok <bnaujok@melbourne.sgi.com>, xfs@oss.sgi.com

Am Dienstag 10 April 2007 schrieb Lars Ellenberg:

> > Would it be possible for you apply the patch I posted to xfs@oss
> > in Feb http://oss.sgi.com/archives/xfs/2007-02/msg00072.html
> > to the latest xfsprogs source, make and install it and run:
> >
> > # xfs_metadump /dev/md1 - | bzip2 > /tmp/bad_xfs.bz2
> >
> > And make the image available for me to download and analyse?
>
> uhm. probably. I'll talk with the guy who owns the data :)
>
> out of curiosity: what exactly would you do with it?
> I mean, would that be sufficient to restore the "badness",
> with the files all filled with zero,
> and you'd be able to reproduce locally?

Hi Lars!

As far as I understand a meta data dump does not contain the actual data 
in the files. That would be sufficient als xfs_repair is for repairing 
metadata corruption. For analysing the reason why a file is undeleteable 
its actual contents should be quite irrelevant. Only thing that could 
possibly matter is the amount and location, not the contents of blocks a 
file occupies. But that doesn't seem to matter here either.

It would contain meta data information on the directory and file names as 
well as timestamps, owner and rights - if you are concerned about the 
privacy of your customer you may want to try to reproduce the problem 
with different meta data information.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
