Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D0A27F4E
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 09:49:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 513378F8037
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 07:49:06 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nNIcz17IBosjeD07 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 07:48:59 -0700 (PDT)
Date: Wed, 21 May 2014 07:48:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/2] xfs: sysfs attribute support
Message-ID: <20140521144859.GB3580@infradead.org>
References: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Fri, May 16, 2014 at 02:12:44PM -0400, Brian Foster wrote:
> Hi all,
> 
> This is an rfc to get some discussion rolling on sysfs support for XFS.
> The motivation for this work is here:
> 
> http://oss.sgi.com/archives/xfs/2014-05/msg00381.html

All the sysfs magic for this looks pretty ugly.  Why can't we just
dump it into debugfs given that it's very much a debug only feature
anyway?

It would also be really nitfy to have a tool to fronted it in the style
of xfs_db and xfs_io..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
