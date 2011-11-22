Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMEUxJb147867 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 08:30:59 -0600
Message-ID: <4ECBB21E.9040205@sgi.com>
Date: Tue, 22 Nov 2011 08:30:54 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: Interrupted xfsdump Resume Behaviour for Regular Dump File
References: <1321794858.60631.YahooMailClassic@web190714.mail.sg3.yahoo.com>
In-Reply-To: <1321794858.60631.YahooMailClassic@web190714.mail.sg3.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

If you look at the inventory after an interrupted backup, it
will indicate the stream (and media file) start and end points.
If the end point is "ino 0 offset 0", then a resumed restore
will end up backing up everything again.

If you can, please try this with the top-of-tree code from
the git tree on kernel.org. I did a quick test and it seems
to be working there.

Note that if you're backing up to stdout, xfsdump cannot
determine when the output is safely on media, so a resumed
backup will always be a full backup.

Bill

Gim Leong Chin wrote:
> Hi,
> 
> I have observed this since some time back.  I have just done an experiment.
> 
> 1) Using xfsdump 3.0.6, I first did a full dump to regular file and restore, checked that every thing is correct.
> 
> 2) I then did the same dump again, but interrupted it.  Then I resumed the dump.  I noted that the resumed dump file is the exact same size as the full dump file.
> 
> 3) First I did a cumulative restore, with the interrupted dump file, followed by the resumed dump file.  I checked that the restore is correct.
> 
> 4) I then did a non-cumulative restore, using only resumed dump file.  The resume is successful, and I checked that the restore is correct.
> 
> The logs are attached.
> 
> The conclusion is that the so-called resume of an interrupted dump session to regular file produces a full dump file, that is sufficient by itself to do the full restore.
> 
> Are my observations of the behaviour of xfsdump correct?
> 
> 
> Everything was done on openSUSE 11.4 x86_64.
> 
> 
> GL
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
