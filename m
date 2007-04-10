Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Apr 2007 18:51:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3A1pBfB026573
	for <xfs@oss.sgi.com>; Mon, 9 Apr 2007 18:51:13 -0700
Message-Id: <200704100151.LAA27963@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_repair leaves empty but undeletable dirs in lost+found
Date: Tue, 10 Apr 2007 11:55:14 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20070405162235.GA816@barkeeper1.linbit>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Lars Ellenberg' <lars.ellenberg@linbit.com>, xfs@oss.sgi.com

Hi Lars,

Would it be possible for you apply the patch I posted to xfs@oss
in Feb http://oss.sgi.com/archives/xfs/2007-02/msg00072.html
to the latest xfsprogs source, make and install it and run:

# xfs_metadump /dev/md1 - | bzip2 > /tmp/bad_xfs.bz2

And make the image available for me to download and analyse?

Regards,
Barry. 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Lars Ellenberg
> Sent: Friday, 6 April 2007 2:23 AM
> To: xfs@oss.sgi.com
> Subject: Re: xfs_repair leaves empty but undeletable dirs in 
> lost+found
> 
> On Wed, Apr 04, 2007 at 10:36:01PM +0200, Lars Ellenberg wrote:
> > NOTE that I used the default sarge xfsprogs version 2.6.20, not
> >      the upstream 2.8.20. yet. I'll start an xfs_repair run with
> >      2.8.20 right after this post, though...
> 
> done.
> now, this used seriously more memory, and cpu,
> and the box went thrashing.
> after some experimenting,
> 
> xfs_repair -o bhash=512 
> 
> got it going without using excessive amounts of swap,
> so it finally finished after about 12 hours
> (2.6.20 needed 8:30, repeatable).
> 
> it did not change the situation, however.
> 
> I know I could clean these using xfs_db and an additional run of
> xfs_repair, but I'm going to keep these around for some more time, in
> case you want me to have a look at some internals still.
> 
> file system itself has gone life again, I hope it does not hurt having
> those strange directories around.
> 
> maybe it is even "just" a problem on the kernel side,
> not being able to convert so the expected "form" of directory?
> sorry, I'm not too deep in the xfs internals, so I need some 
> input from
> the developers here...
> 
> Thanks,
> 
> -- 
> : Lars Ellenberg                            Tel +43-1-8178292-0  :
> : LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
> : Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
> __
> please use the "List-Reply" function of your email client.
> 
> 
