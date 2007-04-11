Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Apr 2007 03:02:38 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3BA2VfB011436
	for <linux-xfs@oss.sgi.com>; Wed, 11 Apr 2007 03:02:32 -0700
Date: Wed, 11 Apr 2007 11:36:22 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070411093622.GB28503@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <20070404154523.GA20096@tuatara.stupidest.org> <20070405072803.GB2759@mail3b.westend.com> <20070405152917.GB23893@tuatara.stupidest.org> <17942.39236.623189.817503@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17942.39236.623189.817503@base.ty.sabi.co.UK>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>
Cc: Linux XFS <linux-xfs@oss.sgi.com>

Hi Peter,

On Fri, Apr 06, 2007 at 08:02:28PM +0100, Peter Grandi wrote:
> > [ ... ] The Dell's raid system can safely buffer outstanding
> > writes and flsuh them, the 3ware can't so it stalls waiting
> > fot the disks to catch up. [ ... ] I'd be tempted to just use
> > the 3ware as a JBOD and use sw, but I'm arguably biased, I've
> > had so many reliability and performance problems with hw raid
> > over the years
> 
> Uhm, I had a friend that worked for a middling storage system
> vendor and he was telling me horror stories about bugs and
> misdesigns in their quite popular RAID products.
> 
> 3ware seem to me one of the more reliable RAID brands, their
> cautious approach may be why they are slower above.

your are probably right. 3ware didn't answer yet. However I've
found an option in the controller to set the "storsave" policy.

In the default profile FUA (force unit access) commands are only
acknowledged directly in case a BBU is present. Otherwise the controller
waits until the data is written to disk.

When selecting the "performance" profile FUA commands are ignored and
delete time lowers to a couple of seconds.

So the behaviour of the controller should be considered a feature. But
I am still astonished how slow deletes were in the first place.
This might be a bug or incompatibility anyhow.

Thanks to all others for your suggestions. I'll inform you in case
3ware has news for me.

Ciao,
Thomas
-- 
Thomas Kähn                   WESTEND GmbH  |  Internet-Business-Provider
Technik                       CISCO Systems Partner - Authorized Reseller
                              Im Süsterfeld 6          Tel 0241/701333-18
tk@westend.com                D-52072 Aachen              Fax 0241/911879
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Die Gesellschaft ist eingetragen im Handelsregister Aachen unter HRB 7608
Geschäftsführer:           Thomas Neugebauer, Thomas Heller, Michael Kolb
