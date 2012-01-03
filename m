Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q03LFcOU077674 for <xfs@oss.sgi.com>; Tue, 3 Jan 2012 15:15:38 -0600
Message-ID: <4F036FF6.2080501@sgi.com>
Date: Tue, 03 Jan 2012 15:15:34 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore: incorrect restore if file becomes a dir
References: <20111226201856.GA3909@davidb.org>
In-Reply-To: <20111226201856.GA3909@davidb.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: David Brown <davidb@davidb.org>
Cc: xfs@oss.sgi.com

On 12/26/2011 02:18 PM, David Brown wrote:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=915
>
> I've had this happen again. It appears to be the case if between
> incremental dumps, a file is deleted and a directory is created that
> gets the same inode number. The restore leaves a file in place of the
> directory. If the new directory has any contents, xfsrestore prints a
> warning, and doesn't restore the subdirectory contents.
>
> Given the sparseness of inodes, this doesn't seem to occur all that
> frequently, but I do have a couple of backups that exhibit the
> behavior. If no one has any ideas, I'll start digging through
> xfsrestore to see if I can figure out what is happening.

I haven't looked at the relevant code, but it sounds like the inode
generation number would also have to be the same in order for this
to happen. Two inodes from separate backups are only considered to
be the same file or directory if the inode number and the lower 12
bits of the inode generation number are the same. It might be
possible to verify this is the case by turning up the message
level during the restore.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
