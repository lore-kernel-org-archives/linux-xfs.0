Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F1877F51
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:14:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2232430405F
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:14:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id xTddIyQCUghyUqiE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:14:19 -0700 (PDT)
Date: Sun, 21 Jun 2015 02:14:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_metadump: obfuscate remote symlinks on CRC filesystems
Message-ID: <20150621091419.GA26833@infradead.org>
References: <55847BE8.8010908@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55847BE8.8010908@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 19, 2015 at 03:30:32PM -0500, Eric Sandeen wrote:
> On CRC filesystems, the symlink block starts with a header,
> which contains magic, "XLSM"
> 
> The code happens to "work" today w/o corrupting anything,
> because it seems "XSLM" as a string, decides it's too short
> to obfuscate, and leaves it alone.
> 
> But the real symlink target is untouched.  Fix that by moving
> the pointer to the string we want to obfuscate by the size
> of the header, and shorten the length to obfuscate accordingly.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Any chance to get a test for this into xfstests?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
