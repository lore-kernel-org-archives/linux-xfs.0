Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Apr 2007 17:11:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3B0BMfB001815
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2007 17:11:23 -0700
Message-Id: <200704110011.KAA28739@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_repair leaves empty but undeletable dirs in lost+found
Date: Wed, 11 Apr 2007 10:16:57 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20070410092443.GA8496@barkeeper1.linbit>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Lars Ellenberg' <lars.ellenberg@linbit.com>
Cc: xfs@oss.sgi.com

Hi Lars,

It copies the inodes and directory contents and other metadata. 
I restore it here and run xfs_repair over it to see how it 
failed. xfs_repair only operates on metadata and does not 
check data.

Currently, it does not obfuscate file names if there is a
privacy/confidentiality concern but that is a feature I
intend on adding later.

Regards,
Barry. 

> -----Original Message-----
> From: Lars Ellenberg [mailto:lars.ellenberg@linbit.com] 
> Sent: Tuesday, 10 April 2007 7:25 PM
> To: Barry Naujok
> Cc: xfs@oss.sgi.com
> Subject: Re: xfs_repair leaves empty but undeletable dirs in 
> lost+found
> 
> On Tue, Apr 10, 2007 at 11:55:14AM +1000, Barry Naujok wrote:
> > Hi Lars,
> > 
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
> 
> -- 
> : Lars Ellenberg                            Tel +43-1-8178292-0  :
> : LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
> : Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
> __
> please use the "List-Reply" function of your email client.
