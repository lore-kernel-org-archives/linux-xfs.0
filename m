Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 102047F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:34:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1C2830406B
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:34:19 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QCSY3uzYzY2rcDuL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:34:18 -0800 (PST)
Date: Thu, 27 Feb 2014 12:34:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: don't leak fd in open -Tr failure case
Message-ID: <20140227203413.GA4568@infradead.org>
References: <530F9F37.8020408@redhat.com>
 <530FA0EF.50301@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530FA0EF.50301@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 27, 2014 at 02:32:47PM -0600, Eric Sandeen wrote:
> On 2/27/14, 2:25 PM, Eric Sandeen wrote:
> > Coverity spotted this.
> > 
> > It complained that we didn't close the fd before returning in
> > this case of incompatible options, but it seems like we should
> > just test for the incompatible flags before even trying to open
> > the file, no?
> > 
> > (The open would have failed in any case, but with a somewhat
> > cryptic "Invalid argument" - so it's probably better to state
> > it plainly and bail immediately.)
> 
> So actually, we wouldn't leak, because the open would fail.
> So I guess it's not the best subject & description...

It's not, but doing the check earlier seems sensible.

Reviewed-by: Christoph Hellwig <hch@lst.de>

(with a better description)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
