Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 00:28:11 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l357S6fB028589
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 00:28:07 -0700
Date: Thu, 5 Apr 2007 09:28:03 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070405072803.GB2759@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <20070404154523.GA20096@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070404154523.GA20096@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Hi Chris,

On Wed, Apr 04, 2007 at 08:45:23AM -0700, Chris Wedgwood wrote:
> On Wed, Apr 04, 2007 at 03:05:35PM +0200, Thomas Kaehn wrote:
> > The XFS was first created using default options and later on with
> > "-d su=64k,sw=2 -l su=64k" which improved overall performance
> > but not delete performance.
> 
> have you tried w/o using the hw raid?

I'am going to test with a single disk in the same machine. 

> > Has anyone realized similar effects? On a different server (Dell
> > 6850) the directory can be deleted within seconds. What could be the
> > reason for the huge difference in delete performance?
> 
> a lot of log updates; does the other server have a battery-backed
> write-cache like many cards to these days?

The Dell system has got a battery-backed write-cache. The 3ware system
has no battery unit. However it's supposed to provide write cache, too.
At least I've enabled it in the RAID's configuration. The controller
has got more than 100MB memory.

> > | # time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 >/dev/null 2>&1; done
> > |
> > | real    6m6.814s
> > | user    0m30.290s
> > | sys     2m42.562s
> 
> that's about the same as my quick single-spindle cheap-desktop test
> here
> 
> > | # time rm -rf y
> > |
> > | real    5m18.034s
> > | user    0m0.036s
> > | sys     0m8.169s
> 
> v2 logs? what logbufs & logbsize is used?
> 
> testing with my cheap crappy desktop workstation thing with a
> single disk I get "1m25.004s" for the delete

Your delete time sounds more sensible to me. The file system was
created first with default options - later on I tried to match
the RAID's stripe size, increased the log size and mounted
with logbufs=8:

log stripe unit specified, using v2 logs
meta-data=/dev/sda1              isize=256    agcount=8, agsize=125008 blks
         =                       sectsz=512  
data     =                       bsize=4096   blocks=1000032, imaxpct=25
         =                       sunit=16     swidth=32 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=16 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


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
