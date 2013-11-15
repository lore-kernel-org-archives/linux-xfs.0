Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B0E77F89
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 08:11:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 488EC304048
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 06:11:16 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0aJXRoSOFw2wht8e (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 06:11:15 -0800 (PST)
Date: Fri, 15 Nov 2013 06:11:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] list: introduce list_last_entry_or_null()
Message-ID: <20131115141100.GA17659@infradead.org>
References: <5285A33C.4040808@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5285A33C.4040808@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, oleg@redhat.com, akpm@linux-foundation.org

On Fri, Nov 15, 2013 at 12:29:48PM +0800, Jeff Liu wrote:
> Hi Folks,
> 
> This patch is trying to introduce a new list helper to retrieve the
> last entry or return NULL if the list is empty corresponding to it,
> which is inspired by Jiri Pirko's list_first_entry_or_null().

How did we end up with the stupid _or_null prefix there?  I think the
functionality is useful, but the naming is way to verbose, especially
given that a list_first_entry or list_last_entry that optimizes away
that one check doesn't seem useful.

Instead of encoding detailed semantics in the name a good kerneldoc
comment is way better.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
