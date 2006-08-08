Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Aug 2006 16:36:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k78NZhDW026095
	for <linux-xfs@oss.sgi.com>; Tue, 8 Aug 2006 16:35:56 -0700
Date: Wed, 9 Aug 2006 09:34:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: file system defragmentation
Message-ID: <20060808233425.GQ2114946@melbourne.sgi.com>
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <E4E12CD035E14A4AB8C36E0F4B7143F7277DED@iu-mssg-mbx09.exchange.iu.edu> <43112C5D.8090202@sgi.com> <20050828034108.73921.qmail@web34103.mail.mud.yahoo.com> <5408752.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5408752.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Cosmo Nova <cs_mcc98@hotmail.com>
Cc: linux-xfs@oss.sgi.com

On Wed, Jul 19, 2006 at 09:23:42PM -0700, Cosmo Nova wrote:
> 
> what is the maximum tolerance for the delayed allocations pls? I guess it's
> not possible to buf a GB size file and delay its allocation?

Sure it is. The limit on how much is buffered before writeback (and therefore
allocation) is determined by how much memory you have and your
/proc/sys/vm/dirty* tunable settings. This can range from a few MB to a few TB
of data depending on how big your machine is ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
