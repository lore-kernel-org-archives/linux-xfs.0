Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E91FF7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 10:34:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD71C30407A
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 08:34:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JPHT9BJDM6v0EhBG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 08:34:23 -0700 (PDT)
Date: Tue, 25 Mar 2014 08:34:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] remove ancient sys_getdents code paths
Message-ID: <20140325153422.GA31551@infradead.org>
References: <20140324181920.GG23291@redacted.bos.redhat.com>
	<20140325141553.GB18691@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140325141553.GB18691@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Kyle McMartin <kmcmarti@redhat.com>, xfs@oss.sgi.com

On Tue, Mar 25, 2014 at 10:15:55AM -0400, Brian Foster wrote:
> I wonder if we could clean up the d_name offset checks to check it once
> and use a flag. Or use a signed type for size_diff and trigger off that.
> Just a thought, fwiw.

I'd just leave the code as-is and just remove the ifdef cruft.  If
anyone is motivated enough to do real work on this area the callers
should simply be switched to readdir(3) and friends instead of
bikeshedding the current cruft.  I just don't want to put even more load
on Kyle how just wants to get xfsdump running on arm64..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
