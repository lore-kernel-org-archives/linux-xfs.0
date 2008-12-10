Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBA4aXVx011786 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 22:36:33 -0600
Message-ID: <493F474B.8020106@sgi.com>
Date: Wed, 10 Dec 2008 15:36:27 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: add testcase for ->setattr permission checking
References: <20081202142039.GA25155@infradead.org>
	<493CB518.7000001@sgi.com>	<20081209095546.GB8599@infradead.org>
	<493F34CA.3040101@sgi.com>
In-Reply-To: <493F34CA.3040101@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Timothy Shimmin wrote:
> For chown:
> 	"If the specified file is a regular file, one or more of the S_IXUSR,
> 	S_IXGRP, or S_IXOTH bits of the file mode are set, and the process
> 	does not have appropriate privileges, the set-user-ID (S_ISUID) and
> 	set-group-ID (S_ISGID) bits of the file mode shall be cleared upon
> 	successful return from chown(). If the specified file is a regular
> 	file, one or more of the S_IXUSR, S_IXGRP, or S_IXOTH bits of the
> 	file mode are set, and the process has appropriate privileges, it
> 	is implementation-defined whether the set-user-ID and set-group-ID
> 	bits are altered. If the chown() function is successfully invoked
> 	on a file that is not a regular file and one or more of the S_IXUSR,
> 	S_IXGRP, or S_IXOTH bits of the file mode are set, the set-user-ID
> 	and set-group-ID bits may be cleared."
> 
> reg file + mode-bits set + no appropriate privileges -> clear suid,sgid
> reg file + mode-bits set + appropriate privileges -> maybe clear suid,sgid
> non reg file + mode-bits set + chown success on file (??) -> maybe clear suid/sgid
> 
s/mode-bits/exec-mode-bits/

--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
