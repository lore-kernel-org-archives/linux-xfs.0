Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67ACTdT138193 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 05:12:30 -0500
Message-ID: <4A531FAB.3050406@dermichi.com>
Date: Tue, 07 Jul 2009 12:12:59 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] default to inode64 on 64-bit systems
References: <4A52419E.5020301@sandeen.net>	<20090706184257.GA18107@infradead.org>
	<bzyhbxoc1hi.fsf@fransum.emea.sgi.com>
In-Reply-To: <bzyhbxoc1hi.fsf@fransum.emea.sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs mailing list <xfs@oss.sgi.com>

Hi!
> Making inode64 the default on 64 bit systems seems like a good idea to
> me.  But would it not be advisable to have a mount option that forces
> the old behaviour, just in case?  Something like "broken32bituserspace"
> (or maybe "inode32").
> 
I think such a mount option would be a must. There is lots of 32-bit Software that cannot cope with 64-bit inodes. Unfortunately there are closed-source 32-bit apps (which can be run on 64 bit systems) where nothing can be done for 64-bit inode compatiblity in the short term. Had this problem very recently with the Zmanda Enterprise Backup Software, which forced me to remove the inode64 option.

regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
