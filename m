Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Aug 2007 13:29:42 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7CKTabm001462
	for <linux-xfs@oss.sgi.com>; Sun, 12 Aug 2007 13:29:39 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_fsr and null byte areas in files
Date: Sun, 12 Aug 2007 22:29:40 +0200
References: <200707092313.48876.Martin@lichtvoll.de> <20070710005030.GQ31489@sgi.com> <200707262309.24012.Martin@lichtvoll.de> (sfid-20070726_234346_745054_05940549)
In-Reply-To: <200707262309.24012.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122229.40400.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, ck@vds.kolivas.org

Am Donnerstag 26 Juli 2007 schrieb Martin Steigerwald:
> Am Dienstag 10 Juli 2007 schrieb David Chinner:
> > > 1) Is there an XFS qa test available for xfs_fsr? If so I could use
> > > that one. Are there some hints on how to get started on XFS qa?
> >
> > Yes, test 042. Download it from CVS, build it (installing all the
> > bits it asks for ;), edit common.config to add your test and scratch
> > partitions (both volatile) and the 'check -l 042' to run test 042.
>
> Hi!
>
> I ran test 42 and it completes successfully.

Hello,

I now read a post from someone who faced null byte areas in files after 
xfs_fsr as well[1]. And he writes that this problem is related to the ck 
patchset:

http://bhhdoa.org.au/pipermail/ck/2007-August/008433.html

It may well be that it is related to the ck patchset in my case as well. I 
did not know the exact kernel version anymore when I was using xfs_fsr, 
since it took me 2 weeks to actually find about this corruption. Well and 
when I ran xfsqa test I had a slighly newer kernel was using the CFS 
scheduler instead of the ck patchset. Actually I thought the other was 
using the CFS scheduler as well  I didn't think of it as having any 
relevance so I didn't look into that direction.

But now it seems that the problem actually is related ck patchset and that 
I was using a kernel with ck patchset as well. I try to find the time to 
run xfsqa test 42 for my latest ck patchset kernel to know for sure.

I just wanted you to know. It seems to me that this may well not been a 
problem with XFS at all.

[1] http://oss.sgi.com/archives/xfs/2007-07/msg00038.html

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
