Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61KXWLd033159 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 15:33:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26CE1338797
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 13:34:04 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 9W4JHY6BGGk4NUsY for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 13:34:04 -0700 (PDT)
Message-ID: <4A4BC83A.3080401@sandeen.net>
Date: Wed, 01 Jul 2009 15:34:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Seg fault during xfs repair (segmentation fault / segv)
References: <4A4A596D.8030800@ssec.wisc.edu>
	<4A4A5C4E.7030605@sandeen.net>	<4A4A7D44.7040009@ssec.wisc.edu>
	<4A4BBECC.8000308@sandeen.net>
In-Reply-To: <4A4BBECC.8000308@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jesse Stroik <jstroik@ssec.wisc.edu>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> Ok, from a metadump image Jesse provided (thanks!) it's dying in here:
> 
>                 bno = be32_to_cpu(agfl->agfl_bno[i]);
>                 printf("agfl at %p i is %d agfl_bno[i] %u bno is %u\n",
> agfl, i, agfl->agfl_bno[i], bno);
>                 if (verify_agbno(mp, be32_to_cpu(agf->agf_seqno), bno))
>                         set_agbno_state(mp, be32_to_cpu(agf->agf_seqno),
>                                         bno, XR_E_FREE);
> 
> agfl_bno looks corrupt, and bno is coming out to be huge.
> 
> set_agbno_state() does:
> 
> *(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) = ....
> 
> where ag_blockno is that bno above; this wanders us off into bad memory
> and boom.  I'll see what we can do to fix it up.

Ok patch sent, but now I hit:

junking entry "soh " in directory inode 128
entry ".nsr" in shortform directory 128 references invalid inode 210397
junking entry ".nsr" in directory inode 128
bogus .. inode number (128) in directory inode 128, clearing inode number
xfs_repair: dir2.c:2123: process_dir2: Assertion `(ino !=
mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino &&
(ino == *parent || need_root_dotdot == 1))' failed.
Aborted

that's one crunchy filesystem you've got there; what happened to it?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
