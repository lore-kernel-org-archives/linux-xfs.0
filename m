Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E9D37F59
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 09:35:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CA95304039
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 07:35:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y9HsAatzqJElwRKK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Jan 2015 07:35:37 -0800 (PST)
Date: Fri, 16 Jan 2015 10:35:27 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: extremely slow file creation/deletion after xfs ran full
Message-ID: <20150116153526.GA676@sh-el6.eng.rdu2.redhat.com>
References: <54B387A1.6000807@aei.mpg.de> <54B3CC6A.4080405@aei.mpg.de>
	<20150112155206.GD25944@bfoster.bfoster>
	<54B3F19D.6030307@aei.mpg.de>
	<20150112163749.GE25944@bfoster.bfoster>
	<54B40552.50106@aei.mpg.de> <20150113203332.GD29484@destitution>
	<54B608E7.9040702@aei.mpg.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B608E7.9040702@aei.mpg.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: xfs@oss.sgi.com

On Wed, Jan 14, 2015 at 07:12:55AM +0100, Carsten Aulbert wrote:
> Hi Dave
> 
> On 01/13/2015 09:33 PM, Dave Chinner wrote:
> > 
> > This pattern seems to match a filesystem that was running under
> > inode32 for most of it's life, and is now using inode64 and hence
> > spreading the subdirectories and hence new inodes over all AGs
> > instead of just limiting them to AG 0....
> > 
> 
> I fear you are right. The install logs from 2012 show, that fstab simply
> contained:
> 
> UUID=dd407af5-1edc-41de-8c72-5fe1de31fb11 /srv xfs rw  0 2
> 
> And our change management is not that good to track back, when we
> changed to inode64.
> 
So, looks like Dave is right, you have been running XFS with inode32 for
the entire time (which probably overloaded AG0 from this FS) and then
changed to inode64 when it became the default option.

> OK, I think I've gathered quite a lot of things we did wrong. I'll try
> to summarize it in another email later today or tomorrow to invite a few
> more comments before we go ahead redoing the FS. Also, it may serve as
> summary for the list archive.
> 
> For now, I want to say a very, very big thank you for remarks and
> suggestions!
> 
> Cheers
> 
> Carsten
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
