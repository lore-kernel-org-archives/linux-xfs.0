Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7TEBdNO075102 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 09:11:39 -0500
Message-ID: <4E5B9E17.4010504@sgi.com>
Date: Mon, 29 Aug 2011 09:11:35 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore Does Only Only Partial Restore
References: <1314534700.48540.YahooMailClassic@web77701.mail.sg1.yahoo.com>
In-Reply-To: <1314534700.48540.YahooMailClassic@web77701.mail.sg1.yahoo.com>
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

Gim Leong Chin wrote:
> Hi,
> 
> This is the very first time I tried doing a xfsrestore of a back up and I hit some serious trouble.
> 
> I had openSUSE 11.1 (kernel 2.6.27) on my Acer notebook.  I did a xfsdump of /home to a WD My Passport external USB hard drive with XFS on it.
> 
> I installed openSUSE 11.4 (kernel 2.6.37), then tried to do xfsrestore from the WD USB drive.  The dump file is 121 GB.
> 
> I tried two times on two different days, but each time the xfsrestore would stop writing at the exact same point, 49 GB and say success at the end.
> 
> I then copied the dump file to one hard drive on my desk top, and did a dump to another hard drive, to /tmp/mnt3.  I get back identical messages:
> 

...

> 9>xfsrestore: attempt to read 1008286921 bytes failed: end of recorded data

xfsdump breaks a file's data into "extents" that are a max size of 16 MB.
The fact that this is trying to read almost 1 GB here indicates that
the extend header is corrupt.

...

>   xfsrestore: content.c:7510: restore_extent_group: Assertion `ehdr.eh_type == 4' failed.

As Dave said, this also indicates a corrupt extent header.

I'd recommend adding "-v 5" to your xfsrestore command line and redirecting the
(very verbose) output to a file, and send that compressed output to me or the
list. It'd be best to do this with more than one of your dumps so we can see
if there's a pattern to where the corruption occurs.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
