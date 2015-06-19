Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 644997F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:17:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0CD1AC009
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:17:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4ASogiD9tCa0z1Nr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:17:12 -0700 (PDT)
Message-ID: <55843276.5020804@redhat.com>
Date: Fri, 19 Jun 2015 10:17:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs: always use underlying fs sector size when
	mkfs'ing a file
References: <55820229.1010701@redhat.com>
	<14667996.16447259.1434625419793.JavaMail.zimbra@redhat.com>
	<20150619150904.GB22842@infradead.org>
In-Reply-To: <20150619150904.GB22842@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/19/15 10:09 AM, Christoph Hellwig wrote:
> On Thu, Jun 18, 2015 at 07:03:39AM -0400, Jan Tulak wrote:
>> This changes get_topology only for ENABLE_BLKID branch of #ifdef. Is that intentional, i.e. we don't expect anyone not using ENABLE_BLKID? Because otherwise, if mkfs is compiled without ENABLE_BLKID, then all we get is:
> 
> I'm in favor of killing the !ENABLE_BLKID entirely.  The proper
> support in blkid has been around long enough to require it.
> 

though we also claim to nominally support building on osx, irix, etc, which doesn't have that library, right?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
