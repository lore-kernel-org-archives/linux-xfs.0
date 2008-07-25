Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 20:44:36 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6P3iYHr007294
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 20:44:34 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 955B519255DD
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 20:45:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id pj6Vgm9BZWAqdZai for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 20:45:44 -0700 (PDT)
Message-ID: <48894C66.5060204@sandeen.net>
Date: Thu, 24 Jul 2008 22:45:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 981498 - remove mounpoint UUID code
References: <20080725033841.D689558C4C3F@chook.melbourne.sgi.com>
In-Reply-To: <20080725033841.D689558C4C3F@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi-Altivanik <xaiki@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Niv Sardi-Altivanik wrote:
> remove mounpoint UUID code

Are you sure this didn't change any disk structures?  The patch I sent
was RFC and completely untested...  (and disclosed as such...) :)

-Eric

> It looks like all of the below is unused... and according
> to Nathan,
> 
> "dont think it even got used/implemented anywhere, but i think it 
> was meant to be an auto-mount kinda thing... such that when you look 
> up at that point, it knows to mount the device with that uuid there, 
> if its not already it was never really written anywhere ... just an 
> idea in doug doucettes brain i think."
> 
> Think it'll ever go anywhere, or should it get pruned?
> 
> The below builds; not at all tested, until I get an idea if it's worth
> doing.  Need to double check that some structures might not need padding
> out to keep things compatible/consistent...
> 
> 
> 
> Date:  Fri Jul 25 13:37:43 AEST 2008
> Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
> Inspected by:  esandeen,hch,xaiki
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
> 
> 
> Modid:  xfs-linux-melb:xfs-kern:31766a
> fs/xfs/xfsidbg.c - 1.356 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfsidbg.c.diff?r1=text&tr1=1.356&r2=text&tr2=1.355&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.356&r2=text&tr2=1.355&f=h
> fs/xfs/xfs_itable.c - 1.167 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_itable.c.diff?r1=text&tr1=1.167&r2=text&tr2=1.166&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.167&r2=text&tr2=1.166&f=h
> fs/xfs/xfs_inode_item.c - 1.137 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode_item.c.diff?r1=text&tr1=1.137&r2=text&tr2=1.136&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.137&r2=text&tr2=1.136&f=h
> fs/xfs/xfs_inode_item.h - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode_item.h.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.h.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
> fs/xfs/xfs_log_recover.c - 1.345 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_log_recover.c.diff?r1=text&tr1=1.345&r2=text&tr2=1.344&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.345&r2=text&tr2=1.344&f=h
> fs/xfs/xfs_inode.c - 1.510 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode.c.diff?r1=text&tr1=1.510&r2=text&tr2=1.509&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.510&r2=text&tr2=1.509&f=h
> fs/xfs/xfs_inode.h - 1.251 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode.h.diff?r1=text&tr1=1.251&r2=text&tr2=1.250&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.251&r2=text&tr2=1.250&f=h
> fs/xfs/xfs_attr_leaf.c - 1.115 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_attr_leaf.c.diff?r1=text&tr1=1.115&r2=text&tr2=1.114&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.115&r2=text&tr2=1.114&f=h
> fs/xfs/xfs_bmap.c - 1.399 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_bmap.c.diff?r1=text&tr1=1.399&r2=text&tr2=1.398&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.399&r2=text&tr2=1.398&f=h
> fs/xfs/xfs_dinode.h - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_dinode.h.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dinode.h.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
> fs/xfs/dmapi/xfs_dm.c - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> dmapi/xfs_dm.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
> 
> 
