Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 941E77F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:09:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 818518F804B
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:09:06 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IaGNLGswVEcUmpIs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:09:05 -0700 (PDT)
Date: Fri, 19 Jun 2015 08:09:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs.xfs: always use underlying fs sector size when
	mkfs'ing	a file
Message-ID: <20150619150904.GB22842@infradead.org>
References: <55820229.1010701@redhat.com>
	<14667996.16447259.1434625419793.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <14667996.16447259.1434625419793.JavaMail.zimbra@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 18, 2015 at 07:03:39AM -0400, Jan Tulak wrote:
> This changes get_topology only for ENABLE_BLKID branch of #ifdef. Is that intentional, i.e. we don't expect anyone not using ENABLE_BLKID? Because otherwise, if mkfs is compiled without ENABLE_BLKID, then all we get is:

I'm in favor of killing the !ENABLE_BLKID entirely.  The proper
support in blkid has been around long enough to require it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
