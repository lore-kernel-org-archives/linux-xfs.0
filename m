Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C82537F83
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2014 08:33:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A47A38F8059
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2014 06:33:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id jRhnskmRn7ZaAa45 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 22 Mar 2014 06:32:57 -0700 (PDT)
Date: Sat, 22 Mar 2014 06:32:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [FAQ] XFS speculative preallocation
Message-ID: <20140322133252.GA20779@infradead.org>
References: <20140321162920.GA3087@laptop.bfoster>
	<87eh1vuxam.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87eh1vuxam.fsf@mid.deneb.enyo.de>
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
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Mar 21, 2014 at 09:11:29PM +0100, Florian Weimer wrote:
> I see rather dramatic fragmentation of the systemd journal when it is
> stored on XFS, and it calls posix_fallocate before writing data to the
> file.

You mean it calls fallocate before each write?  That's not very useful
behaviour and should be fixed.  If it calls fallocate for the whole
expeted file size (or large increments) it should not fragment the file,
and if it does there's a bug we'd need to look into.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
