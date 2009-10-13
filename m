Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DMIH52156772 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:18:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68052C25FAA
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:19:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id i6ns5CT0rwPNAFDK for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:19:47 -0700 (PDT)
Date: Tue, 13 Oct 2009 18:19:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/14] repair: split up scanfunc_ino
Message-ID: <20091013221946.GB31385@infradead.org>
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175840.403232401@bombadil.infradead.org>
	<4AD38C50.2060403@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AD38C50.2060403@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 12, 2009 at 03:06:40PM -0500, Eric Sandeen wrote:
>> +					agno, agbno,
>> +				mp->m_sb.sb_inopblock);
>
> pretty weird indentation here can't you just merge w/ previous line?

XFS (especially userspace code) uses this in lots of places.  Gives
more space to messages but keeps the normal arguments normally aligned.

> Also is the change from bno to agbno intentional in the message?
> I guess it's fine.

That version is more correct.  Don't remember how it got in, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
