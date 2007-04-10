Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Apr 2007 00:21:25 -0700 (PDT)
Received: from mail.linbit.com (nudl.linbit.com [212.69.162.21])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3B7LKfB021100
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2007 00:21:22 -0700
Date: Tue, 10 Apr 2007 23:05:02 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: xfs_repair leaves empty but undeletable dirs in lost+found
Message-ID: <20070410210502.GA19842@barkeeper1.linbit>
References: <20070405162235.GA816@barkeeper1.linbit> <200704100151.LAA27963@larry.melbourne.sgi.com> <20070410092443.GA8496@barkeeper1.linbit> <200704102245.00734.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704102245.00734.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, Apr 10, 2007 at 10:45:00PM +0200, Martin Steigerwald wrote:
> Am Dienstag 10 April 2007 schrieb Lars Ellenberg:
> 
> > > Would it be possible for you apply the patch I posted to xfs@oss
> > > in Feb http://oss.sgi.com/archives/xfs/2007-02/msg00072.html
> > > to the latest xfsprogs source, make and install it and run:
> > >
> > > # xfs_metadump /dev/md1 - | bzip2 > /tmp/bad_xfs.bz2
> > >
> > > And make the image available for me to download and analyse?
> >
> > uhm. probably. I'll talk with the guy who owns the data :)
> >
> > out of curiosity: what exactly would you do with it?
> > I mean, would that be sufficient to restore the "badness",
> > with the files all filled with zero,
> > and you'd be able to reproduce locally?
> 
> Hi Lars!
> 
> As far as I understand a meta data dump does not contain the actual data 
> in the files. That would be sufficient als xfs_repair is for repairing 
> metadata corruption. For analysing the reason why a file is undeleteable 
> its actual contents should be quite irrelevant. Only thing that could 
> possibly matter is the amount and location, not the contents of blocks a 
> file occupies. But that doesn't seem to matter here either.
> 
> It would contain meta data information on the directory and file names as 
> well as timestamps, owner and rights - if you are concerned about the 
> privacy of your customer you may want to try to reproduce the problem 
> with different meta data information.

I'm very well aware of these things.

what I meant to ask was:
 (how) could I do some "partial" metadump?
 because,
 * yes, I am concerned about the privacy (not too much, though,
   but still as this is not my data, I have to ask)
 * its probably going to be huge anyways
 * its going to take some time to produce, and this is a life system
 * it would probably really help for investigating further
   if I were able to reduce the amount of meta data involved
   (remember, one xfs_repair run took me 12 hours)
and, most importantly:
 * reducing the amount of meta data is probably the first step
   Barry would do once he has my full dump, because thats the only way
   to go about debugging this.
   I'd like to help to reduce the work needed to debug this.

so yes, I really would like to try to reproduce with different meta data
information, but I'd need a hint what to look for in my existing bad
data to be able to reproduce similar bad data.

@Barry: I'd probably be able to get a full dump tomorrow.
or even better, a partial dump, if you tell me what you'd need.

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
__
please use the "List-Reply" function of your email client.
