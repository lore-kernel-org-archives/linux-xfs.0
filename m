Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 22:23:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9U5NE7v032565
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 22:23:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC42855D02F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 22:23:13 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id kW2nncB77k2sXchM for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 22:23:13 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KvPzx-00038l-UQ
	for xfs@oss.sgi.com; Thu, 30 Oct 2008 16:23:09 +1100
Date: Thu, 30 Oct 2008 16:23:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Map a disk LBA to filename?
Message-ID: <20081030052309.GM17077@disturbed>
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de> <20081028072105.GW4985@disturbed> <4906C164.6090704@aei.mpg.de> <4906D80F.9050500@aei.mpg.de> <20081028093827.GA12133@kyra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028093827.GA12133@kyra>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, Oct 28, 2008 at 10:38:27AM +0100, KELEMEN Peter wrote:
> * Carsten Aulbert (carsten.aulbert@aei.mpg.de) [20081028 10:14]:
> 
> > Is it possible that blocks != bsized_blocks?
> 
> xfs_bmap(8) talks in basic blocks (512 bytes).
> 660 div 8 = 82, so try:
> 
> 	blockget -b 82 -n

I think all of you need to know about the "convert" command ;)

e.g. to do the above conversion correctly:

xfs_db> convert daddr 660 fsb
0x52 (82)

The xfs_db man page tells you all the different formats that can
be converted between. The convert command automatically takes into
account the geometry of the filesystem where appropriate (e.g.
filesystem block size).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
