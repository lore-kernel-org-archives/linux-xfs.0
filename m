Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8EHjjTW071604 for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 12:45:45 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A11044EE4E
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 10:46:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KEG8slM5GsLqtV1U for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2009 10:46:58 -0700 (PDT)
Message-ID: <4AAE8180.6020609@sandeen.net>
Date: Mon, 14 Sep 2009 12:46:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_log_force: error 5 returend
References: <20090914100548.45440@gmx.net>
	<20090914164138.GA13081@infradead.org>
In-Reply-To: <20090914164138.GA13081@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Steffen Knauf <Steffen.Knauf@gmx.net>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Sep 14, 2009 at 12:05:48PM +0200, Steffen Knauf wrote:
>> hello,
>>
>> sometimes, our server crashed with xfs_log_force: error 5.
>> It isn't reproducible and a xfs_check / xfs_repair don't find some errors.
>>
>> Perhaps it's a bug?  
> 
> Error 5 is EIO, and xfs_log_force basically passed the error through
> from the underlying device.  Most likely it is an issue with the
> underlying storage device.

Also, just to be semantically correct, it's unlikely that this was a
"server crash" - most likely you got an IO error, xfs noticed it, and
shut itself down for safety.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
