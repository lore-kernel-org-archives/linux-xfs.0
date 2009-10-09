Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n99IvnrT093186 for <xfs@oss.sgi.com>; Fri, 9 Oct 2009 13:57:49 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 054114B4E09
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 11:59:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id j9lNN3oacTwVV8qU for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2009 11:59:16 -0700 (PDT)
Message-ID: <4ACF8801.7070009@sandeen.net>
Date: Fri, 09 Oct 2009 13:59:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can't mount XFS from a read-only device
References: <20091009170937.3938ff7b@harpe.intellique.com>
In-Reply-To: <20091009170937.3938ff7b@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Emmanuel Florac wrote:
> Hello all, 
> 
> I'm using a RAID enclosure that provides read-only snapshots. It works
> perfectly fine using JFS.
> But with XFS, I keep trying and it keeps failing :
> 
> XFS mounting filesystem sdb
> 
> Ending clean XFS mount for filesystem: sdb
> 
> sd 11:0:0:1: [sdc] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE,SUGGEST_OK
> 
> sd 11:0:0:1: [sdc] Sense Key : Data Protect [current] 
> 
> sd 11:0:0:1: [sdc] Add. Sense: Write protected
> end_request: I/O error, dev sdc, sector 0
> Filesystem "sdc": Disabling barriers, trial barrier write failed
> XFS mounting filesystem sdc
> 
> sd 11:0:0:1: [sdc] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE,SUGGEST_OK
> 
> sd 11:0:0:1: [sdc] Sense Key : Data Protect [current] 
> 
> sd 11:0:0:1: [sdc] Add. Sense: Write protected
> end_request: I/O error, dev sdc, sector 1953792056
> xfs_force_shutdown(sdc,0x1) called from line 420 of file
> fs/xfs/xfs_rw.c.  Return address = 0xffffffff80381f89
> 
> Filesystem "sdc": I/O Error Detected.  Shutting down filesystem: sdc
> 
> Please umount the filesystem, and rectify the problem(s)
> 
> I/O error in filesystem ("sdc") meta-data dev sdc block
> 0x74748038       ("xlog_bwrite") error 5 buf count 262144
> 
> XFS: failed to locate log tail
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
> 
> I don't really grasp what's wrong...
> 

try mount -o norecovery (and maybe -o nobarrier)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
