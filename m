Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Apr 2007 02:26:49 -0700 (PDT)
Received: from mail.linbit.com (nudl.linbit.com [212.69.162.21])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3A9QifB014917
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2007 02:26:45 -0700
Date: Tue, 10 Apr 2007 11:24:43 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: xfs_repair leaves empty but undeletable dirs in lost+found
Message-ID: <20070410092443.GA8496@barkeeper1.linbit>
References: <20070405162235.GA816@barkeeper1.linbit> <200704100151.LAA27963@larry.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704100151.LAA27963@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 10, 2007 at 11:55:14AM +1000, Barry Naujok wrote:
> Hi Lars,
> 
> Would it be possible for you apply the patch I posted to xfs@oss
> in Feb http://oss.sgi.com/archives/xfs/2007-02/msg00072.html
> to the latest xfsprogs source, make and install it and run:
> 
> # xfs_metadump /dev/md1 - | bzip2 > /tmp/bad_xfs.bz2
> 
> And make the image available for me to download and analyse?

uhm. probably. I'll talk with the guy who owns the data :)

out of curiosity: what exactly would you do with it?
I mean, would that be sufficient to restore the "badness",
with the files all filled with zero,
and you'd be able to reproduce locally?

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
__
please use the "List-Reply" function of your email client.
